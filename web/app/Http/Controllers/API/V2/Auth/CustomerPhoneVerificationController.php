<?php

namespace App\Http\Controllers\API\V2\Auth;

use App\Http\Controllers\Controller;
use App\Providers\RouteServiceProvider;
use Illuminate\Http\Request;
use App\Repositories\CustomerRepository;
use Illuminate\Http\Exceptions\HttpResponseException;

class CustomerPhoneVerificationController extends Controller
{

    /**
     * Customer respository instance.
     *
     * @var App\Repositories\CustomerRepository
     */
    protected $customerRepository;

    /**
     * Controller instance.
     *
     * @param  App\Repositories\CustomerRepository  $customerRepository
     * @return void
     */
    public function __construct(
        CustomerRepository $customerRepository,
    ) {
        $this->customerRepository = $customerRepository;
    }
    /**
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        $customer = $this->customerRepository->where('phone_number', $request->phone_number)->first();

        if(empty($customer))
        {
            throw new HttpResponseException(response()->json([
                'phone_number' => ['This phone number not yet register.'],
            ], 422));
        }
        if ($customer->phoneVerified()) {
            return response([
                'message' => 'This phone number already verified.'
            ]);
        }

        $customer->phoneVerifiedAt();

        return response([
            'message' => 'This phone number verified successfully.'
        ]);    }
}
