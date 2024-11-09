<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class CartShippingRate extends Model
{
    protected $fillable = [
        'carrier',
        'carrier_title',
        'method',
        'method_title',
        'method_description',
        'price',
        'base_price',
        'discount_amount',
        'base_discount_amount',
    ];

    /**
     * Get the post that owns the comment.
     */
    public function shipping_address()
    {
        return $this->belongsTo(CartAddress::class, 'cart_address_id')->where('address_type', CartAddress::ADDRESS_TYPE_SHIPPING);
    }
}