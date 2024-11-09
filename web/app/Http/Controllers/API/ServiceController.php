<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Service;
use App\Models\Coupon;
use App\Models\BookingRating;
use App\Models\UserFavouriteService;
use App\Models\ServiceFaq;
use App\Http\Resources\API\ServiceResource;
use App\Http\Resources\API\UserResource;
use App\Http\Resources\API\ServiceDetailResource;
use App\Http\Resources\API\BookingRatingResource;
use App\Http\Resources\API\CouponResource;
use App\Http\Resources\API\UserFavouriteResource;
use App\Http\Resources\API\ProviderTaxResource;
use App\Models\ServiceAddress;
use App\Models\ProviderTaxMapping;
use App\Repositories\ServiceRepository;
use Prettus\Repository\Criteria\RequestCriteria;
use Prettus\Repository\Exceptions\RepositoryException;
use App\Criteria\LimitOffsetCriteria;
use App\Criteria\ServiceVisibleCriteria;
use App\Criteria\ServiceFeaturedCriteria;
use App\Criteria\ServiceByLocationCriteria;
use App\Criteria\ServiceByProviderCriteria;
use App\Criteria\ServiceCategoryCriteria;
use App\Criteria\ServiceBrandCriteria;
use App\Criteria\ServiceTypeCriteria;
use App\Criteria\ServiceTagCriteria;
use App\Presenters\ServiceDetailPresenter;

class ServiceController extends Controller
{
    /**
     * @var ServiceRepository
     */
    protected $serviceRepo;

    /**
     * Create a new controller instance.
     *
     * @param  App\Repositories\ServiceRepository $serviceRepository
     *
     * @return void
     */
    public function __construct(ServiceRepository $serviceRepository)
    {
        $this->serviceRepo = $serviceRepository;       
    }

    /**
     * Display a listing of the resource.
     *
     * @param Illuminate\Http\Request $request
     * 
     * @return \Illuminate\Http\Response
     */
    public function index(Request $request)
    {
        app()->setLocale($request->header("X-localization")??"en");
        try {
            // $this->serviceRepo->pushCriteria(new ServiceTagCriteria($request));
            $this->serviceRepo->pushCriteria(new RequestCriteria($request));
            $this->serviceRepo->pushCriteria(new LimitOffsetCriteria($request));
            $this->serviceRepo->pushCriteria(new ServiceVisibleCriteria($request));
            $this->serviceRepo->pushCriteria(new ServiceCategoryCriteria($request));
            $this->serviceRepo->pushCriteria(new ServiceFeaturedCriteria($request));
            $this->serviceRepo->pushCriteria(new ServiceByLocationCriteria($request));
            $this->serviceRepo->pushCriteria(new ServiceBrandCriteria($request));
            $this->serviceRepo->pushCriteria(new ServiceTypeCriteria($request));
            $this->serviceRepo->pushCriteria(new ServiceByProviderCriteria($request));

            if (!empty($request->page)) {
                $services = $this->serviceRepo->paginate($limit = 10, $columns = ['*']);
            } else {
                $services = $this->serviceRepo->get();
            }
             
        } catch (RepositoryException $e) {
            return $this->sendError($e->getMessage());
        }

        return $this->sendResponse($services, 'Services retrieved successfully');
    }

    /**
     * Display the specified resource.
     *
     * @param Illuminate\Http\Request $request
     * @param  int  $id
     * 
     * @return \Illuminate\Http\Response
     */

    public function show(Request $request, $id)
    {
        /** @var Service $service */
        app()->setLocale($request->header("X-localization")??"en");
        if (!empty($this->serviceRepo)) {
            try {
                $this->serviceRepo->pushCriteria(new RequestCriteria($request));
                $this->serviceRepo->pushCriteria(new LimitOffsetCriteria($request));
            } catch (RepositoryException $e) {
                return $this->sendError($e->getMessage());
            }

            $this->serviceRepo->setPresenter(new ServiceDetailPresenter());  

            $this->serviceRepo->presenter();

            $service = $this->serviceRepo->find($id);
        }

        if (empty($service)) {
            return $this->sendError('Service not found');
        }

        return $this->sendResponse($service, 'Service retrieved successfully');
    }

    public function getServiceList(Request $request){
  
        $service = Service::with(['providers','category','serviceRating']);

        if($request->has('status') && isset($request->status)){
            $service->where('status',$request->status);
        }
        
        if($request->has('provider_id')){
            $service->where('provider_id',$request->provider_id);        
        }
        
        if($request->has('category_id')){
            $service->where('category_id',$request->category_id);
        }
        if($request->has('subcategory_id') && $request->subcategory_id != ''){
            $service->whereIn('subcategory_id',explode(',',$request->subcategory_id));
        }
        if($request->has('is_featured')){
            $service->where('is_featured',$request->is_featured);
        }
        if($request->has('is_discount')){
            $service->where('discount','>',0)->orderBy('discount','desc');
        }
        if($request->has('is_rating') && $request->is_rating != ''){
            $service->whereHas('serviceRating', function($q) use ($request) {
                $q->select('service_id',\DB::raw('round(AVG(rating),0) as total_rating'))->groupBy('service_id');
                return $q;
            });
        }
        if($request->has('is_price_min') && $request->is_price_min != '' || $request->has('is_price_max') && $request->is_price_max != ''){
            $service->whereBetween('price', [$request->is_price_min, $request->is_price_max]); 
        }
        if ($request->has('city_id')) {
            $service->whereHas('providers', function ($a) use ($request) {
                $a->where('city_id', $request->city_id);
            });
        }
        
        if($request->has('provider_id') && $request->provider_id != '' ){
            $service->whereHas('providers', function ($a) use ($request) {
                $a->where('status', 1);
            }); 
        }else{
            if(default_earning_type() === 'subscription'){
                $service->whereHas('providers', function ($a) use ($request) {
                    $a->where('status', 1)->where('is_subscribe',1);
                });
            } 
        }
        if ($request->has('latitude') && !empty($request->latitude) && $request->has('longitude') && !empty($request->longitude)) {
            $get_distance = getSettingKeyValue('DISTANCE','DISTANCE_RADIOUS');
            $get_unit = getSettingKeyValue('DISTANCE','DISTANCE_TYPE');
            
            $locations = $service->locationService($request->latitude,$request->longitude,$get_distance,$get_unit);
            $service_in_location = ServiceAddress::whereIn('address_id',$locations)->get()->pluck('service_id');
            $service->with('addresses')->whereIn('id',$service_in_location);
        }

        if($request->has('search')){
            $service->where('name','like',"%{$request->search}%");
        }

        $per_page = config('constant.PER_PAGE_LIMIT');
        if( $request->has('per_page') && !empty($request->per_page)){
            if(is_numeric($request->per_page)){
                $per_page = $request->per_page;
            }
            if($request->per_page === 'all' ){
                $per_page = $service->count();
            }
        }

        $service = $service->where('status',1)->orderBy('created_at','desc')->paginate($per_page);
        $items = ServiceResource::collection($service);

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
            'max'=> $service->max('price'),
            'min'=> $service->min('price'),
        ];
        
        return comman_custom_response($response);
    }

    public function getServiceDetail(Request $request){

        $id = $request->service_id;
        $service = Service::with('providers','category','serviceRating')->findorfail($id);
        $service_detail = new ServiceDetailResource($service);
        $related = $service->where('category_id',$service->category_id)->get();
        $related_service = ServiceResource::collection($related);

        $rating_data = BookingRatingResource::collection($service_detail->serviceRating);

        $customer_reviews = [];
        if($request->customer_id != null){
            $customer_review = BookingRating::where('customer_id',$request->customer_id)->where('service_id',$id)->get();
            if (!empty($customer_review))
            {
                $customer_reviews = BookingRatingResource::collection($customer_review);
            }
        }
        
        $coupon = Coupon::with('serviceAdded')
                ->where('expire_date','>',date('Y-m-d H:i'))
                ->where('status',1)
                ->whereHas('serviceAdded',function($coupon) use($id){
                    $coupon->where('service_id', $id );
                })->get();
        $coupon_data = CouponResource::collection($coupon);
        $tax = ProviderTaxMapping::with('taxes')->where('provider_id',$service->provider_id)->get();
        $taxes = ProviderTaxResource::collection($tax);
        $servicefaq =  ServiceFaq::where('service_id',$id)->get();
        $response = [
            'service_detail'    => $service_detail,
            'rating_data'       => $rating_data,
            'customer_review'   => $customer_reviews,
            'coupon_data'       => $coupon_data,
            'taxes'             => $taxes,
            'related_service'   => $related_service,
            'service_faq'        => $servicefaq
        ];
        return comman_custom_response($response);
    }

    public function getServiceRating(Request $request){

        $rating_data = BookingRating::where('service_id',$request->service_id);

        $per_page = config('constant.PER_PAGE_LIMIT');
        if( $request->has('per_page') && !empty($request->per_page)){
            if(is_numeric($request->per_page)){
                $per_page = $request->per_page;
            }
            if($request->per_page === 'all' ){
                $per_page = $rating_data->count();
            }
        }

        $rating_data = $rating_data->orderBy('id','desc')->paginate($per_page);
        $items = BookingRatingResource::collection($rating_data);

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

    public function saveFavouriteService(Request $request)
    {
        $user_favourite = $request->all();

        $result = UserFavouriteService::updateOrCreate(['id' => $request->id], $user_favourite);

        $message = __('messages.update_form',[ 'form' => __('messages.favourite') ] );
		if($result->wasRecentlyCreated){
			$message = __('messages.save_form',[ 'form' => __('messages.favourite') ] );
		}

        return comman_message_response($message);
    }

    public function deleteFavouriteService(Request $request)
    {
        
        $service_rating = UserFavouriteService::where('user_id',$request->user_id)->where('service_id',$request->service_id)->delete();
        
        $message = __('messages.delete_form',[ 'form' => __('messages.favourite') ] );

        return comman_message_response($message);
    }

    public function getUserFavouriteService(Request $request)
    {
        $user = auth()->user();

        $favourite = UserFavouriteService::where('user_id',$user->id);

        $per_page = config('constant.PER_PAGE_LIMIT');

        if( $request->has('per_page') && !empty($request->per_page)){
            if(is_numeric($request->per_page)){
                $per_page = $request->per_page;
            }
            if($request->per_page === 'all' ){
                $per_page = $favourite->count();
            }
        }

        $favourite = $favourite->orderBy('created_at','desc')->paginate($per_page);

        $items = UserFavouriteResource::collection($favourite);

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
    public function getTopRatedService(){
        $rating_data = BookingRating::orderBy('rating','desc')->limit(5)->get();
        $items = BookingRatingResource::collection($rating_data);

        $response = [
            'data' => $items,
        ];
        
        return comman_custom_response($response);
    }
    public function serviceReviewsList(Request $request){
        $id = $request->service_id;
        $rating_data = BookingRating::where('service_id',$id);

        $per_page = config('constant.PER_PAGE_LIMIT');

        if( $request->has('per_page') && !empty($request->per_page)){
            if(is_numeric($request->per_page)){
                $per_page = $request->per_page;
            }
            if($request->per_page === 'all' ){
                $per_page = $rating_data->count();
            }
        }

        $rating_data = $rating_data->orderBy('created_at','desc')->paginate($per_page);

        $items = BookingRatingResource::collection($rating_data);
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
}