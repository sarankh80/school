<?php

namespace App\Repositories;

use App\Eloquent\Repository;
use App\Models\CartRuleCouponUsage;

class CartRuleCouponUsageRepository extends Repository
{
    /**
     * Specify Model class name
     *
     * @return string
     */
    function model(): string
    {
        return CartRuleCouponUsage::class;
    }
}