<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Spatie\MediaLibrary\HasMedia;
use Spatie\MediaLibrary\InteractsWithMedia;
use Illuminate\Database\Eloquent\SoftDeletes;

class Brand extends Model implements HasMedia
{
    use InteractsWithMedia, HasFactory, SoftDeletes;

    protected $fillable = [
        'name', 'status'
    ];

    protected $casts = [
        'status'    => 'integer',
    ];
    /**
     * Get all of the services for the Brand
     *
     * @return \Illuminate\Database\Eloquent\Relations\HasMany
     */
    public function services(): HasMany
    {
        return $this->hasMany(Service::class);
    }
    public function translate()
    {
        return $this->hasMany(TranslateLanguage::class,'re_id')->where('type','brand');
    }
}
