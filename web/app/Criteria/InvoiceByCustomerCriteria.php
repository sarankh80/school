<?php

namespace App\Criteria;

use Illuminate\Http\Request;
use Prettus\Repository\Contracts\CriteriaInterface;
use Prettus\Repository\Contracts\RepositoryInterface;

/**
 * Class InvoiceByCustomerCriteria.
 *
 * @package namespace App\Criteria;
 */
class InvoiceByCustomerCriteria implements CriteriaInterface
{
    /**
     * @var \Illuminate\Http\Request
     */
    protected $customer_id;

    public function __construct(Request $request)
    {
        $this->customer_id  = $request->get('customer_id', null);
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
        if (is_numeric($this->customer_id)) 
        {
            $model = $model->where('customer_id', $this->customer_id);
        }

        return $model;
    }
}
