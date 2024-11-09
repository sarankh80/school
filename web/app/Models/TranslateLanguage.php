<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Spatie\Translatable\HasTranslations;
use Spatie\MediaLibrary\InteractsWithMedia;
use Illuminate\Database\Eloquent\SoftDeletes;
class TranslateLanguage extends Model
{
    use HasFactory,HasTranslations,SoftDeletes,InteractsWithMedia;
    protected $table = 'translate_languages';
    public $translatable = ['name','des','included','excluded','lang'];
    protected $fillable = [
        'name', 'des','included', 'excluded','lang'
    ];    
    protected $casts = [
        're_id'  => 'integer',
        'type'    => 'integer',        
        'name' => 'array',
        'des' => 'array',
        'included' => 'array',
        'excluded' => 'array',
        'lang' => 'array',
    ];    

    public function categories()
    {
        return $this->hasMany(Category::class,'id');
    }
    public function brands()
    {
        return $this->hasMany(Brand::class,'id');
    }
    public function services()
    {
        return $this->hasMany(Service::class,'id');
    }
}
