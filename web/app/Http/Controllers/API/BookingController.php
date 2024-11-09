<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Booking;
use App\Models\Address;
use App\Models\BookingRequest;
use App\Models\BookingStatus;
use App\Models\BookingRating;
use App\Models\HandymanRating;
use App\Models\BookingActivity;
use App\Models\Service;
use App\Models\Coupon;
use App\Models\Payment;
use App\Models\Wallet; 
use App\Models\ServiceProof; 
use App\Http\Resources\API\BookingResource;
use App\Http\Resources\API\BookingDetailResource;
use App\Http\Resources\API\BookingRatingResource;
use App\Http\Resources\API\ServiceResource;
use App\Http\Resources\API\UserResource;
use App\Http\Resources\API\HandymanResource;
use App\Http\Resources\API\HandymanRatingResource;
use App\Http\Resources\API\ServiceProofResource;
use App\Repositories\BookingRepository;
use Prettus\Repository\Criteria\RequestCriteria;
use Prettus\Repository\Exceptions\RepositoryException;
use App\Criteria\LimitOffsetCriteria;
use App\Criteria\BookingByProviderCriteria;
use App\Criteria\BookingByCustomerCriteria;
use App\Criteria\BookingByStatusCriteria;
use App\Criteria\BookingByHandymanCriteria;
use Auth;
use Webkul\Checkout\Facades\Cart;
use Illuminate\Http\Exceptions\HttpResponseException;

class BookingController extends Controller
{
    /**
     * @var BookingRepository
     */
    protected $bookingRepo;

    /**
     * Create a new controller instance.
     *
     * @param  App\Repositories\BookingRepository  $bookingRepository
     *
     * @return void
     */
    public function __construct(BookingRepository $bookingRepository)
    {
        $this->bookingRepo = $bookingRepository;
    } 

    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index(Request $request)
    {
        try {
            $this->bookingRepo->pushCriteria(new RequestCriteria($request));
            $this->bookingRepo->pushCriteria(new BookingByStatusCriteria($request));
            $this->bookingRepo->pushCriteria(new BookingByProviderCriteria($request));
            $this->bookingRepo->pushCriteria(new BookingByCustomerCriteria($request));
            $this->bookingRepo->pushCriteria(new BookingByHandymanCriteria());
            $this->bookingRepo->pushCriteria(new LimitOffsetCriteria($request));

            if (!empty($request->page)) {
                $bookings = $this->bookingRepo->paginate($limit = 10, $columns = ['*']);
            } else {
                $bookings = $this->bookingRepo->get();
            }

        } catch (RepositoryException $e) {
            return $this->sendError($e->getMessage());
        }
        
        return $this->sendResponse($bookings, 'Bookings fetched successfully');
    }

    /** 
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        $this->bookingRepo->create($request->all());

        return comman_message_response(__('messages.save_form', ['form' => __('messages.booking')]));
    }

    public function getBookingList(Request $request){
        $booking = Booking::myBooking()->with('customer','provider','service');

        if($request->has('status') && isset($request->status)){
            $booking->where('status',$request->status);
        } 

        $per_page = config('constant.PER_PAGE_LIMIT');
        if( $request->has('per_page') && !empty($request->per_page)){
            if(is_numeric($request->per_page)){
                $per_page = $request->per_page;
            }
            if($request->per_page === 'all' ){
                $per_page = $booking->count();
            }
        }
        $orderBy = 'desc';
        if( $request->has('orderby') && !empty($request->orderby)){
            $orderBy = $request->orderby;
        }

        $booking = $booking->orderBy('updated_at',$orderBy)->paginate($per_page);
        $items = BookingResource::collection($booking);

        $response = [
            'pagination' => [
                'total_items' => $items->total(),
                'per_page' => $items->perPage(),
                'currentPage' => $items->currentPage(),
                'totalPages' => $items->lastPage(),
                'from' => $items->firstItem(),
                'to' => $items->lastItem(),
                'next_page' => $items->nextPageUrl(),
                'previous_page' => $items->previousPageUrl(),
            ],
            'data' => $items,
        ];
        
        return comman_custom_response($response);
    }

    public function getBookingDetail(Request $request){

        $id = $request->booking_id;
        
        $booking_data = Booking::with('customer','provider','service','bookingRating','bookingRatings')->where('id',$id)->first();
        if($booking_data == null){
            $message = __('messages.booking_not_found');
            return comman_message_response($message,400);  
        }
        $booking_detail = new BookingDetailResource($booking_data);
        
        $rating_data = BookingRatingResource::collection($booking_detail->bookingRatings);
        $service = new ServiceResource($booking_detail->service);
        $customer = new UserResource($booking_detail->customer);
        $provider_data = new UserResource($booking_detail->provider);
        $handyman_data = HandymanResource::collection($booking_detail->handymanAdded);

        $customer_review = null;
        if($request->customer_id != null){
            $customer_review = BookingRating::where('customer_id',$request->customer_id)->where('service_id',$booking_detail->service_id)->where('booking_id',$id)->first();
            if (!empty($customer_review))
            {
                $customer_review = new BookingRatingResource($customer_review);
            }
        }

        $auth_user = auth()->user();
        if(count($auth_user->unreadNotifications) > 0 ) {
            $auth_user->unreadNotifications->where('data.id',$id)->markAsRead();
        }

        $booking_activity = BookingActivity::where('booking_id',$id)->get();
        $serviceProof = ServiceProofResource::collection(ServiceProof::with('service','handyman','booking')->where('booking_id',$id)->get());
        $response = [
            'booking_detail'    => $booking_detail,
            // 'service'  => $service,
            'customer'  => $customer,
            'booking_activity'  => $booking_activity,
            'rating_data'       => $rating_data,
            'handyman_data'     => $handyman_data,
            'provider_data'     => $provider_data,
            'coupon_data'       => $booking_detail->couponAdded,
            'customer_review'   => $customer_review,
            'service_proof' => $serviceProof
        ];

        return comman_custom_response($response);
    }

    /**
     * Store a existed update resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function update($booking_id, Request $request)
    {   
        if(empty(Cart::getCart($request->cart_id)))
        {
            throw new HttpResponseException(response()->json([
                'message' => 'Your cart empty please add product or service to cart.'
            ], 422));
        }
        // $bookings = Booking::find($booking_id);
        // $address = Address::find($bookings->booking_address_id);
        $booking = $this->bookingRepo->update(            
            array_merge(Cart::prepareDataForBooking($request->cart_id), [
                // 'booking_address_id' => $request->address_id,
                // 'latitude' => $request->latitude,
                // 'longitude' => $request->longitude,
                'date' => date('Y-m-d H:i:s')
                ]
            ),
            // array_merge(Cart::prepareDataForBooking($request->cart_id), [
            //     'booking_address_id' => $address->id,
            //     'latitude' => $address->latitude,
            //     'longitude' => $address->longitude,
            //     'date' => date('Y-m-d H:i:s')
            //     ]
            // ),
            $booking_id
        );
       
        $playerIds = [];

        $activity_data = [
            'activity_type' => 'update_booking_status',
            'booking_id' => $booking->id,
            'booking' => $booking,
            'playerIds' => $playerIds
        ];

        saveBookingActivity($activity_data);

        if($request->has('booking_address_id') && $request->booking_address_id != null) {
            $booking_address_mapping = Address::find($request->booking_address_id);
            
            $booking_address_data = [
                'booking_id'    => $booking->id,
                'address'          => $booking_address_mapping->address,
                'latitude'      => $booking_address_mapping->latitude,
                'longitude' => $booking_address_mapping->longitude,
            ];
            
            $booking->addressAdded()->create($booking_address_data);
        }
        
		$message = __('messages.update_form',[ 'form' => __('messages.booking') ] );

        $response = [
            'message'=>$message,
            'booking_id' => $booking->id
        ];
        return comman_custom_response($response);
    } 
 
    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function save(Request $request)
    {   
        if(empty(Cart::getCart()))
        {
            throw new HttpResponseException(response()->json([
                'message' => 'Your cart empty please add product or service to cart.'
            ], 422));
        }
        
        $booking = $this->bookingRepo->create(
            array_merge(Cart::prepareDataForBooking(), [
                'booking_address_id' => $request->address_id,
                'customer_id'       => Auth::guard('sanctum')->check() ? auth::guard('sanctum')->user()->id : null,
                'latitude' => $request->latitude,
                'longitude' => $request->longitude,
                'date' => isset($request->date) ? date('Y-m-d H:i:s', strtotime($request->date)) : date('Y-m-d H:i:s')
                ]
            ) 
        );
       
        $playerIds = $this->bookingRepo->getPlayerIds($booking, $request->latitude, $request->longitude);

        $activity_data = [
            'activity_type' => 'add_booking',
            'booking_id' => $booking->id,
            'booking' => $booking,
            'playerIds' => $playerIds
        ];

        saveBookingActivity($activity_data);

        if($request->has('booking_address_id') && $request->booking_address_id != null) {
            $booking_address_mapping = Address::find($request->booking_address_id);
            
            $booking_address_data = [
                'booking_id'    => $booking->id,
                'address'          => $booking_address_mapping->address,
                'latitude'      => $booking_address_mapping->latitude,
                'longitude' => $booking_address_mapping->longitude,
            ];
            
            $booking->addressAdded()->create($booking_address_data);
        }
        
		if($booking->wasRecentlyCreated){
			$message = __('messages.save_form',[ 'form' => __('messages.booking') ] );
		}

        $response = [
            'message'=>$message,
            'booking_id' => $booking->id
        ];
        return comman_custom_response($response);
    }

    public function saveBookingRating(Request $request)
    {
        $rating_data = $request->all();
        $result = BookingRating::updateOrCreate(['id' => $request->id], $rating_data);

        $message = __('messages.update_form',[ 'form' => __('messages.rating') ] );
		if($result->wasRecentlyCreated){
			$message = __('messages.save_form',[ 'form' => __('messages.rating') ] );
		}

        return comman_message_response($message);
    }

    public function deleteBookingRating(Request $request)
    {
        $user = \Auth::user();
        
        $book_rating = BookingRating::where('id',$request->id)->where('customer_id',$user->id)->delete();
        
        $message = __('messages.delete_form',[ 'form' => __('messages.rating') ] );

        return comman_message_response($message);
    }

    public function bookingStatus(Request $request)
    {
        $booking_status = BookingStatus::orderBy('sequence')->get();
        return comman_custom_response($booking_status);
    }

    public function bookingUpdate(Request $request)
    {

        $data = $request->all();
        $id = $request->id;
        // $data['date'] = isset($request->date) ? date('Y-m-d H:i:s',strtotime($request->date)) : date('Y-m-d H:i:s');
        $data['start_at'] = isset($request->start_at) ? date('Y-m-d H:i:s',strtotime($request->start_at)) : null;
        $data['end_at'] = isset($request->end_at) ? date('Y-m-d H:i:s',strtotime($request->end_at)) : null;

        $booking = Booking::find($id);

        $paymentdata = Payment::where('booking_id',$id)->first();
        if($data['status'] === 'hold'){
            if($booking->start_at == null && $booking->end_at == null){
                $duration_diff = $data['duration_diff'];
                $data['duration_diff'] = $duration_diff;
            }else{
                if($booking->status == $data['status']){
                    $booking_start_date = $booking->start_at;
                    $request_start_date = $data['start_at'];
                    if($request_start_date > $booking_start_date){
                        $msg = __('messages.already_in_status',[ 'status' => $data['status'] ] );
                        return comman_message_response($msg);
                    }
                }else{
                    $duration_diff = $booking->duration_diff;
                 
                    if($booking->start_at != null && $booking->end_at != null){
                        $new_diff = $data['duration_diff'];
                    }else{
                        $new_diff = $data['duration_diff'];
                    }
                    $data['duration_diff'] = $duration_diff + $new_diff;
                }
            }
        }
        if($data['status'] === 'completed'){
            $duration_diff = $booking->duration_diff;
            $new_diff = $data['duration_diff'];
            $data['duration_diff'] = $duration_diff + $new_diff;
        }
        if($booking->status != $data['status']) {
            $activity_type = 'update_booking_status';
        }
        if($data['status'] == 'cancelled'){
            $activity_type = 'cancel_booking';
        }
        if($data['status'] == 'rejected'){
            if($booking->handymanAdded()->count() > 0){
                $assigned_handyman_ids = $booking->handymanAdded()->pluck('handyman_id')->toArray();
                $booking->handymanAdded()->delete();
                $data['status'] = 'accept';
            } 
            // $activity_type = 'reject_booking';
        }
        if($data['status'] == 'accept'){
            $activity_type = 'accept_booking';
            $provider_id  = $booking->provider_id ? $booking->provider_id : Auth::guard('sanctum')->user()->id;
            $provider_wallet = Wallet::where('user_id', $provider_id)->first();
            $data['provider_id'] = $provider_id;
            $booking->requestProvider()->detach();


            if($provider_wallet){
                $amount  = $provider_wallet->amount;
                if($amount <  0 || $amount < $booking->amount){
                    $message = __('messages.wallent_balance_error');
                    $status_code = 400;
                    return comman_message_response($message, $status_code);
                }
            }
         } 
        $data['reason'] = isset($data['reason']) ? $data['reason'] : null;
        $old_status = $booking->status;
        $booking->update($data);
        if($old_status != $data['status'] ){
            $booking->old_status = $old_status;
            $activity_data = [
                'activity_type' => $activity_type,
                'booking_id' => $id,
                'booking' => $booking,
            ];
    
            saveBookingActivity($activity_data);
        }
        if($booking->payment_id != null){
            $data['payment_status'] = isset($data['payment_status']) ? $data['payment_status'] : 'pending';
            $paymentdata->update($data);

            if($booking->payment_id != null){
                $data['payment_status'] = isset($data['payment_status']) ? $data['payment_status'] : 'pending';
                $paymentdata->update($data);
                $activity_data = [
                    'activity_type' => 'payment_message_status',
                    'payment_status'=> $data['payment_status'],
                    'booking_id' => $id,
                    'booking' => $booking,
                ];
                saveBookingActivity($activity_data);
            }
        }
        $message = __('messages.update_form',[ 'form' => __('messages.booking') ] );

        if($request->is('api/*')) {
            return comman_message_response($message);
		}
    }

    public function saveHandymanRating(Request $request)
    {
        $user = auth()->user();
        $rating_data = $request->all();
        $rating_data['customer_id'] = $user->id;
        $result = HandymanRating::updateOrCreate(['id' => $request->id], $rating_data);

        $message = __('messages.update_form',[ 'form' => __('messages.rating') ] );
		if($result->wasRecentlyCreated){
			$message = __('messages.save_form',[ 'form' => __('messages.rating') ] );
		}

        return comman_message_response($message);
    }

    public function deleteHandymanRating(Request $request)
    {
        $user = auth()->user();
        
        $book_rating = HandymanRating::where('id',$request->id)->where('customer_id',$user->id)->delete();
        
        $message = __('messages.delete_form',[ 'form' => __('messages.rating') ] );

        return comman_message_response($message);
    }
    
    public function bookingRatingByCustomer(Request $request){
        $customer_review = null;
        if($request->customer_id != null){
            $customer_review = BookingRating::where('customer_id',$request->customer_id)->where('service_id',$request->service_id)->where('booking_id',$request->booking_id)->first();
            if (!empty($customer_review))
            {
                $customer_review = new BookingRatingResource($customer_review);
            }
        }
        return comman_custom_response($customer_review);

    }
    public function uploadServiceProof(Request $request){
        $booking = $request->all();
        $result = ServiceProof::create($booking);
        if($request->has('attachment_count')) {
            for($i = 0 ; $i < $request->attachment_count ; $i++){
                $attachment = "booking_attachment_".$i;
                if($request->$attachment != null){
                    $file[] = $request->$attachment;
                }
            }
            storeMediaFile($result,$file, 'booking_attachment');
        }
		if($result->wasRecentlyCreated){
			$message = __('messages.save_form',[ 'form' => __('messages.attachments') ] );
		}
        return comman_message_response($message);
    }
}