<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ProductPriceIndex extends Model
{
    /**
     * Fillable.
     *
     * @var array
     */
    protected $fillable = [
        'min_price',
        'regular_min_price',
        'max_price',
        'regular_max_price',
        'product_id',
        'customer_group_id',
    ];

    /**
     * Get the product that owns the price index.
     *
     * @return \Illuminate\Database\Eloquent\Relations\BelongsTo
     */
    public function product()
    {
        return $this->belongsTo(Service::class);
    }

    /**
     * Get the customer group that owns the price index.
     */
    public function customer_group()
    {
        return $this->belongsTo(CustomerGroup::class);
    }
}
