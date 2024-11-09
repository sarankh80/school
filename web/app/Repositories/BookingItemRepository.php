<?php

namespace App\Repositories;

use Prettus\Repository\Eloquent\BaseRepository;
use Prettus\Repository\Criteria\RequestCriteria;
use App\Models\BookingItem;

/** 
 * Class BookingItemRepository.
 *
 * @package namespace App\Repositories;
 */
class BookingItemRepository extends BaseRepository
{
    /**
     * Specify Model class name
     *
     * @return string
     */
    public function model()
    {
        return BookingItem::class;
    }
    

    /**
     * Boot up the repository, pushing criteria
     */
    public function boot()
    { 
        $this->pushCriteria(app(RequestCriteria::class));
    }

    /**
     * Collect totals.
     *
     * @param  \App\Models\BookingItem  $bookingItem
     * @return \App\Models\BookingItem
     */
    public function collectTotals($bookingItem)
    {
        $qtyShipped = $qtyInvoiced = $qtyRefunded = 0;

        $totalInvoiced = $baseTotalInvoiced = 0;
        $taxInvoiced = $baseTaxInvoiced = 0;

        $totalRefunded = $baseTotalRefunded = 0;
        $taxRefunded = $baseTaxRefunded = 0;

        foreach ($bookingItem->invoice_items as $invoiceItem) {
            $qtyInvoiced += $invoiceItem->qty;

            $totalInvoiced += $invoiceItem->total;
            $baseTotalInvoiced += $invoiceItem->base_total;
        }

        foreach ($bookingItem->shipment_items as $shipmentItem) {
            $qtyShipped += $shipmentItem->qty;
        }

        foreach ($bookingItem->refund_items as $refundItem) {
            $qtyRefunded += $refundItem->qty;

            $totalRefunded += $refundItem->total;
            $baseTotalRefunded += $refundItem->base_total;

            $taxRefunded += $refundItem->tax_amount;
            $baseTaxRefunded += $refundItem->base_tax_amount;
        }

        $bookingItem->qty_shipped = $qtyShipped;
        $bookingItem->qty_invoiced = $qtyInvoiced;
        $bookingItem->qty_refunded = $qtyRefunded;

        $bookingItem->total_invoiced = $totalInvoiced;
        $bookingItem->base_total_invoiced = $baseTotalInvoiced;

        $bookingItem->tax_amount_invoiced = $taxInvoiced;
        $bookingItem->base_tax_amount_invoiced = $baseTaxInvoiced;

        $bookingItem->amount_refunded = $totalRefunded;
        $bookingItem->base_amount_refunded = $baseTotalRefunded;

        $bookingItem->tax_amount_refunded = $taxRefunded;
        $bookingItem->base_tax_amount_refunded = $baseTaxRefunded;

        $bookingItem->save();

        return $bookingItem;
    }
}
