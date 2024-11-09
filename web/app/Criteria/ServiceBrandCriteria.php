<?php

namespace App\Criteria;

use Illuminate\Http\Request;
use Prettus\Repository\Contracts\CriteriaInterface;
use Prettus\Repository\Contracts\RepositoryInterface;

/**
 * Class ServiceBrandCriteria.
 *
 * @package namespace App\Criteria;
 */
class ServiceBrandCriteria implements CriteriaInterface
{
    /**
     * @var \Illuminate\Http\Request
     */
    protected $request;

    public function __construct(Request $request)
    {
        $this->request = $request;
    }

    /**
     * Apply criteria in query repository
     *
     * @param string              $model
     * @param RepositoryInterface $repository
     *
     * @return mixed
     */
    public function apply($model, RepositoryInterface $repository)
    {
        $brand_id = $this->request->get('brand_id', null);

        if(is_numeric($brand_id))
        {
            return $model->where('brand_id', $brand_id);
        }    

        return $model;
    }
}
