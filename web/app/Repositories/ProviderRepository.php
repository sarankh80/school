<?php

namespace App\Repositories;

use Prettus\Repository\Eloquent\BaseRepository;
use Prettus\Repository\Criteria\RequestCriteria;
use App\Models\Provider;

/**
 * Class ProviderRepository.
 *
 * @package namespace App\Repositories;
 */
class ProviderRepository extends BaseRepository
{
    /**
     * Specify Model class name 
     *
     * @return string
     */
    public function model()
    {
        return Provider::class;
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
    public function create($request)
    {
        $attributes = $request->all();
        $attributes['display_name'] = $attributes['first_name'] . ' ' . $attributes['last_name'];
        $attributes['user_type'] = "provider";

        $current_provider = $this->model->phoneNotVerified()->where('phone_number', $attributes['phone_number'])->first();

        if(!empty($current_provider))
        {
            $current_provider->fill($attributes);
            $current_provider->save();

            $provider = $this->model->find($current_provider->id);
            
        }else{
            $provider = $this->model->create($attributes);
            $provider->assignRole('provider');
        }

        $this->syncTax($provider, $attributes);

        if ($request->hasFile('profile_image')) {
            storeMediaFile($provider, $attributes['profile_image'], 'profile_image');
        }

        return $provider;
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
        $provider = $this->model->findOrFail($id);
        $provider->fill($attributes);
        $provider->save();

        $this->syncTax($provider, $attributes);

        if ($request->hasFile('profile_image')) {
            storeMediaFile($provider, $attributes['profile_image'], 'profile_image');
        }
    }

    /**
     * Sync taxes in repository
     *
     * @param Provider $provider
     * @param array $attributes
     *
     */
    private function syncTax($provider, $attributes)
    {
        $provider->taxes()->sync($attributes['tax_id'] ?? []);
    }
}
