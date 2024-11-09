<?php

namespace App\Http\Resources\API;

use Illuminate\Http\Resources\Json\JsonResource;

class ServiceResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return array
     */
    public function toArray($request)
    {
        $user_id = request()->customer_id;
        $image = getSingleMedia($this,'service_attachment', null);
        $file_extention = config('constant.IMAGE_EXTENTIONS');
        $extention = in_array(strtolower(imageExtention($image)),$file_extention);
        $price = $this->price - (($this->price * $this->discount) / 100);
        return [
            'id'            => $this->id,
            'name'          => $this->name,
            'category_id'   => $this->category_id,
            'subcategory_id'=> $this->subcategory_id,
            'provider_id'   => $this->provider_id,
            'base_price'    => $this->price,
            'price'         => number_format($price, 2, '.', ''),
            'price_format'  => getPriceFormat($this->price),
            'type'          => $this->type,
            'discount'      => $this->discount,
            'duration'      => $this->duration,
            'status'        => $this->status,
            'description'   => $this->description,
            'is_featured'   => $this->is_featured,
            // 'provider_name' => optional($this->providers)->display_name,
            // 'provider_image' => optional($this->providers)->login_type != null ?  optional($this->providers)->social_image : getSingleMedia(optional($this->providers), 'profile_image',null),
            // 'city_id' => optional($this->providers)->city_id,
            'category_name'  => optional($this->category)->name,
            'subcategory_name'  => optional($this->subcategory)->name,
            'attchments' => getAttachments($this->getMedia('service_attachment')),
            'attchments_array' => getAttachmentArray($this->getMedia('service_attachment'),null),
            'total_review'  => $this->serviceRating->count('id'),
            'total_rating'  => count($this->serviceRating) > 0 ? (float) number_format(max($this->serviceRating->avg('rating'),0), 2) : 0,
            'is_favourite'  => $this->getUserFavouriteService->where('user_id',$user_id)->first() ? 1 : 0,
            'service_address_mapping' => $this->addresses,
            'attchment_extension' => $extention //true:for png false: other
        ];
    }
}
