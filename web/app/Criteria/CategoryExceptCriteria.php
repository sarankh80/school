<?php

namespace App\Criteria;

use Prettus\Repository\Contracts\CriteriaInterface;
use Prettus\Repository\Contracts\RepositoryInterface;

/**
 * Class CategoryExceptCriteria.
 *
 * @package namespace App\Criteria;
 */
class CategoryExceptCriteria implements CriteriaInterface
{
    /**
     * @var int $category_id
     */
    protected $category_id;

    public function __construct(int $category_id)
    {
        $this->category_id = $category_id;
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
        return $model->where('id', '!=' , $this->category_id);
    }
}
