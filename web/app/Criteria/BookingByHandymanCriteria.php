<?php

namespace App\Criteria;

use Illuminate\Http\Request;
use Prettus\Repository\Contracts\CriteriaInterface;
use Prettus\Repository\Contracts\RepositoryInterface;
use Auth;

/**
 * Class BookingByHandymanCriteria.
 *
 * @package namespace App\Criteria;
 */
class BookingByHandymanCriteria implements CriteriaInterface
{
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
        $user = auth::guard('sanctum')->user();
        if($user->hasRole('handyman'))
        {
            $model = $model->whereHas('handymanAdded', function ($q) use($user){
                $q->where('handyman_id', $user->id);
            });
        }

        return $model;
    }
}
