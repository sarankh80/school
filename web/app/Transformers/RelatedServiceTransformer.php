<?php

namespace App\Transformers;

use League\Fractal\TransformerAbstract;
use App\Models\Service;
use League\Fractal\Serializer\ArraySerializer;

/**
 * Class RelatedServiceTransformer.
 *
 * @package namespace App\Transformers;
 */
class RelatedServiceTransformer extends TransformerAbstract
{
    /**
     * List of resources to automatically include
     *
     * @var array
     */
    protected  array $defaultIncludes = [];
    /**
     * Transform the Service model.
     *
     * @param \App\Models\Service $model
     *
     * @return array
     */
    public function transform(Service $service): array 
    {
        return [
            'id'            => (int) $service->id, 
            'name'          => $service->name,
            'description'   => $service->description ?? '',
            'sku'           => $service->sku,
            'category_id'   => $service->category_id,
            'brand_id'      => $service->brand_id,
            'price'         => $service->price,
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
            'created_at'    => $service->created_at,
            'updated_at'    => $service->updated_at
        ];
    }
}
