<?php

namespace App\Transformers;

use App\Models\Provider;
use League\Fractal\TransformerAbstract;

class ProviderTransformer extends TransformerAbstract
{
    /**
     * @param \App\Provider $provider
     * @return array
     */
    public function transform(Provider $provider): array
    {
        return [
            'id'                => $provider->id,
            'first_name'        => $provider->first_name,
            'last_name'         => $provider->last_name,
            'username'          => $provider->username,
            'provider_id'       => $provider->provider_id,
            'status'            => $provider->status,
            'description'       => $provider->description,
            'user_type'         => $provider->user_type,
            'email'             => $provider->email,
            'phone_number'    => $provider->phone_number,
            'country_id'        => $provider->country_id,
            'state_id'          => $provider->state_id,
            'city_id'           => $provider->city_id,
            'city_name'         => optional($provider->city)->name,
            'address'           => $provider->address,
            'status'            => $provider->status,
            'providertype_id'   => $provider->providertype_id,
            'providertype'      => optional($provider->providertype)->name,
            'is_featured'       => $provider->is_featured,
            'display_name'      => $provider->display_name,
            'created_at'        => $provider->created_at,
            'updated_at'        => $provider->updated_at,
            'deleted_at'        => $provider->deleted_at,
            'profile_image'     => getSingleMedia($provider, 'profile_image',null),
            'time_zone'         => $provider->time_zone,
            'uid'               => $provider->uid,
            'login_type'        => $provider->login_type,
            'service_address_id'=> $provider->service_address_id,
            'last_notification_seen' => $provider->last_notification_seen,
            'providers_service_rating' => 0,
            'is_verify_provider' => (int) verify_provider_document($provider->id),
            'isHandymanAvailable' =>  $provider->is_available,
            'designation' => $provider->designation,
            'handymantype_id' => $provider->handymantype_id,
            'handymantype' => optional($provider->handymantype)->name,
        ];
    }
}