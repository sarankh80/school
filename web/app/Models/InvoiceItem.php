<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class InvoiceItem extends Model
{
    use HasFactory;

    protected $fillable = [
        'invoice_id',
        'service_id',
        'name',
        'description',
        'sku',
        'qty',
        'base_price',
        'price',
        'base_total',
        'total',
        'discount_percent',
        'discount_amount',
        'parent_id',
        'additional'
    ];
}
