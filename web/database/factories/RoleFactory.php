<?php

namespace Database\Factories;

use App\Models\Role;
use Illuminate\Database\Eloquent\Factories\Factory;
use Illuminate\Support\Str;

class RoleFactory extends Factory
{
    /**
     * The name of the factory's corresponding model.
     *
     * @var string
     */
    protected $model = Role::class;

    /**
     * Define the model's default state.
     *
     * @return array
     */
    public function definition()
    {
        return [
            'name' => 'user',
            'guard_name' => 'web',
            'status' => 1,
            'created_at' => '2021-06-04 10:31:46',
            'updated_at' => '2021-06-04 10:31:46',
        ];
    }
}
