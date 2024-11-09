<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class CatalogRuleProductPrice extends Model
{
    public $timestamps = false;

    protected $fillable = [
        'price',
        'rule_date',
        'starts_from',
        'ends_till',
        'catalog_rule_id',
        'channel_id',
        'customer_group_id',
    ];
}