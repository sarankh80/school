<?php

namespace Webkul\CatalogRule\Models;

use Illuminate\Database\Eloquent\Model;
use Webkul\CatalogRule\Contracts\CatalogRule as CatalogRuleContract;
use App\Models\Channel;
use App\Models\CustomerGroup;

class CatalogRule extends Model implements CatalogRuleContract
{
    protected $fillable = [
        'name',
        'description',
        'starts_from',
        'ends_till',
        'status',
        'condition_type',
        'conditions',
        'end_other_rules',
        'action_type',
        'discount_amount',
        'sort_order',
    ];

    protected $casts = [
        'conditions' => 'array',
    ];

    /**
     * Get the channels that owns the catalog rule.
     */
    public function channels()
    {
        return $this->belongsToMany(Channel::class, 'catalog_rule_channels');
    }

    /**
     * Get the customer groups that owns the catalog rule.
     */
    public function customer_groups()
    {
        return $this->belongsToMany(CustomerGroup::class, 'catalog_rule_customer_groups');
    }
    
    /**
     * Get the Catalog rule Product that owns the catalog rule.
     */
    public function catalog_rule_products()
    {
        return $this->hasMany(CatalogRuleProductProxy::modelClass());
    }

    /**
     * Get the Catalog rule Product that owns the catalog rule.
     */
    public function catalog_rule_product_prices()
    {
        return $this->hasMany(CatalogRuleProductPriceProxy::modelClass());
    }
}