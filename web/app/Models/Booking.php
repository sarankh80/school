<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use Spatie\Activitylog\Traits\LogsActivity;
use Spatie\Activitylog\LogOptions;
use Spatie\Activitylog\Contracts\Activity;

class Booking extends Model
{
    use HasFactory, SoftDeletes, LogsActivity;
    
    public const STATUS_PENDING = 'pending';

    public const STATUS_ACCEPTED = 'accepted';

    public const STATUS_ONGOING = 'ongoing';

    public const STATUS_INPROGRESS = 'in_progress';

    public const STATUS_CANCELED = 'canceled';

    public const STATUS_HOLD = 'hold';

    public const STATUS_REJECTED = 'rejected';

    public const STATUS_FAILED = 'failed';

    public const STATUS_COMPLETED = 'completed';

    protected $fillable = [
        'customer_id', 'provider_id', 'cart_id', 'date', 'start_at' , 'end_at' ,'amount' , 'discount','total_amount' , 'description' , 'coupon_id' , 'status' , 'payment_id' , 'reason' , 'address' ,'duration_diff' , 'booking_address_id','tax'
    ];

    protected static $recordEvents = ['deleted', 'created', 'updated'];

    protected $casts = [
        'customer_id'   => 'integer',
        'provider_id'   => 'integer',
        // 'amount'        => 'double',
        // 'discount'      => 'double',
        // 'total_amount'  => 'double',
        'coupon_id'     => 'integer',
        'payment_id'    => 'integer',
        'booking_address_id' => 'integer',
        'date' => 'datetime:Y-m-d H:i:s',
    ];

    protected $statusLabel = [
        self::STATUS_PENDING         => 'Pending',
        self::STATUS_ACCEPTED        => 'Accepted',
        self::STATUS_ONGOING         => 'Ongoing',
        self::STATUS_INPROGRESS      => 'In Progress',
        self::STATUS_CANCELED        => 'Canceled',
        self::STATUS_HOLD            => 'Hold',
        self::STATUS_REJECTED        => 'rejected',
        self::STATUS_FAILED          => 'failed',
        self::STATUS_COMPLETED       => 'completed',
    ];

    /**
     * The model's default values for attributes.
     *
     * @var array
     */

    protected $attributes = [
        'status' => 'pending'
    ];

    /**
     * Returns the status label from status code
     */
    public function getStatusLabelAttribute()
    {
        return $this->statusLabel[$this->status];
    }

    public function getActivitylogOptions(): LogOptions
    {
        return LogOptions::defaults()->useLogName('Booking');
    }

    public function tapActivity(Activity $activity, string $eventName)
    {
        $activity->description = __("messages.booking_event.{$eventName}");
    }

    public function customer()
    {
        return $this->belongsTo(User::class,'customer_id', 'id')->withTrashed();
    }

    public function provider()
    {
        return $this->belongsTo(User::class,'provider_id', 'id')->withTrashed();
    }

    public function service()
    {
        return $this->belongsTo(Service::class,'service_id', 'id')->withTrashed();
    }

    public function coupon()
    {
        return $this->belongsTo(Coupon::class,'coupon_id', 'id');
    }

    public function payment()
    {
        return $this->belongsTo(Payment::class,'id', 'booking_id')->withTrashed();
    }

    public function bookingRating()
    {
        return $this->hasMany(BookingRating::class, 'service_id','service_id')->with(['customer']);
    }

    public function bookingRatings()
    {
        return $this->hasMany(BookingRating::class, 'service_id', 'service_id')->orderBy('id', 'desc')->with(['customer'])->limit(10);
    }

    public function couponAdded()
    {
        return $this->belongsTo(BookingCouponMapping::class, 'id', 'booking_id');
    }

    public function handymanAdded()
    {
        return $this->hasMany(BookingHandymanMapping::class, 'booking_id', 'id')->with(['handyman']);
    }

    /**
     * Get the items that owns the Booking
     *
     * @return \Illuminate\Database\Eloquent\Relations\HasMany
     */
    public function items()
    {
        return $this->hasMany(BookingItem::class);
    }

    /**
     * Get the booking invoices record associated with the booking.
     */
    public function invoices()
    {
        return $this->hasMany(Invoice::class);
    }

    /**
     * Get the provider that owns the Booking 
     *
     * @return \Illuminate\Database\Eloquent\Relations\BelongsToMany
     */
    public function requestProvider()
    {
        return $this->belongsToMany(User::class, 'booking_request', 'booking_id', 'provider_id');
    }
    
    public function bookingActivity(){
        return $this->hasMany(BookingActivity::class, 'booking_id', 'id');
    }

    public function scopeBookingRequest($query, $provider_id)
    {
        $booking_ids = BookingRequest::where('provider_id', $provider_id)->get()->pluck('booking_id');

        return $query->whereIn('id', $booking_ids);
    }

    public function scopeMyBooking($query){
        $user = auth()->user();
        if($user->hasRole('admin') || $user->hasRole('demo_admin')) {
            return $query;
        }

        if($user->hasRole('provider')) {
            return $query->where('provider_id', $user->id);
        }

        if($user->hasRole('user')) {
            return $query->where('customer_id', $user->id);
        }

        if($user->hasRole('handyman')) {
            return $query->whereHas('handymanAdded',function ($q) use($user){
                $q->where('handyman_id',$user->id);
            });
        }

        return $query;
    }

    public function categoryService(){
        return $this->belongsTo(Service::class,'service_id', 'id')->with('category');
    }
 
    public function addressAdded(){
        return $this->belongsTo(BookingAddressMapping::class,'id','booking_id');
    }

    public function bookingTaxMapping(){
        return $this->hasMany(BookingTaxMapping::class,'id','booking_id');
    }

    public function scopeProviderByLocation($query, $latitude = '', $longitude = '')
    {
        $radius = getSettingKeyValue('DISTANCE', 'DISTANCE_RADIOUS');
        $unit = getSettingKeyValue('DISTANCE', 'DISTANCE_TYPE');
        $unit_value = countUnitvalue($unit);

        $near_location_id = Address::selectRaw("id,
                ( $unit_value * acos( cos( radians($latitude) ) *
                cos( radians( latitude ) )
                * cos( radians( longitude ) - radians($longitude)
                ) + sin( radians($latitude) ) *
                sin( radians( latitude ) ) )
                ) AS distance")
        ->where('status',1)
        ->having("distance", "<=", $radius)
        ->orderBy("distance",'asc')
        ->get()->pluck('id');

        return ServiceAddress::whereIn('address_id', $near_location_id)->groupBy('provider_id')->get()->pluck('provider_id');
    }

    protected static function boot(){
        parent::boot();
        static::deleted(function ($row) {
            $row->couponAdded()->delete();
            $row->bookingActivity()->delete();
            $row->payment()->delete();
            $row->handymanAdded()->delete();
            $row->bookingRating()->delete();
            if($row->forceDeleting === true)
            {
                $row->couponAdded()->delete();
                $row->bookingActivity()->delete();
                $row->payment()->delete();
                $row->handymanAdded()->delete();
                $row->bookingRating()->delete();
            }
        });

        static::restoring(function($row) {
            $row->service()->withTrashed()->restore();
            $row->provider()->withTrashed()->restore();
            $row->customer()->withTrashed()->restore();
            $row->bookingActivity()->withTrashed()->restore(); 
            $row->couponAdded()->withTrashed()->restore();
            $row->payment()->withTrashed()->restore();
            $row->handymanAdded()->withTrashed()->restore();
            $row->bookingRating()->withTrashed()->restore();
        });        
    }

    public function handymanByAddress(){
        return $this->belongsTo(Address::class,'booking_address_id','id')->with(['handyman']);
    }

    public function getTaxesValue(): float
    {
        $total = $this->total_amount;
        $taxValue = 0;
        if (!empty($this->tax)) {
            foreach (json_decode($this->tax,true) as $tax) {
                if ($tax['type'] == 'percent') {
                    $taxValue += ($total * $tax['value'] / 100);
                } else {
                    $taxValue += $tax['value'];
                }
            }
        }
        return $taxValue;
    }

    public function providerAddress(){
        return $this->belongsTo(Address::class,'booking_address_id','id');
    }

    public function customerAddress()
    {
        return $this->belongsTo(Address::class, 'booking_address_id', 'id');
    }

    /**
     * Checks if new shipment is allow or not
     *
     * @return bool
     */
    public function canShip(): bool
    {
        if ($this->status === self::STATUS_REJECTED) {
            return false;
        }

        foreach ($this->items as $item) {
            if ($item->booking->status !== self::STATUS_REJECTED)
            {
                return true;
            }
        }

        return false;
    }

    /**
     * Checks if new invoice is allow or not
     *
     * @return bool
     */
    public function canInvoice(): bool
    {
        if ($this->status === self::STATUS_FAILED || 
            $this->status === self::STATUS_REJECTED || 
            $this->status === self::STATUS_CANCELED) 
        {
            return false;
        }

        foreach ($this->items as $item) {
            if ($item->booking->status !== self::STATUS_REJECTED 
                && $item->booking->status !== self::STATUS_FAILED
                && $item->booking->status !== self::STATUS_CANCELED
            ) {
                return true;
            }
        }

        return false;
    }

    /**
     * Verify if a invoice is still unpaid
     *
     * @return bool
     */
    public function hasOpenInvoice(): bool
    {
        $pendingInvoice = $this->invoices()->where('state', 'pending')
            ->orWhere('state', 'pending_payment')
            ->first();

        if ($pendingInvoice) {
            return true;
        }

        return false;
    }

    /**
     * Checks if order can be canceled or not
     *
     * @return bool
     */
    public function canCancel(): bool
    {
        if (
            $this->payment->method == 'cashondelivery'
            && core()->getConfigData('sales.paymentmethods.cashondelivery.generate_invoice')
        ) {
            return false;
        }

        if (
            $this->payment->method == 'moneytransfer'
            && core()->getConfigData('sales.paymentmethods.moneytransfer.generate_invoice')
        ) {
            return false;
        }

        if ($this->status === self::STATUS_FRAUD) {
            return false;
        }

        $pendingInvoice = $this->invoices->where('state', 'pending')
            ->first();

        if ($pendingInvoice) {
            return true;
        }

        foreach ($this->items as $item) {
            if (
                $item->canCancel()
                && $item->order->status !== self::STATUS_CLOSED
            ) {
                return true;
            }
        }

        return false;
    }

    /**
     * Checks if booking can be refunded or not
     *
     * @return bool
     */
    public function canRefund(): bool
    {
        if ($this->status === self::STATUS_REJECTED) {
            return false;
        }

        $pendingInvoice = $this->invoices->where('state', 'pending')->first();

        if ($pendingInvoice) {
            return false;
        }

        foreach ($this->items as $item) {
            if ($item->booking->status !== self::STATUS_REJECTED)
            {
                return true;
            }
        }

        return false;
    }

}
