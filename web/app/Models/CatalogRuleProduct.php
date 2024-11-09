<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class CatalogRuleProduct extends Model
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
        return $this->belongsTo(CatalogRule::class, 'catalog_rule_id');
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
