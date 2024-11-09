<?php

namespace Database\Factories;

use App\Models\Service;
use Illuminate\Database\Eloquent\Factories\Factory;
use Illuminate\Support\Str;

class ServiceFactory extends Factory
{
    /**
     * The name of the factory's corresponding model.
     *
     * @var string
     */
    protected $model = Service::class;

    /**
     * Define the model's default state.
     *
     * @return array
     */
    public function definition()
    {
        return [
            'name' => $this->faker->name(),            
            'price' => 200,
            'unit_id' => 1,
            'discount' => 5,
            'duration' => "0:30",
            'description' => 'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout.',
            'is_featured' => 0,
            'sku' => '123456',
            'status' => 1
        ];
    }
}
