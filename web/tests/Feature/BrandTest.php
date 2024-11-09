<?php

namespace Tests\Feature\Api;

use App\Models\User;
use App\Models\Brand;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Foundation\Testing\WithFaker;
use Tests\TestCase;

class BrandTest extends TestCase
{
    public function test_brand_can_be_list()
    {
        $user = User::factory()->create();
        $brand = Brand::factory()->create();

        $this->post('/login', [
            'email' => $user->email,
            'password' => 'password',
        ]);

        $response = $this->get('/brands');

        $response->assertStatus(200);
        $response->assertViewIs('brand.index');
    }

    
}