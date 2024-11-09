<?php

namespace App\Repositories;

use Prettus\Repository\Eloquent\BaseRepository;
use Prettus\Repository\Criteria\RequestCriteria;
use App\Models\ProviderAddress;
use App\Models\Provider;

/**
 * Class ProviderAddressRepository.
 *
 * @package namespace App\Repositories;
 */
class ProviderAddressRepository extends BaseRepository
{
    /**
     * Specify Model class name
     *
     * @return string
     */
    public function model()
    {
        return ProviderAddress::class;
    }
        
    public function presenter()
    {
        return "App\\Presenters\\ProviderAddressPresenter";
    }

    /**
     * Boot up the repository, pushing criteria
     */
    public function boot()
    {
        $this->pushCriteria(app(RequestCriteria::class));
    } 

    /**
     * Save a new entity in repository
     *
     * @param array $attributes
     *
     * @return mixed
     *
     */
    public function create($attributes)
    {
        $address = $this->model->create($attributes);

        $this->syncService($address, $attributes);
    }

    /**
     * Sync services in repository
     *
     * @param Address $address
     * @param array $attributes
     *
     */
    private function syncService($address, $attributes)
    {
        $address->services()->syncWithPivotValues($attributes['service_id'] ?? [], ['provider_id' => $attributes['addressable_id']]);
    }

    /**
     * Update in repository
     *
     * @param array $attributes
     * @param int $id
     *
     * @return mixed
     *
     */
    public function update($attributes, $id)
    {
        $address = $this->model->findOrFail($id);
        $address->fill($attributes);
        $address->save();

        $this->syncService($address, $attributes);
    }
}
