<?php

namespace App\Transformers;

use App\Models\Customer;
use League\Fractal\TransformerAbstract;

class CustomerTransformer extends TransformerAbstract
{
    /**
     * @param \App\Customer $customer
     * @return array
     */
    public function transform(Customer $customer): array
    {
        return [
            'id'                => $customer->id,
            'first_name'        => $customer->first_name,
            'last_name'         => $customer->last_name,
            'username'          => $customer->username,
            'provider_id'       => $customer->provider_id,
            'status'            => $customer->status,
            'description'       => $customer->description,
            'user_type'         => $customer->user_type,
            'email'             => $customer->email,
            'phone_number'    => $customer->phone_number,
            'country_id'        => $customer->country_id,
            'state_id'          => $customer->state_id,
            'city_id'           => $customer->city_id,
            'city_name'         => optional($customer->city)->name,
            'address'           => $customer->address,
            'status'            => $customer->status,
            'providertype_id'   => $customer->providertype_id,
            'providertype'      => optional($customer->providertype)->name,
            'is_featured'       => $customer->is_featured,
            'display_name'      => $customer->display_name,
            'created_at'        => $customer->created_at,
            'updated_at'        => $customer->updated_at,
            'deleted_at'        => $customer->deleted_at,
            'profile_image'     => getSingleMedia($customer, 'profile_image',null),
            'time_zone'         => $customer->time_zone,
            'uid'               => $customer->uid,
            'login_type'        => $customer->login_type,
            'service_address_id'=> $customer->service_address_id,
            'last_notification_seen' => $customer->last_notification_seen,
            'isHandymanAvailable' =>  $customer->is_available,
            'designation' => $customer->designation,
            'handymantype_id' => $customer->handymantype_id,
            'handymantype' => optional($customer->handymantype)->name,
        ];
    }
}