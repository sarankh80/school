<?php

namespace App\Criteria;

use Illuminate\Http\Request;
use Prettus\Repository\Contracts\CriteriaInterface;
use Prettus\Repository\Contracts\RepositoryInterface;

/**
 * Class ServiceByLocationCriteria.
 *
 * @package namespace App\Criteria;
 */
class ServiceByLocationCriteria implements CriteriaInterface
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
        $latitude = $this->request->get('latitude', null);
        $longitude = $this->request->get('longitude', null);

        if(!empty($latitude) && !empty($longitude))
        {
            $model = $model->serviceByLocation($latitude, $longitude);
        }

        return $model;
    }
}
