<?php

namespace App\Criteria;

use Illuminate\Http\Request;
use Prettus\Repository\Contracts\CriteriaInterface;
use Prettus\Repository\Contracts\RepositoryInterface;

/**
 * Class InvoiceByProviderCriteria.
 *
 * @package namespace App\Criteria;
 */
class InvoiceByProviderCriteria implements CriteriaInterface
{
    /**
     * @var \Illuminate\Http\Request
     */
    protected $provider_id;

    public function __construct(Request $request)
    {
        $this->provider_id  = $request->get('provider_id', null);
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
        if (is_numeric($this->provider_id)) 
        {            
            $model = $model->where('provider_id', $this->provider_id);
        }

        return $model;
    }
}
