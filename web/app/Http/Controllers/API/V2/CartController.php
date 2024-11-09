<?php

namespace App\Http\Controllers\API\V2;

use App\Http\Controllers\Controller;
use Exception;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Event;
use Webkul\Checkout\Facades\Cart;
use App\Repositories\CartItemRepository;
// use Webkul\Customer\Repositories\WishlistRepository;
use App\Models\Coupon;
use App\Models\CouponService;
use App\Http\Resources\API\Checkout\CartResource;

class CartController extends Controller
{
    /**
     * Get the customer cart.
     *
     * @return \Illuminate\Http\Response
     */
    public function get(Request $request)
    {
        $cart = Cart::getCart($request->cart_id);

        return response([
            'data' => $cart ? new CartResource($cart) : null,
        ]);
    }

    /**
     * Add item to the cart.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \Webkul\Customer\Repositories\WishlistRepository $wishlistRepository
     * @param  int  $productId
     * @return \Illuminate\Http\Response
     */
    public function add(Request $request, /*WishlistRepository $wishlistRepository,*/ int $productId)
    {
        $customer = $request->user();
        $cartId = $request->cart_id;
       

        try {
            Event::dispatch('checkout.cart.item.add.before', $productId);
            
            $result = Cart::addProduct($productId, $request->all(), $cartId);

            if (is_array($result) && isset($result['warning'])) {
                return response([
                    'message' => $result['warning'],
                ], 400);
            }
            // $wishlistRepository->deleteWhere(['product_id' => $productId, 'customer_id' => $customer->id]);

            Event::dispatch('checkout.cart.item.add.after', $result);

            Cart::collectTotals($cartId);
            
            $cart = Cart::getCart($cartId);
            return response([
                'data'    => $cart ? new CartResource($cart) : null,
                'message' => __('messages.checkout.cart.item.success'),
            ]);
        } catch (Exception $e) {
            return response([
                'message' => $e->getMessage(),
            ], 400);
        }
    }
    public function addUpdate(Request $request,int $productId)
    {
        // $customer = $request->user();
        // $cartId = $request->cart_id;
        // $productId = $request->product_id;
        // try {
        //     Event::dispatch('checkout.cart.item.add.before', $productId);
        //     $result = Cart::addProductItem($productId, $request->all(), $cartId);
        //     if (is_array($result) && isset($result['warning'])) {
        //         return response([
        //             'message' => $result['warning'],
        //         ], 400);
        //     }
        //     Event::dispatch('checkout.cart.item.add.after', $result);
        //     Cart::collectTotals($cartId);
        //     $cart = Cart::getCart($cartId);
        //     return response([
        //         'data'    => $cart ? new CartResource($cart) : null,
        //         'message' => __('messages.checkout.cart.item.success'),
        //     ]);
        // } catch (Exception $e) {
        //     return response([
        //         'message' => $e->getMessage(),
        //     ], 400);
        // }
        $customer = $request->user();
        $cartId = $request->cart_id;       

        try {
            Event::dispatch('checkout.cart.item.add.before', $productId);
            
            $result = Cart::addProductItem($productId, $request->all(), $cartId);

            if (is_array($result) && isset($result['warning'])) {
                return response([
                    'message' => $result['warning'],
                ], 400);
            }
            Event::dispatch('checkout.cart.item.add.after', $result);

            Cart::collectTotals($cartId);
            
            $cart = Cart::getCart($cartId);
            return response([
                'data'    => $cart ? new CartResource($cart) : null,
                'message' => __('messages.checkout.cart.item.success'),
            ]);
        } catch (Exception $e) {
            return response([
                'message' => $e->getMessage(),
            ], 400);
        }
    }

    /**
     * Update the cart.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \Webkul\Checkout\Repositories\CartItemRepository  $cartItemRepository
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, CartItemRepository $cartItemRepository)
    {
        $this->validate($request, [
            'qty' => 'required|array',
        ]);

        $cartId = $request->cart_id;

        foreach ($request->qty as $qty) {
            if ($qty <= 0) {
                return response([ 
                    'message' => __('messages.checkout.cart.quantity.illegal'),
                ], 400);
            }
        }

        foreach ($request->qty as $itemId => $qty) {
            $item = $cartItemRepository->findOneByField('id', $itemId);

            Event::dispatch('checkout.cart.item.update.before', $itemId);

            Cart::updateItems(['qty' => $request->qty], $cartId);

            Event::dispatch('checkout.cart.item.update.after', $item);
        }

        Cart::collectTotals($cartId);

        $cart = Cart::getCart($cartId);

        return response([
            'data'    => $cart ? new CartResource($cart) : null,
            'message' => __('messages.checkout.cart.quantity.success'),
        ]);
    }

    /**
     * Remove item from the cart.
     *
     * @param  int  $cartItemId
     * @return \Illuminate\Http\Response
     */
    public function removeItemCart($cartItemId)
    {
        Event::dispatch('checkout.cart.item.delete.before', $cartItemId);
        $cart = Cart::getCart($cartItemId);
        $cart->items()->get();
        $cartItem = $cart->items()->delete();    
        Event::dispatch('checkout.cart.item.delete.after', $cartItemId);
        $cart = Cart::getCart($cartItemId);
        return response([
            'data'    => $cart ? new CartResource($cart) : null,
            'message' => __('messages.checkout.cart.item.success'),
        ]);
    }
    public function removeItem($cartItemId, Request $request)
    {
        Event::dispatch('checkout.cart.item.delete.before', $cartItemId);

        Cart::removeItem($cartItemId, $request->cart_id);

        Event::dispatch('checkout.cart.item.delete.after', $cartItemId);

        Cart::collectTotals($request->cart_id);

        $cart = Cart::getCart($request->cart_id);

        return response([
            'data'    => $cart ? new CartResource($cart) : null,
            'message' => __('messages.checkout.cart.item.success'),
        ]);
    }

    /**
     * Empty the cart.
     *
     * @return \Illuminate\Http\Response
     */
    function empty() {
        Event::dispatch('checkout.cart.delete.before');

        Cart::deActivateCart();

        Event::dispatch('checkout.cart.delete.after');

        $cart = Cart::getCart();

        return response([
            'data'    => $cart ? new CartResource($cart) : null,
            'message' => __('messages.checkout.cart.item.success-remove'),
        ]);
    }

    /**
     * Apply the coupon code.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function applyCoupon(Request $request) 
    {
        app()->setLocale($request->header("X-localization")??"en");
        $couponCode = $request->code;
        $cartId = $request->cart_id;
        try {
            if (strlen($couponCode)) {
                $dataCouponCode = Coupon::Where('code',$couponCode)->first();
                if(empty($dataCouponCode->id)){
                    return response([
                        'data'      => null,
                        'message'   => __('messages.checkout.cart.coupon.invalid'),
                    ], 200);
                }else{
                    $dataCouponCode = Coupon::Where('code',$couponCode)->where('expire_date','>',date('Y-m-d H:i:s'))->first();
                    if(empty($dataCouponCode->id)){
                        return response([
                            'data'      => null,
                            'message'   => __('messages.checkout.cart.coupon.expire_date'),
                        ], 200);
                    }else{
                        Cart::setCouponCode($couponCode, $cartId)->collectTotals($cartId);
                        Cart::setCouponCodeItem($couponCode, $cartId)->collectTotals($cartId);
                        if (Cart::getCart($cartId)->coupon_code == $couponCode) {
                            return response([
                                'data'      => Cart::getCart($cartId)?new CartResource(Cart::getCart($cartId)) : null,
                                'message'   => __('messages.checkout.cart.coupon.success'),
                            ]);
                        }
                    }                    
                }
            }
            return response([
                'data'      => null,
                'message'   => __('messages.checkout.cart.coupon.invalid'),
            ], 200);
        } catch (\Exception $e) {
            report($e);

            return response([
                'data'      => null,
                'message'   => __('messages.checkout.cart.coupon.apply-issue'),
            ], 200);
        }
    }

    /**
     * Remove the coupon code.
     *
     * @return \Illuminate\Http\Response
     */
    public function removeCoupon(Request $request)
    {
        $cartId = $request->cart_id;

        Cart::removeCouponCode($cartId)->collectTotals($cartId);

        return response([
            'message' => __('messages.checkout.cart.coupon.success-remove'),
        ]);
    }

    /**
     * Move cart item to wishlist.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function moveToWishlist($cartItemId)
    {
        Event::dispatch('checkout.cart.item.move-to-wishlist.before', $cartItemId);

        Cart::moveToWishlist($cartItemId);

        Event::dispatch('checkout.cart.item.move-to-wishlist.after', $cartItemId);

        Cart::collectTotals();

        $cart = Cart::getCart();

        return response([
            'data'    => $cart ? new CartResource($cart) : null,
            'message' => __('messages.checkout.cart.move-wishlist.success'),
        ]);
    }
}
