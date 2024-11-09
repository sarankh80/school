<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Http\JsonResponse;
use Illuminate\Contracts\Validation\Validator;
use Illuminate\Http\Request;
use Illuminate\Http\Exceptions\HttpResponseException;

class ProviderLoginRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     *
     * @return bool
     */
    public function authorize()
    {
        return true;
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array<string, mixed>
     */
    public function rules()
    {
        return [
            'phone_number'    => 'required',
            'password' => 'required',
        ];
    }


    protected function failedValidation(Validator $validator)
    {
        $data = [
            'status' => 'false',
            'message' => $validator->errors()->first(),
            'all_message' =>  $validator->errors()
        ];

        throw new HttpResponseException(response()->json($data, 422));    
    }
}
