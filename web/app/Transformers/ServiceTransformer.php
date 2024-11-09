<?php

namespace App\Transformers;

use League\Fractal\TransformerAbstract;
use App\Models\Service;
use League\Fractal\Serializer\ArraySerializer;
use App\Http\Controllers\API\ServiceController;

/**
 * Class ServiceTransformer.
 *
 * @package namespace App\Transformers;
 */
class ServiceTransformer extends TransformerAbstract
{    
    /**
     * Transform the Service model.
     *
     * @param \App\Models\Service $model
     *
     * @return array
     */
    public function transform(Service $service): array 
    {
        $price = $service->price - (($service->price * $service->discount) / 100);
        $translate = $service->translate;
        return [
            'id'            => (int) $service->id, 
            'sku'           => $service->sku,
            'name'          => $translate->first()->name?? $service->name,
            'category_id'   => $service->category_id,
            'brand_id'      => $service->brand_id,
            'base_price'    => $service->price,
            'price'         => number_format($price, 2, '.', ''),
            'unit'          => optional($service->unit)->name,
            'duration'      => $service->duration,
            'discount'      => $service->discount ?? "0.00",
            'status'        => $service->status,
            'is_featured'   => $service->is_featured,
            'user_id'       => $service->added_by,
            'price_estimate' => $service->price_estimate,
            'attchments' => getAttachments($service->getMedia('service_attachment')),
            'attchments_array' => getAttachmentArray($service->getMedia('service_attachment'),null),
            'total_review'  => $service->serviceRating->count('id'),
            'total_rating'  => $service->totalRated(),
            'is_favourite' => $service->isFavoritedCustomer(),
            'description'   => $translate->first()->des?? ($service->description ?? ''),
            'included'   => $translate->first()->included?? ($service->included ?? ''),
            'excluded'   => $translate->first()->excluded?? ($service->excluded ?? ''),
            'created_at'    => $service->created_at,
            'updated_at'    => $service->updated_at
        ];
    }
}
