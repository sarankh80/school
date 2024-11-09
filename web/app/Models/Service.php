<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Spatie\MediaLibrary\HasMedia;
use Spatie\MediaLibrary\InteractsWithMedia;
use Illuminate\Database\Eloquent\SoftDeletes;
use Overtrue\LaravelFavorite\Traits\Favoriteable;
use Illuminate\Support\Facades\Auth;
use App\Casts\Money;
use App\Type\AbstractType;
use Spatie\Tags\HasTags;
use App\Models\CategoryRelation;
use Prettus\Repository\Traits\PresentableTrait;

class Service extends Model implements  HasMedia
{
    use InteractsWithMedia, Favoriteable, HasTags, HasFactory, SoftDeletes, PresentableTrait;
    
    protected $fillable = [
        'name', 'sku', 'category_id', 'unit_id', 'visible', 'price_estimate', 'brand_id', 'type' , 'discount' , 'duration' ,'description', 'included', 'excluded', 'is_featured', 'status' , 'price' , 'added_by'
    ];

    protected $casts = [
        'category_id'   => 'integer',
        'provider_id'   => 'integer',
        // 'price'         => Money::class,
        'status'        => 'integer',
        'visible'        => 'integer',
        'is_featured'   => 'boolean',
        'added_by'      => 'integer',
    ];

    /**
     * Interact with the service's currency.
     *
     * @return \Illuminate\Database\Eloquent\Casts\Attribute
     */
    protected function currency(): Attribute
    {
        return Attribute::make(
            get: fn ($value) => $value,
            set: fn ($value) => $value,
        );
    }

    /**
     * Get the price indices that owns the product.
     *
     * @return \Illuminate\Database\Eloquent\Relations\HasMany
     */
    public function price_indices()
    {
        return $this->hasMany(ProductPriceIndex::class, 'product_id', 'id');
    }

    /**
     * Get the product customer group prices that owns the product.
     *
     * @return \Illuminate\Database\Eloquent\Relations\HasMany
     */
    public function customer_group_prices()
    {
        return $this->hasMany(ProductCustomerGroupPrice::class, 'product_id', 'id');
    }

    
    /**
     * Get the providers that owns the Service
     *
     * @return \Illuminate\Database\Eloquent\Relations\BelongsToMany
     */
    public function providers(){
        return $this->belongsToMany(Provider::class, 'provider_service', 'service_id', 'provider_id');
    }

    /**
     * Get the brand that owns the Service
     *
     * @return \Illuminate\Database\Eloquent\Relations\BelongsTo
     */
    public function brand(): BelongsTo
    {
        return $this->belongsTo(Brand::class);
    }

    public function translate()
    {
        return $this->hasMany(TranslateLanguage::class,'re_id')->where('type','service');
    }
    /**
     * Get the category that owns the Service
     *
     * @return \Illuminate\Database\Eloquent\Relations\BelongsTo
     */
    public function category()
    {
        return $this->belongsTo('App\Models\Category','category_id','id')->withTrashed();
    }

    /**
     * Get the subcategory that owns the Service
     *
     * @return \Illuminate\Database\Eloquent\Relations\BelongsTo
     */
    public function subcategory(){
        return $this->belongsTo('App\Models\SubCategory','subcategory_id','id')->withTrashed();
    }

    /**
     * Get the unit that owns the Service
     *
     * @return \Illuminate\Database\Eloquent\Relations\BelongsTo
     */
    public function unit(){
        return $this->belongsTo(Unit::class)->withTrashed();
    }

    /**
     * Get the serviceRating that owns the Service
     *
     * @return \Illuminate\Database\Eloquent\Relations\HasMany
     */
    public function serviceRating(){
        return $this->hasMany(BookingRating::class, 'service_id','id')->orderBy('created_at','desc');
    }

    /**
     * Get the serviceBooking that owns the Service
     *
     * @return \Illuminate\Database\Eloquent\Relations\HasMany
     */
    public function serviceBooking(){
        return $this->hasMany(Booking::class, 'service_id','id');
    }

    /**
     * Get the serviceCoupons that owns the Service
     *
     * @return \Illuminate\Database\Eloquent\Relations\HasMany
     */
    public function serviceCoupons(){
        return $this->hasMany(CouponService::class, 'service_id','id');
    }

    /**
     * Get the coupons that owns the Service
     *
     * @return \Illuminate\Database\Eloquent\Relations\HasMany
     */
    public function coupons()
    {
        return $this->belongsToMany(Coupon::class);
    }

    /**
     * Get the getUserFavouriteService that owns the Service
     *
     * @return \Illuminate\Database\Eloquent\Relations\HasMany
     */
    public function getUserFavouriteService(){
        return $this->hasMany(UserFavouriteService::class, 'service_id','id');
    }

    /**
     * Get the providerAddress that owns the Service
     *
     * @return \Illuminate\Database\Eloquent\Relations\HasMany
     */
    public function providerAddress(){
        return $this->hasMany(Address::class, 'provider_id','id');
    }

    /**
     * Get the providerServiceAddress that owns the Service
     *
     * @return \Illuminate\Database\Eloquent\Relations\HasMany
     */
    public function providerServiceAddress(){
        return $this->hasMany(ServiceAddress::class, 'service_id','id')->with('Address');
    }

    /**
     * Get the relatedServices that owns the Service
     *
     * @return \Illuminate\Database\Eloquent\Relations\hasManyThrough
     */
    public function relatedServices(){
        return $this->hasManyThrough(Service::class, CategoryRelation::class, 'category_id', 'category_id', 'category_id', 'relation_id');
    }

    /**
     * Get the relatedServices that owns the Service
     *
     * @return \Illuminate\Database\Eloquent\Relations\hasManyThrough
     */
    public function relatedCategories(){
        return $this->hasManyThrough(Category::class, CategoryRelation::class, 'category_id', 'id', 'category_id', 'relation_id');
    }

    /**
     * Get the addresses that owns the Service
     *
     * @return \Illuminate\Database\Eloquent\Relations\BelongsToMany
     */
    public function addresses(){
        return $this->belongsToMany(Service::class, 'address_provider_service', 'address_id', 'service_id');
    }

    /**
     * Get the services children that owns the Service
     *
     * @return \Illuminate\Database\Eloquent\Relations\BelongsToMany
     */
    public function children(){
        return $this->belongsToMany(Service::class, 'parent_service', 'parent_id', 'service_id');
    }

    /**
     * Get the parents that owns the Service
     *
     * @return \Illuminate\Database\Eloquent\Relations\BelongsToMany
     */
    public function parents(){
        return $this->belongsToMany(Service::class, 'parent_service', 'service_id', 'parent_id');
    }

    /**
     * Get type instance.
     *
     * @return AbstractType
     *
     * @throws \Exception
     */
    public function getTypeInstance(): AbstractType
    {
        if ($this->typeInstance) {
            return $this->typeInstance;
        }

        $this->typeInstance = app(config('product_types.simple.class'));

        if (! $this->typeInstance instanceof AbstractType) {
            throw new Exception("Please ensure the product type '{$this->type}' is configured in your application.");
        }

        $this->typeInstance->setProduct($this);

        return $this->typeInstance;
    }

    protected static function boot()
    {
        parent::boot();
        static::deleted(function ($row) {
            $row->serviceBooking()->delete();
            $row->serviceCoupons()->delete();
            $row->serviceRating()->delete();
            $row->getUserFavouriteService()->delete();

            if($row->forceDeleting === true)
            {
                $row->serviceRating()->forceDelete();
                $row->serviceCoupons()->forceDelete();
                $row->serviceBooking()->forceDelete();
                $row->getUserFavouriteService()->forceDelete();
            }
        });

        static::restoring(function($row) {
            $row->serviceRating()->withTrashed()->restore();
            $row->serviceCoupons()->withTrashed()->restore();
            $row->serviceBooking()->withTrashed()->restore();
            $row->getUserFavouriteService()->withTrashed()->restore();
        });
    }

    public function scopeMyService($query)
    {
        if(auth()->user()->hasRole('admin')) {
            return $query;
        }

        if(auth()->user()->hasRole('provider')) {
            $services = Provider::find(\Auth::id())->services->pluck('id');

            return $query->whereIn('id', $services);
        }

        return $query; 
    }

    public function scopeProviderService($query, $provider_id)
    {
        $provider = Provider::find($provider_id);

        $services = optional($provider)->services;

        return $query->whereIn('id', $services ? $services->pluck('id') : []);

    }

    public function scopeTotalRated()
    {
        if($this->serviceRating->count() > 0)
        {
            return (float) number_format(max($this->serviceRating->avg('rating'), 0), 2);
        }

        return 0;
    } 

    public function scopeIsFavoritedCustomer()
    { 
        if(auth('sanctum')->check())
        {
            return $this->isFavoritedBy(Auth::guard('sanctum')->user());    
        }

        return false;
    }
    
    public function scopeLocationService($query, $latitude = '', $longitude = '', $radius = 50, $unit = 'km')
    {
        $unit_value = countUnitvalue($unit);
        $near_location_id = Address::selectRaw("id, address, latitude, longitude,
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
        return $near_location_id;        
    }

    public function scopeServiceByLocation($query, $latitude = '', $longitude = '')
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

        $service_in_location = ServiceAddress::whereIn('address_id', $near_location_id)->get()->pluck('service_id');

        return $query->whereIn('id', $service_in_location);
    }
}
