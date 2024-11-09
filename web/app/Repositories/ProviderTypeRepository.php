<?php

namespace App\Repositories;

use Prettus\Repository\Eloquent\BaseRepository;
use Prettus\Repository\Criteria\RequestCriteria;
use App\Models\ProviderType;

/**
 * Class ProviderTypeRepository.
 *
 * @package namespace App\Repositories;
 */
class ProviderTypeRepository extends BaseRepository
{
    /**
     * Specify Model class name 
     *
     * @return string
     */
    public function model()
    {
        return ProviderType::class;
    }

    /**
     * Boot up the repository, pushing criteria
     */
    public function boot()
    {
        $this->pushCriteria(app(RequestCriteria::class));
    }
    
}
