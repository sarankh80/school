<?php

namespace App\Repositories;

use App\Eloquent\Repository;
use App\Models\CartAddress;

class CartAddressRepository extends Repository
{
    /**
     * Specify Model class name
     *
     * @return string
     */
    function model(): string
    {
        return CartAddress::class;
    }
}