<?php

namespace App\Transformers;

use App\Models\CustomerAddress;
use League\Fractal\TransformerAbstract;

class CustomerAddressTransformer extends TransformerAbstract
{
    /**
     * List of resources to automatically include
     *
     * @var array
     */
    protected  array $defaultIncludes = [];

    /**
     * @param \App\CustomerAddress $customerAddress
     * @return array
     */
    public function transform(CustomerAddress $customerAddress): array
    {

        return [
            'id' => (int) $customerAddress->id,
            'customer_id' => (int) $customerAddress->addressable_id,
            'latitude' => $customerAddress->latitude,
            'longitude' => $customerAddress->longitude,
            'title' => $customerAddress->title,
            'type' => $customerAddress->type,
            'floor' => $customerAddress->floor,
            'note' => $customerAddress->note,
            'address' => $customerAddress->address,
            'is_default' => $customerAddress->is_default,
            'status' => $customerAddress->status,
            'image' => getSingleMedia($customerAddress, 'address_image',null),
            'created_at' => $customerAddress->created_at,
            'updated_at' => $customerAddress->updated_at
        ];
    }
}