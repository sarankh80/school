<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Http\JsonResponse;
use Illuminate\Contracts\Validation\Validator;
use Illuminate\Http\Request;
use Illuminate\Http\Exceptions\HttpResponseException;

class UserRequest extends FormRequest
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
     * @return array
     */
    public function rules()
    {
        $id = request()->id;

        return [
            'email'             => 'nullable',
            'phone_number'      => 'required|unique:users,phone_number,' . $id,
            'profile_image'     => 'mimetypes:image/jpeg,image/png,image/jpg,image/gif',
            'password' => 'required|confirmed|min:6',
        ];
    }

    public function messages()
    {
        return [
            'profile_image.*' => __('messages.image_png_gif')
        ];
    }

    protected function failedValidation(Validator $validator)
    {
        if (request()->is('api*')) {
            $data = [
                'status' => 'false',
                'message' => $validator->errors()->first(),
                'all_message' =>  $validator->errors()
            ];

            throw new HttpResponseException(response()->json($data, 422));
        }

        throw new HttpResponseException(redirect()->back()->withInput()->with('errors', $validator->errors()));
    }
}