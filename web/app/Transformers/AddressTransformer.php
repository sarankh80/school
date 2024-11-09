<?php

namespace App\Transformers;

use App\Models\Address;
use League\Fractal\TransformerAbstract;

class AddressTransformer extends TransformerAbstract
{
    /**
     * @param \App\Model\Address $address
     * @return array
     */
    public function transform(Address $address): array
    {
        return [
            'id' => (int) $address->id,
            'customer_id' => (int) $address->addressable_id,
            'type' => $address->type,
            'title' => $address->title,
            'address' => $address->address,
            'note' => $address->note,
            'floor' => $address->floor,
            'latitude' => $address->latitude,
            'longitude' => $address->longitude,
            'is_default' => $address->is_default,
            'status' => $address->status,
            'created_at' => $address->created_at,
            'updated_at' => $address->updated_at,
            'deleted_at' => $address->deleted_at
        ];
    }
}