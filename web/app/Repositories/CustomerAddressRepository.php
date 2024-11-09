<?php

namespace App\Repositories;

use Prettus\Repository\Eloquent\BaseRepository;
use Prettus\Repository\Criteria\RequestCriteria;
use App\Models\CustomerAddress;
use App\Models\Provider;

/**
 * Class CustomerAddressRepository.
 *
 * @package namespace App\Repositories;
 */
class CustomerAddressRepository extends BaseRepository
{
    /**
     * Specify Model class name
     *
     * @return string
     */
    public function model()
    {
        return CustomerAddress::class;
    }

    public function presenter()
    {
        return "App\\Presenters\\CustomerAddressPresenter";
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
     * @param int $customer_id
     *
     * @return mixed
     *
     */
    public function create($request)
    {
        $attributes = $request->all();

        $address = $this->model->create($attributes);

        if ($request->hasFile('image')) {
            storeMediaFile($address, $attributes['image'], 'address_image');
        }

        return $address;
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
    public function update($request, $id)
    {
        $attributes = $request->all();

        $address = $this->model->findOrFail($id);
        $address->fill($attributes);
        $address->save();

        if ($request->hasFile('image')) {
            storeMediaFile($address, $attributes['image'], 'address_image');
        }
    }
}
