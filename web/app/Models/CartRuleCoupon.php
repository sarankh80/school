<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\Factory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use App\Database\Factories\CartRuleCouponFactory;
use App\Contracts\CartRuleCoupon as CartRuleCouponContract;

class CartRuleCoupon extends Model implements CartRuleCouponContract
{
    use HasFactory;

    protected $fillable = [
        'code',
        'usage_limit',
        'usage_per_customer',
        'times_used',
        'type',
        'cart_rule_id',
        'expired_at',
        'is_primary',
    ];

    /**
     * Get the cart rule that owns the cart rule coupon.
     */
    public function cart_rule(): BelongsTo
    {
        return $this->belongsTo(CartRuleProxy::modelClass());
    }

    /**
     * Get the cart rule that owns the cart rule coupon.
     */
    public function coupon_usage()
    {
        return $this->hasMany(CartRuleCouponUsageProxy::modelClass());
    }

    /**
     * Create a new factory instance for the model
     *
     * @return Factory
     */
    protected static function newFactory(): Factory
    {
        return CartRuleCouponFactory::new();
    }
}