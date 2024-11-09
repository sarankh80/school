<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Address;
use App\Http\Resources\API\AddressResource;
use App\Repositories\ProviderAddressRepository;
use App\Http\Requests\AddressRequest;
use Prettus\Repository\Criteria\RequestCriteria;
use Prettus\Repository\Exceptions\RepositoryException;
use App\Criteria\LimitOffsetCriteria;
use App\Criteria\AddressByProviderCriteria;

class ProviderAddressController extends Controller
{
    /**
     * @var ProviderAddressRepository
     */
    protected $addressRepo;

    public function __construct(ProviderAddressRepository $addressRepository){
        $this->addressRepo = $addressRepository;
    }

    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index($provider_id, Request $request)
    {
        try {
            $this->addressRepo->pushCriteria(new RequestCriteria($request));
            $this->addressRepo->pushCriteria(new AddressByProviderCriteria($provider_id));
            $this->addressRepo->pushCriteria(new LimitOffsetCriteria($request));

            if (!empty($request->page)) {
                $addresses = $this->addressRepo->paginate($limit = 10, $columns = ['*']);
            } else {
                $addresses = $this->addressRepo->get();
            }
        } catch (RepositoryException $e) {
            return $this->sendError($e->getMessage());
        }

        return $this->sendResponse($addresses, 'Addresses fetched successfully');
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store($provider_id, AddressRequest $request)
    {
        $param = array_merge($request->all(), ['addressable_id' => $provider_id]);
        $this->addressRepo->create($param);

        return comman_message_response(__('messages.save_form', ['form' => __('messages.provider_address')]));
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update($provider_id, AddressRequest $request, $id)
    {
        $param = array_merge($request->all(), ['addressable_id' => $provider_id]);

        $this->addressRepo->update($param, $id);

        return comman_message_response(__('messages.update_form_title', ['form' => __('messages.provider_address')]));
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy($provider_id, $id)
    {
        $this->addressRepo->delete($id);

        return comman_custom_response(['message'=> __('messages.msg_deleted', ['name' => __('messages.provider_address')] ) , 'status' => true]);
    }

    public function getProviderAddressList(Request $request){

        $address = Address::with('providers')->where('status',1)->where('provider_id', $request->provider_id);

        if($request->has('status') && isset($request->status)){
            $address->where('status',$request->status);
        }

        $address->whereHas('providers', function ($a) use ($request) {
            $a->where('status', 1);
        });
 
        $per_page = config('constant.PER_PAGE_LIMIT');
        if( $request->has('per_page') && !empty($request->per_page)){
            if(is_numeric($request->per_page)){
                $per_page = $request->per_page;
            }
            if($request->per_page === 'all' ){
                $per_page = $address->count();
            }
        }

        $address = $address->orderBy('created_at','desc')->paginate($per_page);
        $items = AddressResource::collection($address);

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