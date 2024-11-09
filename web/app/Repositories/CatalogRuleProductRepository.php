<?php

namespace App\Repositories;

use App\Eloquent\Repository;
use App\Models\CatalogRuleProduct;

class CatalogRuleProductRepository extends Repository
{
    /**
     * Specify Model class name
     *
     * @return string
     */
    function model(): string
    {
        return CatalogRuleProduct::class;
    }
}