<?php

namespace App\Http\Resources\API\Checkout;

use Illuminate\Http\Resources\Json\JsonResource;
use App\Http\Resources\API\ServiceResource;
use App\Models\CartItem;
use App\Models\Coupon;
class CartItemResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return array
     */
    public function toArray($request)
    {
        $this->discount_coupon          = CartItem::find($this->id)->discount_coupon??0;
        $this->discount_coupon_percent  = Coupon::where('code',$this->coupon_code)->first()->discount??0;
        return [
            'id'                             => $this->id,
            'product_id'                     => $this->product_id,
            'quantity'                       => $this->quantity,
            'sku'                            => $this->sku,
            'type'                           => $this->type,
            'name'                           => $this->name,
            'coupon_code'                    => $this->coupon_code,
            'weight'                         => $this->weight,
            'total_weight'                   => $this->total_weight,
            'base_total_weight'              => $this->base_total_weight,
            'price'                          => $this->price,
            'formatted_price'                => core()->formatPrice($this->price, $this->cart->cart_currency_code),
            'base_price'                     => $this->base_price,
            'formatted_base_price'           => core()->formatBasePrice($this->base_price),
            'custom_price'                   => $this->custom_price,
            'formatted_custom_price'         => core()->formatPrice($this->custom_price, $this->cart->cart_currency_code),
            'total'                          => $this->total-$this->discount_coupon,
            'formatted_total'                => core()->formatPrice(($this->total-$this->discount_amount-$this->discount_coupon), $this->cart->cart_currency_code),
            'base_total'                     => $this->base_total-$this->discount_amount-$this->discount_coupon,
            'formatted_base_total'           => core()->formatBasePrice($this->base_total-$this->discount_amount-$this->discount_coupon),
            'tax_percent'                    => $this->tax_percent,
            'tax_amount'                     => $this->tax_amount,
            'formatted_tax_amount'           => core()->formatPrice($this->tax_amount, $this->cart->cart_currency_code),
            'base_tax_amount'                => $this->base_tax_amount,
            'formatted_base_tax_amount'      => core()->formatBasePrice($this->base_tax_amount),
            'discount_coupon'                => $this->discount_coupon,
            'discount_coupon_percent'        => $this->discount_coupon_percent,
            'discount_percent'               => $this->discount_percent,
            'discount_amount'                => $this->discount_amount,
            'formatted_discount_amount'      => core()->formatPrice($this->discount_amount, $this->cart->cart_currency_code),
            'base_discount_amount'           => $this->base_discount_amount,
            'formatted_base_discount_amount' => core()->formatBasePrice($this->base_discount_amount),
            'additional'                     => is_array($this->resource->additional)
                ? $this->resource->additional
                : json_decode($this->resource->additional, true),
            'child'                          => new self($this->child),
            'product'                        => $this->when($this->product_id, new ServiceResource($this->product)),
            'created_at'                     => $this->created_at,
            'updated_at'                     => $this->updated_at,
        ];
    }
}
