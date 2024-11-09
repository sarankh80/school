<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\Pivot;
use Illuminate\Database\Eloquent\SoftDeletes;

class CouponService extends Pivot
{
    use HasFactory, SoftDeletes;
    protected $table = 'coupon_service';
    protected $dates = ['deleted_at'];
    protected $fillable = [ 'coupon_id', 'service_id' ];
    
    protected $casts = [
        'coupon_id'     => 'integer',
        'service_id'    => 'integer',
    ];
    
    public function coupon(){
        return $this->belongsTo(Coupon::class,'coupon_id','id');
    }

    public function service(){
        return $this->belongsTo(Service::class,'service_id','id');
    }
}
