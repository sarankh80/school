<?php

namespace App\Criteria;

use Illuminate\Http\Request;
use Prettus\Repository\Contracts\CriteriaInterface;
use Prettus\Repository\Contracts\RepositoryInterface;

/**
 * Class ServiceByProviderCriteria.
 *
 * @package namespace App\Criteria;
 */
class ServiceByProviderCriteria implements CriteriaInterface
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
        $provider_id = $this->request->get('provider_id', null);

        if(!empty($provider_id))
        {
            $model = $model->providerService($provider_id);
        }

        return $model;
    }
}
