<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Factories\Factory;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Database\Factories\CartAddressFactory;
use App\Contracts\CartAddress as CartAddressContract;
use Illuminate\Database\Eloquent\Model;

/**
 * Class CartAddress
 *
 * @package Webkul\Checkout\Models
 *
 * @property integer $cart_id
 * @property Cart $cart
 *
 */
class CartAddress extends Model implements CartAddressContract
{
    use HasFactory;

    protected $table = 'address_cart';

    public const ADDRESS_TYPE_SHIPPING = 'cart_shipping';

    public const ADDRESS_TYPE_BILLING = 'cart_billing';

    /**
     * @var array default values
     */
    protected $attributes = [
        'address_type' => self::ADDRESS_TYPE_BILLING,
    ];

    /**
     * The "booted" method of the model.
     *
     * @return void
     */
    protected static function boot(): void
    {
        static::addGlobalScope('address_type', static function (Builder $builder) {
            $builder->whereIn('address_type', [
                self::ADDRESS_TYPE_BILLING,
                self::ADDRESS_TYPE_SHIPPING,
            ]);
        });

        parent::boot();
    }

    /**
     * Get the shipping rates for the cart address.
     */
    public function shipping_rates(): HasMany
    {
        return $this->hasMany(CartShippingRate::class);
    }

    /**
     * Get the cart record associated with the address.
     */
    public function cart(): BelongsTo
    {
        return $this->belongsTo(Cart::class);
    }

    /**
     * Create a new factory instance for the model
     *
     * @return Factory
     */
    protected static function newFactory(): Factory
    {
        return CartAddressFactory::new();
    }
}