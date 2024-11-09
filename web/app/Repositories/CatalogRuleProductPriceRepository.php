<?php

namespace App\Repositories;

use Illuminate\Support\Carbon;
use App\Eloquent\Repository;
use App\Models\CatalogRuleProductPrice;

class CatalogRuleProductPriceRepository extends Repository
{
    /**
     * Specify Model class name.
     *
     * @return string
     */
    function model(): string
    {
        return CatalogRuleProductPrice::class;
    }

    /**
     * Check if catalog rule prices already loaded. If already loaded then load from it.
     *
     * @return object
     */
    public function checkInLoadedCatalogRulePrice($product, $customerGroupId)
    {
        $identifier = $product->id . '_' . $customerGroupId;

        static $catalogRulePrices = [];

        if (array_key_exists($identifier, $catalogRulePrices)) {
            return $catalogRulePrices[$identifier];
        }

        return $catalogRulePrices[$identifier] = $this->findOneWhere([
            'product_id'        => $product->id,
            'channel_id'        => core()->getCurrentChannel()->id,
            'customer_group_id' => $customerGroupId,
            'rule_date'         => Carbon::now()->format('Y-m-d'),
        ]);
    }
}