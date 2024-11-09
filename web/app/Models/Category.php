<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Spatie\MediaLibrary\HasMedia;
use Spatie\MediaLibrary\InteractsWithMedia;
use Illuminate\Database\Eloquent\SoftDeletes;
use Kalnoy\Nestedset\NodeTrait;

class Category extends Model implements HasMedia
{
    use HasFactory, InteractsWithMedia, SoftDeletes, NodeTrait;

    protected $table = 'categories';
    protected $fillable = [
        'name', 'position', 'description', 'is_featured', 'status', 'color', 'parent_id','translate'
    ];

    protected $casts = [
        'status'    => 'integer',
        'is_featured'  => 'integer',
    ];

    public function services()
    {
        return $this->hasMany(Service::class, 'category_id', 'id');
    }

    public function brands()
    {
        return $this->belongsToMany(Brand::class, 'services', 'category_id', 'brand_id')->distinct();
    }

    /**
     * Get the categories children that owns the Service
     *
     * @return \Illuminate\Database\Eloquent\Relations\BelongsToMany
     */
    public function children(){
        return $this->belongsToMany(Category::class, 'category_relations', 'relation_id', 'category_id');
    }

    /**
     * Get the relations that owns the Category
     *
     * @return \Illuminate\Database\Eloquent\Relations\BelongsToMany
     */
    public function related(){
        return $this->belongsToMany(Category::class, 'category_relations', 'category_id', 'relation_id');
    }
    public function translate()
    {
        return $this->hasMany(TranslateLanguage::class,'re_id')->where('type','category');
    }
    public function childrens()
    {
        return $this->hasMany(Category::class, 'parent_id');
    }
}
