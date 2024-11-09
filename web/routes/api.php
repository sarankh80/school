<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers;
use App\Http\Controllers\API;
/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});

Route::post('providers/register', [API\V2\Auth\ProviderController::class, 'register']);
Route::post('providers/login', [API\V2\Auth\ProviderController::class, 'login']);
Route::post('providers/forgot-password', [API\V2\Auth\NewProviderPasswordController::class, 'store']);
Route::post('providers/phone-verification', [API\V2\Auth\ProviderPhoneVerificationController::class, 'store']);

Route::post('customers/register', [API\V2\Auth\CustomerController::class, 'register']);
Route::post('customers/login', [API\V2\Auth\CustomerController::class, 'login']);
Route::post('customers/forgot-password', [API\V2\Auth\NewCustomerPasswordController::class, 'store']);
Route::post('customers/phone-verification', [API\V2\Auth\CustomerPhoneVerificationController::class, 'store']);

Route::post('register', [API\UserController::class, 'register']);

Route::post('login', [API\UserController::class, 'login']);

Route::post('forgot-password', [API\NewPasswordController::class, 'store']);

Route::group(['middleware' => ['auth:sanctum']], function () {
    Route::get('category-list', [API\CategoryController::class, 'getCategoryList']);
    Route::get('subcategory-list', [API\SubCategoryController::class, 'getSubCategoryList']);
    Route::get('service-list', [API\ServiceController::class, 'getServiceList']);
    Route::get('type-list', [API\CommanController::class, 'getTypeList']);

    Route::post('country-list', [API\CommanController::class, 'getCountryList']);
    Route::post('state-list', [API\CommanController::class, 'getStateList']);
    Route::post('city-list', [API\CommanController::class, 'getCityList']);
    Route::get('search-list', [API\CommanController::class, 'getSearchList']);
    Route::get('slider-list', [API\SliderController::class, 'getSliderList']);
    Route::get('top-rated-service', [API\ServiceController::class, 'getTopRatedService']);

    Route::get('user-detail', [API\UserController::class, 'userDetail']);
    Route::get('user-list', [API\UserController::class, 'userList']);
    Route::get('handyman-list', [API\UserController::class, 'handymanList']);
    Route::post('handyman-reviews', [API\UserController::class, 'handymanReviewsList']);
    Route::post('social-login', [API\UserController::class, 'socialLogin']);
    Route::post('contact-us', [API\UserController::class, 'contactUs']);
    Route::post('user-update-status', [API\UserController::class, 'userStatusUpdate']);
    Route::post('change-password', [API\UserController::class, 'changePassword']);
    Route::post('update-profile', [API\UserController::class, 'updateProfile']);
    Route::get('logout', [API\UserController::class, 'logout']);
    Route::post('delete-user-account', [API\UserController::class, 'deleteUserAccount']);
    Route::post('delete-account', [API\UserController::class, 'deleteAccount']);
    
    
    Route::get('dashboard-detail', [API\DashboardController::class, 'dashboardDetail']);
    Route::get('customer-dashboard', [API\DashboardController::class, 'customerDashboard']);
    Route::get('service-rating-list', [API\ServiceController::class, 'getServiceRating']);
    Route::post('service-detail', [API\ServiceController::class, 'getServiceDetail']);
    Route::get('booking-status', [API\BookingController::class, 'bookingStatus']);
    Route::post('service-reviews', [API\ServiceController::class, 'serviceReviewsList']);
    
    Route::resource('categories', API\CategoryController::class)->only(['index', 'show']);
    Route::get('categories/find/{id}', [API\CategoryController::class, 'find']);
    Route::resource('services', API\ServiceController::class)->only(['index', 'show']);    
});

Route::group(['middleware' => ['auth:sanctum', 'sanctum.provider']], function(){

    Route::get('provider/invoices', [API\V2\InvoiceController::class, 'index']);

    Route::post('provider/invoices/{booking_id}', [API\V2\InvoiceController::class, 'store']);

    Route::post('provider/booking-update/{booking_id}', [API\BookingController::class, 'update']);

    Route::post('provider/update-profile', [API\V2\Auth\ProviderController::class, 'updateProfile']);

    Route::post('handyman-update-available-status', [API\V2\Auth\ProviderController::class, 'handymanAvailable']);

    Route::get('provider-detail', [API\V2\Auth\ProviderController::class, 'userDetail']);
});

Route::group(['middleware' => ['auth:sanctum', 'sanctum.customer']], function(){
    /**
     * Customer cart routes.
     */
    Route::get('customer/cart', [API\V2\CartController::class, 'get']);

    Route::post('customer/cart/add/{productId}', [API\V2\CartController::class, 'add']);

    Route::post('customer/cart/add-updates/{productId}', [API\V2\CartController::class, 'addUpdate']);
    
    Route::put('customer/cart/update', [API\V2\CartController::class, 'update']);

    Route::delete('customer/cart/remove/{cartItemId}', [API\V2\CartController::class, 'removeItem']);
    Route::delete('customer/cart/remove-cart/{cartItemId}', [API\V2\CartController::class, 'removeItemCart']);

    Route::delete('customer/cart/empty', [API\V2\CartController::class, 'empty']);

    Route::post('customer/cart/move-to-wishlist/{cartItemId}', [API\V2\CartController::class, 'moveToWishlist']);

    Route::post('customer/cart/coupon', [API\V2\CartController::class, 'applyCoupon']);

    Route::delete('customer/cart/coupon', [API\V2\CartController::class, 'removeCoupon']);


});

Route::group(['middleware' => ['auth:sanctum', 'sanctum.customer']], function () {
    
    Route::post('service-save', [App\Http\Controllers\ServiceController::class, 'store']);
    Route::post('service-delete/{id}', [App\Http\Controllers\ServiceController::class, 'destroy']);
    Route::post('booking-save', [API\BookingController::class, 'save']);
    Route::post('booking-update', [API\BookingController::class, 'bookingUpdate']);
    Route::get('provider-dashboard', [API\DashboardController::class, 'providerDashboard']);
    Route::get('booking-list', [API\BookingController::class, 'getBookingList']);
    Route::post('booking-detail', [API\BookingController::class, 'getBookingDetail']);
    Route::post('save-booking-rating', [API\BookingController::class, 'saveBookingRating']);
    Route::post('delete-booking-rating', [API\BookingController::class, 'deleteBookingRating']);

    Route::post('save-favourite', [API\ServiceController::class, 'saveFavouriteService']);
    Route::post('delete-favourite', [API\ServiceController::class, 'deleteFavouriteService']);
    Route::get('user-favourite-service', [API\ServiceController::class, 'getUserFavouriteService']);

    Route::resource('bookings', API\V2\BookingController::class)->only(['index', 'show', 'store', 'update', 'destroy']);
    Route::resource('bookings.assigns', API\V2\BookingAssignController::class)->only(['store']);

    Route::post('booking-action', [API\BookingController::class, 'action']);

    Route::post('booking-assigned', [App\Http\Controllers\BookingController::class, 'bookingAssigned']);

    Route::post('notification-list', [API\NotificationController::class, 'notificationList']);
    Route::post('remove-file', [App\Http\Controllers\HomeController::class, 'removeFile']);

    Route::post('save-payment', [API\PaymentController::class, 'savePayment']);
    Route::get('payment-list', [API\PaymentController::class, 'paymentList']);

    Route::resource('customers.addresses', API\CustomerAddressController::class)->only(['store', 'update', 'index', 'destroy']);
    Route::resource('providers.addresses', API\ProviderAddressController::class)->only(['store', 'update', 'index', 'destroy']);

    Route::post('save-provideraddress', [API\CustomerAddressController::class, 'store']);
    Route::get('provideraddress-list', [API\CustomerAddressController::class, 'getProviderAddressList']);
    Route::post('provideraddress-delete/{id}', [API\CustomerAddressController::class, 'destroy']);
    Route::post('save-handyman-rating', [API\BookingController::class, 'saveHandymanRating']);
    Route::post('delete-handyman-rating', [API\BookingController::class, 'deleteHandymanRating']);

    Route::get('document-list', [API\DocumentsController::class, 'getDocumentList']);
    Route::get('provider-document-list', [API\ProviderDocumentController::class, 'getProviderDocumentList']);
    Route::post('provider-document-save', [App\Http\Controllers\ProviderDocumentController::class, 'store']);
    Route::post('provider-document-delete/{id}', [App\Http\Controllers\ProviderDocumentController::class, 'destroy']);

    Route::get('tax-list', [API\CommanController::class, 'getProviderTax']);
    Route::get('handyman-dashboard', [API\DashboardController::class, 'handymanDashboard']);

    Route::post('customer-booking-rating', [API\BookingController::class, 'bookingRatingByCustomer']);
    Route::post('handyman-delete/{id}', [App\Http\Controllers\HandymanController::class, 'destroy']);
    Route::post('handyman-action', [App\Http\Controllers\HandymanController::class, 'action']);

    Route::get('provider-payout-list', [API\PayoutController::class, 'providerPayoutList']);
    Route::get('handyman-payout-list', [API\PayoutController::class, 'handymanPayoutList']);

    Route::get('plan-list', [API\PlanController::class, 'planList']);
    Route::post('save-subscription', [API\SubscriptionController::class, 'providerSubscribe']);
    Route::post('cancel-subscription', [API\SubscriptionController::class, 'cancelSubscription']);
    Route::get('subscription-history', [API\SubscriptionController::class, 'getHistory']);
    Route::get('wallet-history', [API\WalletController::class, 'getHistory']);

    Route::post('save-service-proof', [API\BookingController::class, 'uploadServiceProof']);
});
