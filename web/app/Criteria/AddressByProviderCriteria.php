<?php

namespace App\Criteria;

use Illuminate\Http\Request;
use Prettus\Repository\Contracts\CriteriaInterface;
use Prettus\Repository\Contracts\RepositoryInterface;

/**
 * Class AddressByProviderCriteria.
 *
 * @package namespace App\Criteria;
 */
class AddressByProviderCriteria implements CriteriaInterface
{
    /**
     * @var \Illuminate\Http\Request
     */
    protected $provider_id;

    public function __construct(int $provider_id)
    {
        $this->provider_id = $provider_id;
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
        if (is_numeric($this->provider_id)) {
            $model = $model->where('addressable_id', $this->provider_id);
        }

        return $model;
    }
}
