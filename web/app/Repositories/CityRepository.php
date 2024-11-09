<?php

namespace App\Repositories;

use Prettus\Repository\Eloquent\BaseRepository;
use Prettus\Repository\Criteria\RequestCriteria;
use App\Models\City;

/**
 * Class CityRepository.
 *
 * @package namespace App\Repositories;
 */
class CityRepository extends BaseRepository
{
    /**
     * Specify Model class name 
     *
     * @return string
     */
    public function model()
    {
        return City::class;
    }

    /**
     * Boot up the repository, pushing criteria
     */
    public function boot()
    {
        $this->pushCriteria(app(RequestCriteria::class));
    }
    
}
