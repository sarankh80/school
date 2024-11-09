<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class BookingItem extends Model
{
    use HasFactory;

    protected $fillable = [
        'service_id',
        'booking_id',
        'sku',
        'name',
        'qty_ordered',
        'price',
        'base_price',
        'quantity',
        'total',
        'discount_percent',
        'discount_amount',
        'base_total'
    ];

    /**
     * Get the booking that owns the BookingItem
     *
     * @return \Illuminate\Database\Eloquent\Relations\BelongsTo
     */
    public function booking(){
        return $this->belongsTo(Booking::class);
    }
      
    /**
     * Get the service that owns the BookingItem
     *
     * @return \Illuminate\Database\Eloquent\Relations\BelongsTo
     */
    public function service(){
        return $this->belongsTo(Service::class);
    }

    public function handyman()
    {
        return $this->hasMany(BookingHandymanMapping::class, 'booking_id', 'id')->with(['handyman']);
    }

    public function scopeShowServiceCount($query){
        $query->select(\DB::raw('DISTINCT service_id, COUNT(*) AS count_pid'))
              ->groupBy('service_id')
              ->orderBy('count_pid', 'desc');
        return $query;
    }

    public function scopeMyBooking($query){
        $user = auth()->user();
        if($user->hasRole('admin') || $user->hasRole('demo_admin')) {
            return $query;
        }

        if($user->hasRole('provider')) {
            return $query->whereHas('booking', function ($q) use($user){
                $q->where('provider_id', $user->id);
            });
        }

        if($user->hasRole('user')) {
            return $query->whereHas('booking', function ($q) use($user){
                $q->where('customer_id', $user->id);
            });
        }

        if($user->hasRole('handyman')) {
            return $query->whereHas('handyman',function ($q) use($user){
                $q->where('handyman_id', $user->id);
            });
        }

        return $query;
    }

}
