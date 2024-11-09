<?php

namespace App\Listeners;

use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Queue\InteractsWithQueue;
use App\Events\ReadNotification;

class MarkReadNotification
{
    /**
     * Handle the event.
     *
     * @param  object  $event
     * @return void
     */
    public function handle(ReadNotification $event)
    {
        if(count(auth()->user()->unreadNotifications) > 0 ) {
            auth()->user()->unreadNotifications->where('data.id', $event->id)->markAsRead();
        }
    }
}
