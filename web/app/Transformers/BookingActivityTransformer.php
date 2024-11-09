<?php

namespace App\Transformers;

use App\Models\BookingActivity;
use League\Fractal\TransformerAbstract;

class BookingActivityTransformer extends TransformerAbstract
{
    /**
     * @param App\Models\BookingActivity $activity
     * @return array
     */
    public function transform(BookingActivity $activity): array
    {
        return [
            'id' => (int) $activity->id,
            'booking_id' => $activity->booking_id,
            'description' => $activity->activity_message,
            'event' => $activity->activity_type,
            'datetime' => $activity->datetime,
            'created_at' => $activity->datetime,
            'updated_at' => $activity->updated_at
        ];
    }
}