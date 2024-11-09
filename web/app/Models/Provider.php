<?php

namespace App\Models;

use Parental\HasParent;
use Illuminate\Database\Eloquent\Casts\Attribute;

class Provider extends User
{
    use HasParent;

    protected $guard_name = 'web';

    /**
     * Interact with the provider's password.
     *
     * @return \Illuminate\Database\Eloquent\Casts\Attribute
     */
    protected function password(): Attribute
    {
        return Attribute::make(
            get: fn ($value) => $value,
            set: fn ($value) => bcrypt($value)
        );
    }

    public function providerType(){
        return $this->belongsTo(ProviderType::class, 'providertype_id','id');
    }

    /**
     * Get the services children that owns the Service
     *
     * @return \Illuminate\Database\Eloquent\Relations\BelongsToMany
     */
    public function taxes(){
        return $this->belongsToMany(Tax::class, 'provider_taxes', 'provider_id', 'tax_id');
    }

    /**
     * Get the services that owns the Address
     *
     * @return \Illuminate\Database\Eloquent\Relations\BelongsToMany
     */
    public function services()
    {
        return $this->belongsToMany(Service::class, 'address_provider_service', 'provider_id', 'service_id');
    }

    /**
     * Get the services that owns the Address
     *
     * @return \Illuminate\Database\Eloquent\Relations\BelongsToMany
     */
    public function addresses()
    {
        return $this->belongsToMany(Address::class, 'address_provider_service', 'provider_id', 'address_id')->distinct();
    }

    /**
     * Check phone number is verified.
     *
     * @return Bool
     */
    public function phoneVerified()
    {
        return ! is_null($this->phone_verified_at);
    }

    /**
     * Post verification phone number.
     *
     * @return Bool
     */
    public function phoneVerifiedAt()
    {
        return $this->forceFill([
            'phone_verified_at' => $this->freshTimestamp(),
        ])->save();
    }

    public function scopePhoneNotVerified($query)
    { 
        return $query->whereNull('phone_verified_at');
    }
}
