<?php

namespace App\Criteria;

use Illuminate\Http\Request;
use Prettus\Repository\Contracts\CriteriaInterface;
use Prettus\Repository\Contracts\RepositoryInterface;

/**
 * Class AddressByCustomerCriteria.
 *
 * @package namespace App\Criteria;
 */
class AddressByCustomerCriteria implements CriteriaInterface
{
    /**
     * @var \Illuminate\Http\Request
     */
    protected $customer_id;

    public function __construct(int $customer_id)
    {
        $this->customer_id = $customer_id;
    }

    /**
     * Apply criteria in query repository
     *
     * @param string $model
     * @param RepositoryInterface $repository
     *
     * @return mixed
     */
    public function apply($model, RepositoryInterface $repository)
    {
        if (is_numeric($this->customer_id)) {
            $model = $model->where('addressable_id', $this->customer_id);
        }

        return $model;
    }
}
