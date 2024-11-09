<?php

namespace App\Http\Controllers\API\V2;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App\Models\Booking;
use App\Models\Notification;

class BookingAssignController extends Controller
{
    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store($booking_id, Request $request)
    {
        $booking = Booking::find($booking_id);

        $assigned_handyman_ids = [];
        if($bookingdata->handymanAdded()->count() > 0){
            $assigned_handyman_ids = $bookingdata->handymanAdded()->pluck('handyman_id')->toArray();
            $bookingdata->handymanAdded()->delete();
            $message = __('messages.transfer_to_handyman');
            $activity_type = 'transfer_booking';
        } else {
            $message = __('messages.assigned_to_handyman');
            $activity_type = 'assigned_booking';
        }

        $remove_notification_id = [];
        if($request->handyman_id != null) {
            foreach($request->handyman_id as $handyman) {
                $assign_to_handyman = [
                    'booking_id'   => $bookingdata->id,
                    'handyman_id'  => $handyman
                ];
                $remove_notification_id = removeArrayValue($handyman, $assigned_handyman_ids);
                $bookingdata->handymanAdded()->insert($assign_to_handyman);
            }
        }

        if(!empty($remove_notification_id)){
            $search = "id".'":'.$bookingdata->id;
            
            Notification::whereIn('notifiable_id',$remove_notification_id)
                ->whereJsonContains('data->id',$bookingdata->id)
                ->delete();
        }

        $activity_data = [
            'activity_type' => $activity_type,
            'booking_id' => $bookingdata->id,
            'booking' => $bookingdata,
        ];

        saveBookingActivity($activity_data);
        $message = __('messages.save_form',[ 'form' => __('messages.booking') ] );
        if($request->is('api/*')) {
            return comman_message_response($message);
		}

        return response()->json(['status' => true,'event' => 'callback' , 'message' => $message]);
    }
}
