<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class CartRuleCouponUsage extends Model
{
    public $timestamps = false;
    
    protected $table = 'cart_rule_coupon_usage';

    protected $guarded = [
        'created_at',
        'updated_at',
    ];
}