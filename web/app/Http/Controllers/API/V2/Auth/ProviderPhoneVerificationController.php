<?php

namespace App\Http\Controllers\API\V2\Auth;

use App\Http\Controllers\Controller;
use App\Providers\RouteServiceProvider;
use Illuminate\Http\Request;
use App\Repositories\ProviderRepository;
use Illuminate\Http\Exceptions\HttpResponseException;

class ProviderPhoneVerificationController extends Controller
{

    /**
     * Customer respository instance.
     *
     * @var App\Repositories\ProviderRepository
     */
    protected $providerRepository;

    /**
     * Controller instance.
     *
     * @param  App\Repositories\ProviderRepository  $providerRepository
     * @return void
     */
    public function __construct(
        ProviderRepository $providerRepository,
    ) {
        $this->providerRepository = $providerRepository;
    }
    /**
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        $customer = $this->providerRepository->where('phone_number', $request->phone_number)->first();

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
