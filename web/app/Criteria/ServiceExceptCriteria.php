<?php

namespace App\Criteria;

use Prettus\Repository\Contracts\CriteriaInterface;
use Prettus\Repository\Contracts\RepositoryInterface;

/**
 * Class ServiceExceptCriteria.
 *
 * @package namespace App\Criteria;
 */
class ServiceExceptCriteria implements CriteriaInterface
{
    /**
     * @var int $service_id
     */
    protected $service_id;

    public function __construct(int $service_id)
    {
        $this->service_id = $service_id;
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
        return $model->where('id', '!=' , $this->service_id);
    }
}
