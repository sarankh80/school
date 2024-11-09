<?php

namespace App\Models;

use Parental\HasParent;

class Customer extends User
{
    use HasParent;

    /**
     * Get the customer group that owns the customer.
     *
     * @return \Illuminate\Database\Eloquent\Relations\BelongsTo
     */
    public function group()
    {
        return $this->belongsTo(CustomerGroup::class, 'customer_group_id');
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
