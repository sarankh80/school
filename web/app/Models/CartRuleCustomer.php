<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class CartRuleCustomer extends Model
{
    public $timestamps = false;
    
    protected $fillable = [
        'times_used',
        'cart_rule_id',
        'customer_id',
    ];
}