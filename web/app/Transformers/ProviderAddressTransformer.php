<?php

namespace App\Transformers;

use App\Models\ProviderAddress;
use League\Fractal\TransformerAbstract;

class ProviderAddressTransformer extends TransformerAbstract
{
    /**
     * List of resources to automatically include
     *
     * @var array
     */
    protected  array $defaultIncludes = ['services'];

    /**
     * @param \App\ProviderAddress $providerAddress
     * @return array
     */
    public function transform(ProviderAddress $providerAddress): array
    {

        return [
            'id' => (int) $providerAddress->id,
            'provider_id' => (int) $providerAddress->addressable_id,
            'latitude' => $providerAddress->latitude,
            'longitude' => $providerAddress->longitude,
            'address' => $providerAddress->address,
            'status' => $providerAddress->status,
            'created_at' => $providerAddress->created_at,
            'updated_at' => $providerAddress->updated_at
        ];
    }

    /**
     * Include services
     *
     * @param ProviderAddress $providerAddress
     * @return \League\Fractal\Resource\collection
     */
    public function includeServices(ProviderAddress $providerAddress)
    {
        $providerAddresses = $providerAddress->services;

        return $this->collection($providerAddresses, new ServiceTransformer);
    }
}