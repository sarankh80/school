<?php

namespace App\Criteria;

use Illuminate\Http\Request;
use Prettus\Repository\Contracts\CriteriaInterface;
use Prettus\Repository\Contracts\RepositoryInterface;

/**
 * Class BookingByStatusCriteria.
 *
 * @package namespace App\Criteria;
 */
class BookingByStatusCriteria implements CriteriaInterface
{
    /**
     * @var \Illuminate\Http\Request
     */
    protected $status;

    public function __construct(Request $request)
    {
        $this->status  = $request->get('status', null);
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
        if ($this->status != null) {
            $model = $model->where('status', $this->status);
        }

        return $model;
    }
}
