<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\Factory;
use Illuminate\Database\Eloquent\Model;
use App\Contracts\Cart as CartContract;
use App\Database\Factories\CartFactory;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Cart extends Model implements CartContract
{
    use HasFactory;

    protected $table = 'cart';

    protected $guarded = [
        'id',
        'created_at',
        'updated_at',
    ];

    /**
     * To get relevant associated items with the cart instance
     */
    public function items(): \Illuminate\Database\Eloquent\Relations\HasMany
    {
        return $this->hasMany(CartItem::class)->whereNull('parent_id');
    }

    /**
     * To get all the associated items with the cart instance even the parent and child items of configurable products
     */
    public function all_items(): \Illuminate\Database\Eloquent\Relations\HasMany
    {
        return $this->hasMany(CartItem::class);
    }

    /**
     * Get the addresses for the cart.
     */
    public function addresses(): \Illuminate\Database\Eloquent\Relations\HasMany
    {
        return $this->hasMany(CartAddress::class);
    }

    /**
     * Get the billing address for the cart.
     */
    public function billing_address(): \Illuminate\Database\Eloquent\Relations\HasMany
    {
        return $this->addresses()
            ->where('address_type', CartAddress::ADDRESS_TYPE_BILLING);
    }

    /**
     * Get billing address for the cart.
     */
    public function getBillingAddressAttribute()
    {
        return $this->billing_address()->first();
    }

    /**
     * Get the shipping address for the cart.
     */
    public function shipping_address(): \Illuminate\Database\Eloquent\Relations\HasMany
    {
        return $this->addresses()
            ->where('address_type', CartAddress::ADDRESS_TYPE_SHIPPING);
    }

    /**
     * Get shipping address for the cart.
     */
    public function getShippingAddressAttribute()
    {
        return $this->shipping_address()->first();
    }

    /**
     * Get the shipping rates for the cart.
     */
    public function shipping_rates(): \Illuminate\Database\Eloquent\Relations\HasManyThrough
    {
        return $this->hasManyThrough(CartShippingRate::class, CartAddress::class, 'cart_id', 'cart_address_id');
    }

    /**
     * Get all the attributes for the attribute groups.
     */
    public function selected_shipping_rate(): \Illuminate\Database\Eloquent\Relations\HasManyThrough
    {
        return $this->shipping_rates()
            ->where('method', $this->shipping_method);
    }

    /**
     * Get all the attributes for the attribute groups.
     */
    public function getSelectedShippingRateAttribute()
    {
        return $this->selected_shipping_rate()
            ->where('method', $this->shipping_method)
            ->first();
    }

    /**
     * Get the payment associated with the cart.
     */
    public function payment(): \Illuminate\Database\Eloquent\Relations\HasOne
    {
        return $this->hasOne(CartPayment::class);
    }

    /**
     * Get the booking associated with the cart.
     */
    public function booking(): \Illuminate\Database\Eloquent\Relations\HasOne
    {
        return $this->hasOne(Booking::class);
    }

    /**
     * Get the customer cart.
     */
    public function customer()
    {
        return $this->belongsTo(Customer::class, 'customer_id', 'id');
    }

    /**
     * Get the channel cart.
     */
    public function channel()
    {
        return $this->belongsTo(Channel::class, 'channel_id', 'id');
    }

    /**
     * Checks if cart have stockable items
     *
     * @return boolean
     */
    public function haveStockableItems(): bool
    {
        foreach ($this->items as $item) {
            if ($item->product->isStockable()) {
                return true;
            }
        }

        return false;
    }

    /**
     * Checks if cart has downloadable items
     *
     * @return boolean
     */
    public function hasDownloadableItems(): bool
    {
        foreach ($this->items as $item) {
            if (stristr($item->type, 'downloadable') !== false) {
                return true;
            }
        }

        return false;
    }

    /**
     * Returns true if cart contains one or many products with quantity box.
     * (for example: simple, configurable, virtual)
     *
     * @return bool
     */
    public function hasProductsWithQuantityBox(): bool
    {
        foreach ($this->items as $item) {
            if ($item->product->getTypeInstance()->showQuantityBox()) {
                return true;
            }
        }

        return false;
    }

    /**
     * Checks if cart has items that allow guest checkout
     *
     * @return boolean
     */
    public function hasGuestCheckoutItems(): bool
    {
        foreach ($this->items as $item) {
            if (! $item->product->getAttribute('guest_checkout')) {
                return false;
            }
        }

        return true;
    }

    /**
     * Check minimum order.
     *
     * @return boolean
     */
    public function checkMinimumOrder(): bool
    {
        $minimumOrderAmount = (float)(core()->getConfigData('sales.orderSettings.minimum-order.minimum_order_amount') ?: 0);

        $cartBaseSubTotal = (float)$this->base_sub_total;

        return $cartBaseSubTotal >= $minimumOrderAmount;
    }


    /**
     * Create a new factory instance for the model
     *
     * @return Factory
     */
    protected static function newFactory(): Factory
    {
        return CartFactory::new();
    }
}
