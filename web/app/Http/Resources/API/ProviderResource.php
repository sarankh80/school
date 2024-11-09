<?php

namespace App\Http\Resources\API;

use Illuminate\Http\Resources\Json\JsonResource;

class ProviderResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return array
     */
    public function toArray($request)
    {
        $providers_service_rating = (float) 0;
        $handyman_rating = (float) 0;
        $is_verify_provider = false;

        return [
            'id'                => $this->id,
            'first_name'        => $this->first_name,
            'last_name'         => $this->last_name,
            'username'          => $this->username,
            'provider_id'       => $this->provider_id,
            'status'            => $this->status,
            'description'       => $this->description,
            'user_type'         => $this->user_type,
            'email'             => $this->email,
            'phone_number'    => $this->phone_number,
            'country_id'        => $this->country_id,
            'state_id'          => $this->state_id,
            'city_id'           => $this->city_id,
            'city_name'         => optional($this->city)->name,
            'address'           => $this->address,
            'status'            => $this->status,
            'providertype_id'   => $this->providertype_id,
            'providertype'      => optional($this->providertype)->name,
            'is_featured'       => $this->is_featured,
            'display_name'      => $this->display_name,
            'created_at'        => $this->created_at,
            'updated_at'        => $this->updated_at,
            'deleted_at'        => $this->deleted_at,
            'profile_image'     => getSingleMedia($this, 'profile_image',null),
            'time_zone'         => $this->time_zone,
            'uid'               => $this->uid,
            'login_type'        => $this->login_type,
            'service_address_id'=> $this->service_address_id,
            'last_notification_seen' => $this->last_notification_seen,
            'providers_service_rating' => $providers_service_rating,
            'handyman_rating' => $handyman_rating,
            'is_verify_provider' => (int) $is_verify_provider,
            'isHandymanAvailable' =>  $this->is_available,
            'designation' => $this->designation,
            'handymantype_id' => $this->handymantype_id,
            'handymantype' => optional($this->handymantype)->name,
            "user_role" => $this->getRoleNames(),
            'api_token' => $this->createToken('auth_token')->plainTextToken
        ];
    }
}
