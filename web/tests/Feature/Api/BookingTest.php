<?php

// namespace Tests\Feature\Api;

// use App\Models\User;
// use App\Models\Provider;
// use App\Models\Coupon;
// use App\Models\Category;
// use App\Models\Service;
// use Illuminate\Foundation\Testing\RefreshDatabase;
// use Illuminate\Foundation\Testing\WithFaker;
// use Tests\TestCase;

// class BookingTest extends TestCase
// {
//     /** @test
//      * 
//      * @return void 
//     */
//     public function test_booking_api_can_be_created() 
//     {
//         $provider = Provider::factory()->create();
//         $category = Category::factory()->create();
//         $service = Service::factory()->for($category)->create();
//         $user = User::factory()->create();

//         $response = $this->post('/api/login', [
//             'phone_number' => $user->phone_number,
//             'password' => 'password',
//         ]);

//         $data = [
//             'customer_id' => $user->id,
//             'service_id' => $service->id,
//             'provider_id' => $provider->id,
//             'date' => date('Y-m-d H:i:s'),
//             'amount' => 50,
//             'discount' => 0,
//             'total_amount' => 50,
//             'coupon_id' => null
//         ];

//         $response = $this->postJson('/api/booking-save', $data);

//         $response->assertStatus(200)
//                 ->assertJson(['message' => 'Booking has been save successfully']);
        
//         $this->assertDatabaseHas('bookings', $data);
//     }

//     /** @test
//      * 
//      * @return void 
//     */
//     public function test_booking_api_can_be_created_with_coupon_valid() 
//     {
//         $booking_amount = 50;
//         $provider = User::factory()->state(['user_type' => 'provider'])->create();
//         $category = Category::factory()->create();
//         $service = Service::factory()->for($category)->create();
//         $coupon = Coupon::factory()
//             ->hasAttached($service)
//             ->state([
//                 'code' => 'abd123',
//                 'discount_type' => 'fixed',
//                 'discount'  => '10',
//                 'expire_date' => date('Y-m-d H:i:s', strtotime('tomorrow 11:00:00'))
//             ])->create();
//         $user = User::factory()->create();

//         $response = $this->post('/api/login', [
//             'phone_number' => $user->phone_number,
//             'password' => 'password',
//         ]);

//         $coupon_amount = $coupon->discount_type == "fixed" ? $coupon->discount : ($coupon->discount * $booking_amount) / 100; 

//         $data = [
//             'customer_id' => $user->id,
//             'service_id' => $service->id,
//             'provider_id' => $provider->id,
//             'date' => date('Y-m-d H:i:s'),
//             'amount' => $booking_amount,
//             'discount' => $coupon->discount,
//             'total_amount' => $booking_amount - $coupon_amount,
//             'coupon_id' => 'abd123'
//         ];
        
//         $response = $this->postJson('/api/booking-save', $data);
//         $response->assertStatus(200)
//                 ->assertJson(['message' => 'Booking has been save successfully']);
        
//         $this->assertDatabaseHas('bookings', [
//             'customer_id' => $data['customer_id'],
//             'service_id' => $data['service_id'],
//             'provider_id' => $data['provider_id'],
//             'date' => $data['date'],
//             'amount' => $data['amount'],
//             'discount' => $coupon->discount,
//             'total_amount' => $data['total_amount'],
//             'coupon_id' => $coupon->id
//         ]);
//     }

//     /** @test
//      * 
//      * @return void 
//     */
//     public function test_booking_api_can_be_created_with_coupon_invalid() 
//     {
//         $booking_amount = 50;
//         $provider = User::factory()->state(['user_type' => 'provider'])->create();
//         $category = Category::factory()->create();
//         $service = Service::factory()->for($category)->create();
//         $coupon = Coupon::factory()
//             ->hasAttached($service)
//             ->state([
//                 'code' => 'abc123',
//                 'discount_type' => 'fixed',
//                 'discount'  => '10',
//                 'expire_date' => date('Y-m-d H:i:s', strtotime('tomorrow 11:00:00'))
//             ])->create();
//         $user = User::factory()->create();

//         $response = $this->post('/api/login', [
//             'phone_number' => $user->phone_number,
//             'password' => 'password',
//         ]);

//         $coupon_amount = $coupon->discount_type == "fixed" ? $coupon->discount : ($coupon->discount * $booking_amount) / 100; 

//         $data = [
//             'customer_id' => $user->id,
//             'service_id' => $service->id,
//             'provider_id' => $provider->id,
//             'date' => date('Y-m-d H:i:s'),
//             'amount' => $booking_amount,
//             'discount' => $coupon->discount,
//             'total_amount' => $booking_amount - $coupon_amount,
//             'coupon_id' => 'abd123'
//         ];
        
//         $response = $this->postJson('/api/booking-save', $data);
        
//         $response->assertStatus(400)
//                 ->assertJson(['message' => 'Invalid coupon code']);
//     }
// }
