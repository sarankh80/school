<?php

namespace App\Repositories;

use App\Eloquent\Repository;
use App\Models\CustomerGroup;

class CustomerGroupRepository extends Repository
{
    /**
     * Specify model class name.
     *
     * @return string
     */
    public function model(): string
    {
        return CustomerGroup::class;
    }

    /**
     * Returns guest group.
     *
     * @return object
     */
    public function getCustomerGuestGroup()
    {
        static $customerGuestGroup;

        if ($customerGuestGroup) {
            return $customerGuestGroup;
        }

        return $customerGuestGroup = $this->findOneByField('code', 'guest');
    }
}
