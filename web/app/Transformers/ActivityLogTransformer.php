<?php

namespace App\Transformers;

use Spatie\Activitylog\Models\Activity;
use League\Fractal\TransformerAbstract;

class ActivityLogTransformer extends TransformerAbstract
{
    /**
     * @param Spatie\Activitylog\Models\Activity $activity
     * @return array
     */
    public function transform(Activity $activity): array
    {
        return [
            'id' => (int) $activity->id,
            'name' => $activity->log_name,
            'description' => $activity->description,
            'event' => $activity->event,
            'created_at' => $activity->created_at,
            'updated_at' => $activity->updated_at
        ];
    }
}