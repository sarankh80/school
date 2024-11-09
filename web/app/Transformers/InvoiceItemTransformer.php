<?php

namespace App\Transformers;

use League\Fractal\TransformerAbstract;
use App\Models\InvoiceItem;

/**
 * Class InvoiceItemTransformer.
 *
 * @package namespace App\Transformers;
 */
class InvoiceItemTransformer extends TransformerAbstract
{
    /**
     * List of resources to automatically include
     *
     * @var array
     */
    protected  array $defaultIncludes = [];
    /**
     * Transform the InvoiceItem model.
     *
     * @param \App\Models\InvoiceItem $item
     *
     * @return array
     */
    public function transform(InvoiceItem $item): array 
    {
        return [
            'id'                    => (int) $item->id, 
            'invoice_id'            => $item->invoice_id,
            'service_id'            => $item->service_id,
            'sku'                   => $item->sku,
            'name'                  => $item->name,
            'description'           => $item->description,
            'base_price'            => $item->base_price,
            'price'                 => $item->price,
            'quantity'              => $item->qty,
            'discount_percent'      => $item->discount_percent,
            'discount_amount'       => $item->discount_amount,
            'base_total'            => $item->base_total,
            'total'                 => $item->total,
            'created_at'            => $item->created_at,
            'updated_at'            => $item->updated_at
        ];
    }
}
