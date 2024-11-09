<?php

namespace App\Repositories;

use Prettus\Repository\Eloquent\BaseRepository;
use Prettus\Repository\Criteria\RequestCriteria;
use App\Models\Service;
use Illuminate\Support\Facades\Auth;

/**
 * Class ServiceRepository.
 *
 * @package namespace App\Repositories;
 */
class ServiceRepository extends BaseRepository
{
    /**
     * Specify Model class name
     *
     * @return string
     */
    public function model()
    {
        return Service::class;
    }

    /**
     * Transform the Service model.
     *
     * @return App\Presenters\ServicePresenter
     */
    public function presenter()
    {
        return "App\\Presenters\\ServicePresenter";
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
    public function create(array $attributes)
    {
        $service = Auth::user()->services()->create($attributes);
        $this->upload($service);
        $this->syncAddress($service, $attributes);
        $this->syncParent($service, $attributes);
        $this->syncTag($service, $attributes);
        return $service;
    }

    /**
     *
     * @param array $service
     *
     * @return mixed
     *
     */
    private function upload($service)
    {
        $service->addMultipleMediaFromRequest(['service_attachment'])
            ->each(function ($attachment) {
                $attachment->toMediaCollection('service_attachment');
            });
    }

    /**
     * Sync tags in repository
     *
     * @param array $service
     * @param array $attributes
     *
     * @return mixed
     *
     */
    private function syncTag($service, $attributes)
    {
        $tags = explode(",", $attributes['tags']);
        if(!empty($attributes['tags']))
        {
            $service->syncTags($tags ?? []);
        }
    }

    /**
     * Sync addresses in repository
     *
     * @param array $service
     *
     * @return mixed
     *
     */
    private function syncAddress($service, $attributes)
    {
        $service->addresses()->sync($attributes['address_id'] ?? []);
    }

    /**
     * Sync service parents in repository
     *
     * @param array $service
     *
     * @return mixed
     *
     */
    private function syncParent($service, $attributes)
    {
        $service->parents()->sync($attributes['parent_id'] ?? []);
    }

    /**
     * Save a update entity in repository
     *
     * @param array $attributes
     * @param integer $id
     *
     * @return mixed
     *
     */
    public function update($request, $id)
    {
        $service = $this->model->findOrFail($id);
        $service->fill($request->all());
        $service->save();
        if ($request->hasFile('service_attachment')) {
            $service->addMultipleMediaFromRequest(['service_attachment'])
                ->each(function ($attachment) {
                    $attachment->toMediaCollection('service_attachment');
                });
        }

        $this->syncAddress($service, $request->all());
        $this->syncParent($service, $request->all());
        $this->syncTag($service, $request->all());
    }


    /**
     * delete in repository
     *
     * @param integer $id
     *
     * @return mixed
     *
     */
    public function delete($id)
    {
        $service = $this->model->find($id);

        $service->delete();
    }
}
