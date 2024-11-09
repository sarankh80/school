<?php

namespace App\Http\Controllers\API\V2\Auth;

use App\Http\Controllers\Controller;
use Illuminate\Auth\Events\PasswordReset;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;
use App\Http\Requests\NewPasswordRequest;
use App\Models\Provider;

class NewProviderPasswordController extends Controller
{
    /**
     * Handle an incoming new password request.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\RedirectResponse
     *
     * @throws \Illuminate\Validation\ValidationException
     */
    public function store(NewPasswordRequest $request)
    {
        // Here we will attempt to reset the user's password. If it is successful we
        // will update the password on an actual user model and persist it to the
        // database. Otherwise we will parse the error and return the response.

        $provider = Provider::where('phone_number', $request->phone_number)->first();
        if(empty($provider)){
            return $this->sendError('User not found');
        }

        $provider->forceFill([
            'password' => $request->password,
            'remember_token' => Str::random(60),
        ])->save();

        event(new PasswordReset($provider));

        // If the password was successfully reset, we will redirect the user back to
        // the application's home authenticated view. If there is an error we can
        // redirect them back to where they came from with their error message.
        return $this->sendResponse($provider, 'Reset Password successfully');
    }
}
