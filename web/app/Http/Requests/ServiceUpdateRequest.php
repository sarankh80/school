<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rules\File;
use Illuminate\Validation\Rule;
use App\Models\Service;

class ServiceUpdateRequest extends FormRequest
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
            'name'                  => 'required',
            'category_id'           => 'required',
            'price'                 => 'required',
            'status'                => 'required',
            'service_attachment'    => [Rule::requiredIf($this->media()->count()== 0)],
        ];
    }

    /**
     * Prepare the data for validation.
     *
     * @return void
     */
    protected function prepareForValidation()
    {
        $this->merge([
            'is_featured' => isset($this->is_featured) ? 1 : 0,
            'visible' => isset($this->visible) ? 1 : 0,
            'price_estimate' => isset($this->price_estimate) ? 1 : 0,
        ]);
    }

    private function media()
    {
        return Service::find($this->id)->getMedia('service_attachment');
    }
}
