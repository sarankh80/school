<?php

namespace App\Repositories;

use Prettus\Repository\Eloquent\BaseRepository;
use Prettus\Repository\Criteria\RequestCriteria;
use App\Models\Slider;
use App\Eloquent\Repository;

/**
 * Class SliderRepository.
 *
 * @package namespace App\Repositories;
 */
class SliderRepository extends Repository
{
    /**
     * Specify Model class name
     *
     * @return string
     */
    public function model()
    {
        return Slider::class;
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

        $slider = $this->model->create($attributes);

        if ($request->hasFile('slider_image')) {
            storeMediaFile($slider, $attributes['slider_image'], 'slider_image');
        }
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
        $attributes = $request->all();

        $slider = $this->model->findOrFail($id);
        $slider->fill($attributes);
        $slider->save();

        if ($request->hasFile('slider_image')) {
            storeMediaFile($slider, $attributes['slider_image'], 'slider_image');
        }
    }

}
