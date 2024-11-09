<?php

namespace App\Transformers;

use App\Models\Brand;
use League\Fractal\TransformerAbstract;

class BrandTransformer extends TransformerAbstract
{
    /**
     * @param \App\Brand $brand
     * @return array
     */
    public function transform(Brand $brand): array
    {
        return [
            'id' => (int) $brand->id,
            'name' => $brand->name?? "",
            'status' => $brand->status,
            'created_at' => $brand->created_at,
            'updated_at' => $brand->updated_at,
            'deleted_at' => $brand->deleted_at
        ];
    }
}