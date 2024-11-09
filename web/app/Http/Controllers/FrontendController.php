<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Category;
use App\Models\Service;
use App\Models\Booking;
use App\Models\Address;
use App\Models\User;
use App\Models\Setting;
use App\Models\Coupon;

use App\Http\Resources\API\CategoryResource;
use App\Http\Resources\API\ServiceResource;
use App\Http\Resources\API\UserResource;
use App\Http\Resources\API\ServiceDetailResource;
use App\Http\Resources\API\BookingRatingResource;
use App\Http\Resources\API\CouponResource;

class FrontendController extends Controller
{
    public function index(){
        $locale = app()->getLocale();
        return view('frontend.index',compact('locale'));
    }
    public function privacy(){
        $privacy_policy = Setting::where('type','privacy_policy')->where('key','privacy_policy')->first();        
        $term_conditions = Setting::where('type','terms_condition')->where('key','terms_condition')->first();
        $locale = app()->getLocale();
        return view('frontend.privacy',compact('locale','privacy_policy','term_conditions'));
    }
    public function history($id){
        $locale = app()->getLocale();
        $booking =  Booking::find($id);
        $address = Address::find($booking->booking_address_id);
        return view('frontend.history',compact('locale','booking','address'));
    }
}
