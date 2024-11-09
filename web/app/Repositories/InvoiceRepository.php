<?php

namespace App\Repositories;

use Illuminate\Container\Container;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Event;
use App\Eloquent\Repository;
use App\Models\Invoice;

class InvoiceRepository extends Repository
{
    /**
     * Create a new repository instance.
     *
     * @param  \App\Repositories\BookingRepository  $bookingRepository
     * @param  \App\Repositories\BookingItemRepository  $bookingItemRepository
     * @param  \App\Repositories\InvoiceItemRepository  $invoiceItemRepository
     * @param  \App\Repositories\ServiceRepository  $serviceRepository
     * @param  \Illuminate\Container\Container  $container
     * @return void
     */
    public function __construct(
        protected BookingRepository $bookingRepository,
        protected BookingItemRepository $bookingItemRepository,
        protected InvoiceItemRepository $invoiceItemRepository,
        protected ServiceRepository $serviceRepository,
        Container $container
    )
    {
        parent::__construct($container);
    }

    /**
     * Specify model class name.
     *
     * @return string
     */
    public function model(): string
    {
        return Invoice::class;
    }

        
    /**
     * Transform the Invoice model.
     * 
     * @return App\Presenters\BookingPresenter
     */
    public function presenter()
    {
        return "App\\Presenters\\InvoicePresenter";
    }

    /**
     * Create invoice.
     *
     * @param  array  $data
     * @param  string $invoiceState
     * @param  string $bookingState
     * @return App\Models\Invoice
     */
    public function create(array $data, $invoiceState = null, $bookingState = null)
    {
        DB::beginTransaction();

        try {

            $booking = $this->bookingRepository->skipPresenter()->find($data['booking_id']);

            $totalQty = array_sum($data['invoice']['items']);
            $newItemQty = !empty($data['invoice']['services']) ? array_sum($data['invoice']['services']) : 0;
            $totalQty = $totalQty + $newItemQty;

            if (isset($invoiceState)) {
                $state = $invoiceState;
            } else {
                $state = 'paid';
            }

            $invoice = $this->model->create([
                'booking_id'              => $booking->id,
                'provider_id'               => $booking->provider_id,
                'customer_id'               => $booking->customer_id,
                'total_qty'             => $totalQty,
                'state'                 => $state,
                'currency_code'    => "USD",
                'address_id'      => $booking->booking_address_id,
            ]);

            foreach ($data['invoice']['items'] as $itemId => $qty) {
                if (! $qty) {
                    continue;
                }

                $bookingItem = $this->bookingItemRepository->find($itemId);

                if ($qty > $bookingItem->qty_to_invoice) {
                    $qty = $bookingItem->qty_to_invoice;
                }
                $invoiceItem = $this->invoiceItemRepository->create([
                    'invoice_id'           => $invoice->id,
                    'name'                 => optional($bookingItem->service)->name,
                    'sku'                  => optional($bookingItem->service)->sku,
                    'qty'                  => $qty,
                    'price'                => $bookingItem->price,
                    'total'                => $bookingItem->price * $qty,
                    'discount_amount'      => $bookingItem->discount,
                    'service_id'           => optional($bookingItem->service)->id                ]);

                // $this->bookingItemRepository->collectTotals($bookingItem);
            }
            if(!empty($data['invoice']['services']))
            {
                foreach ($data['invoice']['services'] as $serviceId => $qty) {
                    if (! $qty) {
                        continue;
                    }
    
                    $service = $this->serviceRepository->find($serviceId);
    
                    if ($qty > $bookingItem->qty_to_invoice) {
                        $qty = $bookingItem->qty_to_invoice;
                    }
    
                    $invoiceItem = $this->invoiceItemRepository->create([
                        'invoice_id'           => $invoice->id,
                        'name'                 => $service->name,
                        'sku'                  => $service->sku,
                        'qty'                  => $qty,
                        'price'                => $service->price,
                        'total'                => $service->price * $qty,
                        'discount_amount'      => $service->discount,
                        'service_id'           => $service->id
                    ]);
    
                    // $this->bookingItemRepository->collectTotals($bookingItem);
                }
            }

            $this->collectTotals($invoice);

            // $this->bookingRepository->collectTotals($booking);

            // if (isset($bookingState)) {
            //     $this->bookingRepository->updateOrderStatus($booking, $bookingState);
            // } else {
            //     $this->bookingRepository->updateOrderStatus($booking);
            // }
        } catch (\Exception $e) {
            DB::rollBack();

            throw $e;
        }

        DB::commit();

        return $invoice;
    }

    /**
     * Have product to invoice.
     *
     * @param  array  $data
     * @return bool
     */
    public function haveProductToInvoice(array $data): bool
    {
        foreach ($data['invoice']['items'] as $qty) {
            if ((int) $qty) {
                return true;
            }
        }

        return false;
    }

    /**
     * Is valid quantity.
     *
     * @param  array  $data
     * @return bool
     */
    public function isValidQuantity(array $data): bool
    {
        foreach ($data['invoice']['items'] as $itemId => $qty) {
            $bookingItem = $this->bookingItemRepository->find($itemId);

            if ($qty > $bookingItem->qty_to_invoice) {
                return false;
            }
        }

        return true;
    }

    /**
     * Collect totals.
     *
     * @param  \Webkul\Sales\Models\Invoice  $invoice
     * @return \Webkul\Sales\Models\Invoice
     */
    public function collectTotals($invoice)
    {
        $invoice->sub_total = 0;
        $invoice->tax_amount = 0;
        $invoice->discount_amount = 0;

        foreach ($invoice->items as $invoiceItem) {
            $invoice->sub_total += $invoiceItem->total;

            $invoice->tax_amount += $invoiceItem->tax_amount;

            $invoice->discount_amount += $invoiceItem->discount_amount;
        }

        $invoice->shipping_amount = $invoice->booking->shipping_amount;

        if ($invoice->booking->shipping_amount) {
            foreach ($invoice->booking->invoices as $prevInvoice) {
                if ((float) $prevInvoice->shipping_amount) {
                    $invoice->shipping_amount = $invoice->shipping_amount = 0;
                }
            }
        }

        $invoice->grand_total = $invoice->sub_total + $invoice->tax_amount + $invoice->shipping_amount - $invoice->discount_amount;

        $invoice->save();

        return $invoice;
    }

    /**
     * Update state.
     *
     * @param  \Webkul\Sales\Models\Invoice $invoice
     * @return void
     */
    public function updateState($invoice, $status)
    {
        $invoice->state = $status;
        $invoice->save();

        return true;
    }
}
