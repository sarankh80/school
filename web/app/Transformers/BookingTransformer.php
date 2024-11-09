<?php

namespace App\Transformers;

use League\Fractal\TransformerAbstract;
use App\Models\BookingStatus;
use App\Models\Booking;

/**
 * Class BookingTransformer.
 *
 * @package namespace App\Transformers;
 */
class BookingTransformer extends TransformerAbstract
{
    /**
     * List of resources to automatically include
     *
     * @var array
     */
    protected  array $defaultIncludes = ['items', 'customer', 'provider', 'activities', 'address'];

    /**
     * Transform the Service model.
     *
     * @param \App\Models\Service $model
     *
     * @return array
     */
    public function transform(Booking $booking): array 
    {
        return [
            'id'                    => $booking->id,
            'address'               => $booking->address,
            'customer_id'           => $booking->customer_id,
            'provider_id'           => $booking->provider_id,
            'cart_id'               => $booking->cart_id,
            'date'                  => $booking->date->format('Y-m-d H:i:s'),
            'discount'              => number_format($booking->discount, 2, '.', ''),
            'status'                => $booking->status,
            'status_label'          => BookingStatus::bookingStatus($booking->status),
            'description'           => $booking->description,
            'provider_name'         => optional($booking->provider)->display_name,
            'customer_name'         => optional($booking->customer)->display_name,
            'payment_id'            => $booking->payment_id,
            'payment_status'        => optional($booking->payment)->payment_status,
            'payment_method'        => optional($booking->payment)->payment_type,
            'provider_name'         => optional($booking->provider)->display_name,
            'customer_name'         => optional($booking->customer)->display_name,
            'handyman'              => isset($booking->handymanAdded) ? $booking->handymanAdded : [],
            'booking_address_id'    => $booking->booking_address_id,
            'taxes'                 => json_decode($booking->tax,true),
            'coupon_data'           => isset($booking->couponAdded) ? $booking->couponAdded : null,
            'total_amount'          => number_format($booking->total_amount, 2, '.', ''),
            'amount'                => number_format($booking->amount, 2, '.', ''),
        ];
    }

    /**
     * Include Items
     *
     * @param Booking $booking
     * @return \League\Fractal\Resource\collection
     */
    public function includeItems(Booking $booking)
    {
        $items = $booking->items;

        return $this->collection($items, new ItemTransformer);
    }

    /**
     * Include Activities
     *
     * @param Booking $booking
     * @return \League\Fractal\Resource\collection
     */
    public function includeActivities(Booking $booking)
    {
        $activities = $booking->bookingActivity;

        return $this->collection($activities, new BookingActivityTransformer);
    }

    /**
     * Include Customer
     *
     * @param Booking $booking
     * @return \League\Fractal\Resource\collection
     */
    public function includeCustomer(Booking $booking)
    {
        $customer = $booking->customer;

        return $this->item($customer, new CustomerTransformer);
    }

    /**
     * Include Provider
     *
     * @param Booking $booking
     * @return \League\Fractal\Resource\item
     */
    public function includeProvider(Booking $booking)
    {
        $provider = optional($booking)->provider;

        if(!empty($provider))
        {
            return $this->item($provider, new ProviderTransformer);

        }
    }

    /**
     * Include Provider
     *
     * @param Booking $booking
     * @return \League\Fractal\Resource\item
     */
    public function includeAddress(Booking $booking)
    {
        $address = optional($booking)->customerAddress;

        if(!empty($address))
        {
            return $this->item($address, new AddressTransformer);

        }
    }
}
