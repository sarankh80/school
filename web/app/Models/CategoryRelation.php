<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\Pivot;

class CategoryRelation extends Pivot
{
    protected $table = 'category_relations';
    protected $fillable = [ 'category_id', 'relation_id' ];
    
    protected $casts = [
        'category_id'     => 'integer',
        'relation_id'    => 'integer',
    ];
}
