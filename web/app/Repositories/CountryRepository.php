<?php

namespace App\Repositories;

use Prettus\Repository\Eloquent\BaseRepository;
use Prettus\Repository\Criteria\RequestCriteria;
use App\Models\Country;

/**
 * Class CountryRepository.
 *
 * @package namespace App\Repositories;
 */
class CountryRepository extends BaseRepository
{
    /**
     * Specify Model class name 
     *
     * @return string
     */
    public function model()
    {
        return Country::class;
    }

    /**
     * Boot up the repository, pushing criteria
     */
    public function boot()
    {
        $this->pushCriteria(app(RequestCriteria::class));
    }
    
}
