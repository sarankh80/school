<?php

namespace App\Transformers;

use League\Fractal\TransformerAbstract;
use App\Models\BookingItem;

/**
 * Class ItemTransformer.
 *
 * @package namespace App\Transformers;
 */
class ItemTransformer extends TransformerAbstract
{
    /**
     * List of resources to automatically include
     *
     * @var array
     */
    protected  array $defaultIncludes = [];
    /**
     * Transform the BookingItem model.
     *
     * @param \App\Models\BookingItem $item
     *
     * @return array
     */
    public function transform(BookingItem $item): array 
    {
        return [
            'id'                    => (int) $item->id, 
            'booking_id'            => $item->booking_id,
            'service_name'          => optional($item->service)->name,
            'service_attchments'    => getAttachments(optional($item->service)->getMedia('service_attachment'), null),
            'price'                 => optional($item->service)->price,
            'quantity'              => $item->quantity,
            // 'discount'              => optional($item->service)->discount,
            'discount'              => "$item->discount_percent",
            'total'                 => $item->total,
            'created_at'            => $item->created_at,
            'updated_at'            => $item->updated_at
        ];
    }
}
