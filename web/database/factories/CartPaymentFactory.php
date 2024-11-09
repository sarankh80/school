<?php

namespace Database\Factories;

use Faker\Generator as Faker;
use App\Models\CartPayment;
use Illuminate\Database\Eloquent\Factories\Factory;

class CartPaymentFactory extends Factory
{
    /**
     * The name of the factory's corresponding model.
     *
     * @var string
     */
    protected $model = CartPayment::class;

    /**
     * Define the model's default state.
     *
     * @return array
     */
    public function definition(): array
    {
        $now = date("Y-m-d H:i:s");

        return [
            'created_at' => $now,
            'updated_at' => $now,
        ];
    }
}


