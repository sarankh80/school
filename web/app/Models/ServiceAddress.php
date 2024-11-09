<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class ServiceAddress extends Model
{
    use HasFactory;
    protected $table = 'address_provider_service';
    protected $fillable = [ 'service_id', 'address_id', 'provider_id' ];

    protected $casts = [
        'service_id'   => 'integer',
        'address_id'   => 'integer',
        'provider_id'  => 'integer',
    ];
    
    public function Address(){
        return $this->belongsTo(Address::class,'address_id', 'id');
    }
    public function providers(){
        return $this->belongsTo(Provider::class, 'provider_id','id');
    }
}
