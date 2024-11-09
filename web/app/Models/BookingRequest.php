<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class BookingRequest extends Model
{
    use HasFactory;
    protected $table = 'booking_request';
    protected $fillable = [ 'booking_id', 'provider_id' ];

    protected $casts = [
        'booking_id'   => 'integer',
        'provider_id'  => 'integer',
    ];
}
