<?php

namespace App\Traits;

/**
 * Cart coupons. In this trait, you will get all sorted collections of
 * methods which can be use for coupon in cart.
 *
 * Note: This trait will only work with the Cart facade. Unless and until,
 * you have all the required repositories in the parent class.
 */
trait CartCoupons
{
    /**
     * Set coupon code to the cart.
     *
     * @param  string  $code
     * @return App\Contracts\Cart
     */
    public function setCouponCode($code, $cartId = NULL)
    {
        $cart = $this->getCart($cartId);
        $cart->coupon_code = $code;
        $cart->save();
        return $this;
    }
    public function setCouponCodeItem($code, $cartId = NULL)
    {
        $cart = $this->getCart($cartId);        
        $item = $cart->items()->where('cart_id',$cart->id)->update([
            'coupon_code' => $code,
        ]);      
        return $this;
    }
    /**
     * Remove coupon code from the cart.
     *
     * @return App\Contracts\Cart
     */
    public function removeCouponCode($cartId = NULL)
    {
        $cart = $this->getCart($cartId);

        $cart->coupon_code = null;

        $cart->save();

        return $this;
    }
}