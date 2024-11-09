<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Parental\HasChildren;
use Spatie\MediaLibrary\HasMedia;
use Spatie\MediaLibrary\InteractsWithMedia;

class Address extends Model implements HasMedia
{
    use HasFactory, HasChildren, InteractsWithMedia;

    protected $fillable = [ 'addressable_id', 'addressable_type', 'title', 'type', 'address', 'floor', 'note', 'is_default', 'latitude' , 'longitude' ,'status' ];

    protected $casts = [
        'status'        => 'integer',
    ];

    protected $childColumn = 'addressable_type';

    protected $childTypes = [
        'customer' => CustomerAddress::class,
        'provider' => ProviderAddress::class,
    ];
    
    /**
     * Get the providers that owns the Address
     *
     * @return \Illuminate\Database\Eloquent\Relations\BelongsToMany
     */
    public function providers(){
        return $this->belongsTo(Provider::class, 'addressable_id','id');
    }

    public function getServiceAddress(){
        return $this->hasMany(ServiceAddress::class);
    }

    public function scopeMyAddress($query){
        $user = auth()->user();
        if($user->hasRole('admin')) {
            return $query;
        }

        if($user->hasRole('provider')) {
            return $query->where('provider_id', $user->id);
        }
        
        return $query;
    }

    public function handyman(){
        return $this->hasMany(User::class, 'service_address_id','id');
    }

    /**
     * Get the services that owns the Address
     *
     * @return \Illuminate\Database\Eloquent\Relations\BelongsToMany
     */
    public function services()
    {
        return $this->belongsToMany(Service::class, 'address_provider_service', 'address_id', 'service_id');
    }
}
