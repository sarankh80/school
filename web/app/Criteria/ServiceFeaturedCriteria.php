<?php

namespace App\Criteria;

use Illuminate\Http\Request;
use Prettus\Repository\Contracts\CriteriaInterface;
use Prettus\Repository\Contracts\RepositoryInterface;

/**
 * Class ServiceFeaturedCriteria.
 *
 * @package namespace App\Criteria;
 */
class ServiceFeaturedCriteria implements CriteriaInterface
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
        $is_featured = $this->request->get('featured', null);

        if(is_numeric($is_featured))
        {
            $model = $model->where('is_featured', $is_featured);
        }

        return $model;
    }
}
