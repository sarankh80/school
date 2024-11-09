<?php

namespace App\Helper\Indexers\Price;

use App\Repositories\CustomerRepository;
use App\Repositories\ProductCustomerGroupPriceRepository;
use App\Helper\CatalogRuleProductPrice;

abstract class AbstractIndexer
{
    /**
     * Product instance.
     *
     * @var \Webkul\Product\Contracts\Product
     */
    protected $product;

    /**
     * Customer Group instance.
     *
     * @var \App\Contracts\CustomerGroup
     */
    protected $customerGroup;

    /**
     * Create a new command instance.
     *
     * @param  App\Repositories\CustomerRepository  $customerRepository
     * @param  App\Repositories\ProductCustomerGroupPriceRepository  $productCustomerGroupPriceRepository
     * @param  App\Helpers\CatalogRuleProductPrice  $catalogRuleProductPriceHelper
     * @return void
     */
    public function __construct(
        protected CustomerRepository $customerRepository,
        protected ProductCustomerGroupPriceRepository $productCustomerGroupPriceRepository,
        protected CatalogRuleProductPrice $catalogRuleProductPriceHelper
    )
    {
        $this->customerGroup = $this->customerRepository->getCurrentGroup();
    }

    /**
     * Set current product
     *
     * @param  App\Contracts\Product  $product
     * @return App\Helpers\Indexers\Price\AbstractPriceIndex
     */
    public function setProduct($product)
    {
        $this->product = $product;

        return $this;
    }

    /**
     * Set customer group
     *
     * @param  App\Contracts\CustomerGroup  $customerGroup
     * @return App\Helpers\Indexers\Price\AbstractPriceIndex
     */
    public function setCustomerGroup($customerGroup)
    {
        $this->customerGroup = $customerGroup;

        return $this;
    }

    /**
     * Returns product specific pricing for customer group
     *
     * @param  App\Contracts\CustomerGroup  $customerGroup
     * @return array
     */
    public function getIndices($customerGroup)
    {
        $this->setCustomerGroup($customerGroup);

        return [
            'min_price'         => ($minPrice = $this->getMinimalPrice()) ?? 0,
            'regular_min_price' => $this->product->price ?? 0,
            'max_price'         => $minPrice ?? 0,
            'regular_max_price' => $this->product->price ?? 0,
        ];
    }

    /**
     * Get product minimal price.
     *
     * @param  integer  $qty
     * @return float
     */
    public function getMinimalPrice($qty = null)
    {
        $customerGroupPrice = $this->getCustomerGroupPrice($qty ?? 1);

        $rulePrice = $this->catalogRuleProductPriceHelper
            ->setCustomerGroup($this->customerGroup)
            ->getRulePrice($this->product);

        $discountedPrice = $this->product->special_price;

        if (
            empty($discountedPrice)
            && ! $rulePrice
            && $customerGroupPrice == $this->product->price
        ) {
            return $this->product->price;
        }

        $haveDiscount = false;

        if (! (float) $discountedPrice) {
            if (
                $rulePrice
                && $rulePrice->price < $this->product->price
            ) {
                $discountedPrice = $rulePrice->price;

                $haveDiscount = true;
            }
        } else {
            if (
                $rulePrice
                && $rulePrice->price <= $discountedPrice
            ) {
                $discountedPrice = $rulePrice->price;

                $haveDiscount = true;
            } else {
                if (core()->isChannelDateInInterval(
                    $this->product->special_price_from,
                    $this->product->special_price_to
                )) {
                    $haveDiscount = true;
                } elseif ($rulePrice) {
                    $discountedPrice = $rulePrice->price;

                    $haveDiscount = true;
                }
            }
        }

        if ($haveDiscount) {
            $discountedPrice = min($discountedPrice, $customerGroupPrice);
        } else {
            if ($customerGroupPrice !== $this->product->price) {
                $discountedPrice = $customerGroupPrice;
            }
        }


        return $discountedPrice;
    }

    /**
     * Get product group price.
     *
     * @param  integer  $qty
     * @return float
     */
    public function getCustomerGroupPrice($qty)
    {
        if(empty($this->customerGroup))
        {
            return $this->product->price;
        }
        
        $customerGroupPrices = $this->productCustomerGroupPriceRepository
            ->checkInLoadedCustomerGroupPrice($this->product, optional($this->customerGroup)->id);
        if ($customerGroupPrices->isEmpty()) {
            return $this->product->price;
        }

        $lastQty = 1;

        $lastPrice = $this->product->price;

        $lastCustomerGroupId = null;

        foreach ($customerGroupPrices as $customerGroupPrice) {
            if (
                $customerGroupPrice->qty > $qty
                || $customerGroupPrice->qty < $lastQty
            ) {
                continue;
            }

            if ($customerGroupPrice->value_type == 'discount') {
                if (
                    $customerGroupPrice->value >= 0
                    && $customerGroupPrice->value <= 100
                ) {
                    $lastPrice = $this->product->price - ($this->product->price * $customerGroupPrice->value) / 100;

                    $lastQty = $customerGroupPrice->qty;

                    $lastCustomerGroupId = $customerGroupPrice->customer_group_id;
                }
            } else {
                if (
                    $customerGroupPrice->value >= 0
                    && $customerGroupPrice->value < $lastPrice
                ) {
                    $lastPrice = $customerGroupPrice->value;

                    $lastQty = $customerGroupPrice->qty;

                    $lastCustomerGroupId = $customerGroupPrice->customer_group_id;
                }
            }
        }

        return $lastPrice;
    }
}