<?php

namespace App\Transformers;

use League\Fractal\TransformerAbstract;
use App\Models\Booking;
use App\Models\Invoice;

/**
 * Class InvoiceTransformer.
 *
 * @package namespace App\Transformers;
 */
class InvoiceTransformer extends TransformerAbstract
{
    /**
     * List of resources to automatically include
     *
     * @var array
     */
    protected  array $defaultIncludes = ['items', 'customer', 'provider'];

    /**
     * Transform the Service model.
     *
     * @param \App\Models\Service $model
     *
     * @return array
     */
    public function transform(Invoice $invoice): array 
    {
        return [
            'id'                    => $invoice->id,
            'customer_id'           => $invoice->customer_id,
            'provider_id'           => $invoice->provider_id,
            'booking_id'            => $invoice->booking_id,
            'total_qty'             => $invoice->total_qty,
            'discount_amount'       => number_format($invoice->discount_amount, 2, '.', ''),
            'shipping_amount'       => number_format($invoice->shipping_amount, 2, '.', ''),
            'currency_code'         => $invoice->currency_code,
            'sub_total'             => number_format($invoice->sub_total, 2, '.', ''),
            'grand_total'           => number_format($invoice->grand_total, 2, '.', ''),
            'date'                  => $invoice->created_at->format('Y-m-d H:i:s'),
            'status'                => $invoice->state
        ];
    }

    /**
     * Include Items
     *
     * @param Booking $booking
     * @return \League\Fractal\Resource\collection
     */
    public function includeItems(Invoice $invoice)
    {
        $items = $invoice->items;

        return $this->collection($items, new InvoiceItemTransformer);
    }

    /**
     * Include Customer
     *
     * @param Booking $booking
     * @return \League\Fractal\Resource\collection
     */
    public function includeCustomer(Invoice $invoice)
    {
        $customer = optional($invoice)->customer;

        return $this->item($customer, new CustomerTransformer);
    }

    /**
     * Include Provider
     *
     * @param Booking $booking
     * @return \League\Fractal\Resource\collection
     */
    public function includeProvider(Invoice $invoice)
    {
        $provider = optional($invoice)->provider;

        if(!empty($provider))
        {
            return $this->item($provider, new ProviderTransformer);

        }
    }
}
