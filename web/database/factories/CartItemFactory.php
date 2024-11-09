<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;
use App\Models\Cart;
use App\Models\CartItem;
use App\Models\Product;

class CartItemFactory extends Factory
{
    /**
     * The name of the factory's corresponding model.
     *
     * @var string
     */
    protected $model = CartItem::class;

    /**
     * Define the model's default state.
     *
     * @return array
     */
    public function definition(): array
    {
        $now = date('Y-m-d H:i:s');

        return [
            'quantity'   => 1,
            'cart_id'    => Cart::factory(),
            'created_at' => $now,
            'updated_at' => $now,
        ];
    }

    /**
     * Adjust product.
     *
     * @return array
     */
    public function adjustProduct()
    {
        return $this->state(function (array $attributes) {
            $product = isset($attributes['product_id'])
                ? Product::query()->where('id', $attributes['product_id'])->first()
                : Product::factory()->create();

            $fallbackPrice = $this->faker->randomFloat(4, 0, 1000);

            return [
                'sku'        => $product->sku,
                'type'       => $product->type,
                'name'       => $product->name,
                'price'      => $product->price ?? $fallbackPrice,
                'base_price' => $product->price ?? $fallbackPrice,
                'total'      => $product->price ?? $fallbackPrice,
                'base_total' => $product->price ?? $fallbackPrice,
                'product_id' => $product->id,
            ];
        });
    }
}
