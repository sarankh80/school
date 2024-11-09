<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Storage;

class ProductCustomerGroupPrice extends Model
{
    protected $fillable = [
        'qty',
        'value_type',
        'value',
        'product_id',
        'customer_group_id',
    ];

    /**
     * Get the product that owns the customer group price.
     */
    public function product()
    {
        return $this->belongsTo(Service::class);
    }

    /**
     * Get the product that owns the customer group price.
     */
    public function customer_group()
    {
        return $this->belongsTo(CustomerGroup::class);
    }
}