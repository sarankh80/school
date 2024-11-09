<?php

namespace App\Repositories;

use App\Eloquent\Repository;
use App\Models\CartRuleCustomer;

class CartRuleCustomerRepository extends Repository
{
    /**
     * Specify Model class name
     *
     * @return string
     */
    function model(): string
    {
        return CartRuleCustomer::class;
    }
}