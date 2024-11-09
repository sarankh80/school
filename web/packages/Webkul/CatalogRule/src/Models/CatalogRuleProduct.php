<?php

namespace Webkul\CatalogRule\Models;

use Illuminate\Database\Eloquent\Model;
use App\Models\Service;
use App\Models\Channel;
use App\Models\CustomerGroup;
use Webkul\CatalogRule\Contracts\CatalogRuleProduct as CatalogRuleProductContract;

class CatalogRuleProduct extends Model implements CatalogRuleProductContract
{
    public $timestamps = false;

    protected $fillable = [
        'starts_from',
        'ends_till',
        'discount_amount',
        'action_type',
        'end_other_rules',
        'sort_order',
        'catalog_rule_id',
        'channel_id',
        'customer_group_id',
        'product_id',
    ];

    /**
     * Get the Catalog Rule that owns the catalog rule.
     */
    public function catalog_rule()
    {
        return $this->belongsTo(CatalogRuleProxy::modelClass(), 'catalog_rule_id');
    }

    /**
     * Get the Product that owns the catalog rule.
     */
    public function product()
    {
        return $this->belongsTo(Service::class, 'product_id');
    }

    /**
     * Get the channels that owns the catalog rule.
     */
    public function channel()
    {
        return $this->belongsTo(Channel::class, 'channel_id');
    }

    /**
     * Get the customer groups that owns the catalog rule.
     */
    public function customer_group()
    {
        return $this->belongsTo(CustomerGroup::class, 'customer_group_id');
    }
}
