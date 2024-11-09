<?php

namespace App\Criteria;

use Illuminate\Http\Request;
use Prettus\Repository\Contracts\CriteriaInterface;
use Prettus\Repository\Contracts\RepositoryInterface;

/**
 * Class ServiceTagCriteria.
 *
 * @package namespace App\Criteria;
 */
class ServiceTagCriteria implements CriteriaInterface
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
        $tags = explode(',', $this->request->get('tags'));
        
        if($this->request->get('tags') && count($tags) > 0)
        {
            return $model->withAnyTags($tags);
        }    

        return $model;
    }
}
