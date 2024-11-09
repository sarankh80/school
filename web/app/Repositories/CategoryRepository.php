<?php

namespace App\Repositories;

use Prettus\Repository\Eloquent\BaseRepository;
use Prettus\Repository\Criteria\RequestCriteria;
use App\Models\Category;
use App\Models\TranslateLanguage;

/**
 * Class CategoryRepository.
 *
 * @package namespace App\Repositories;
 */
class CategoryRepository extends BaseRepository
{
    /**
     * Specify Model class name
     *
     * @return string
     */
    public function model()
    {
        return Category::class;
    }

    /**
     * Transform the Category model.
     *
     * @return App\Presenters\CategoryPresenter
     */
    public function presenter()
    {
        return "App\\Presenters\\CategoryPresenter";
    }

    /**
     * Boot up the repository, pushing criteria
     */
    public function boot()
    {
        $this->pushCriteria(app(RequestCriteria::class));
    }

    /**
     * Retrieve all data of repository
     *
     * @param array $columns
     *
     * @return mixed
     */
    public function all($columns = ['*'])
    {
        $this->applyCriteria();
        $this->applyScope();

        if ($this->model instanceof Builder) {
            $results = $this->model->get($columns)->toTree();
        } else {
            $results = $this->model->get($columns)->toTree();
        }

        $this->resetModel();
        $this->resetScope();

        return $this->parserResult($results);
    }

    /**
     * Alias of All method
     *
     * @param array $columns
     *
     * @return mixed
     */
    public function get($columns = ['*'])
    {
        return $this->all($columns);
    }

    /**
     * Find data by id
     *
     * @param  $id
     * @param array $columns
     *
     * @return mixed
     */
    public function find($id, $columns = ['*'])
    {
        $this->applyCriteria();
        $this->applyScope();
        $model = $this->model->findOrFail($id, $columns);
        $this->resetModel();

        return $this->parserResult($model->descendants);
    }
    /**
     * Specify category tree.
     *
     * @param  int  $id
     * @return \Webkul\Category\Contracts\Category
     */
    public function getCategoryTree($id = null)
    {   
        return $id
            ? $this->model::orderBy('position', 'ASC')->where('id', '!=', $id)->get()->toTree()
            : $this->model::orderBy('position', 'ASC')->get()->toTree();
    }

    /**
     * Specify category tree.
     *
     * @param  int  $id
     * @return \Illuminate\Support\Collection
     */
    public function getCategoryTreeWithoutDescendant($id = null)
    {
        return $id
            ? $this->model::orderBy('position', 'ASC')->where('id', '!=', $id)->whereNotDescendantOf($id)->get()->toTree()
            : $this->model::orderBy('position', 'ASC')->get()->toTree();
    }

    /**
     * Get root categories.
     *
     * @return \Illuminate\Support\Collection
     */
    public function getRootCategories()
    {
        return $this->getModel()->where('parent_id', null)->get();
    }
    public function getChildrendCategories($id)
    {
        return $this->getModel()->where('parent_id', $id)->get();
    }

    public function getChildrend($id)
    {
        $categories =  $this->getModel()->where('parent_id', $id)->orderBy('position', 'ASC')->get();
        return $this->parserResult($categories);
    }

    /**
     * get visible category tree.
     *
     * @param  int  $id
     * @return \Illuminate\Support\Collection
     */
    public function getVisibleCategoryTree($id = null)
    {
        static $categories = [];

        if (array_key_exists($id, $categories)) {
            return $categories[$id];
        }

        $categories[$id] = $id
            ? $this->model::orderBy('position', 'ASC')->where('status', 1)->descendantsAndSelf($id)->toTree($id)
            : $this->model::orderBy('position', 'ASC')->where('status', 1)->get()->toTree();
        return $this->parserResult($categories[$id]);
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
        $category = $this->model->create($attributes);
        $this->syncTranslate($category,$request);
        if ($request->hasFile('category_image')) {
            storeMediaFile($category, $attributes['category_image'], 'category_image');
        }

        $this->syncRelations($category, $attributes);
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
        $category = $this->model->findOrFail($id);
        $category->fill($attributes);
        $category->save();
        $this->syncTranslate($category,$request);
        if ($request->hasFile('category_image')) {
            storeMediaFile($category, $attributes['category_image'], 'category_image');
        }
        $this->syncRelations($category, $attributes);
    }
    private function syncTranslate($category,$request)
    {
        $tran = TranslateLanguage::where('type','category')->where('re_id',$category->id)->first() ? TranslateLanguage::where('type','category')->where('re_id',$category->id)->first() : new TranslateLanguage();
        $tran->re_id = $category->id; // This is an Eloquent model
        $tran->type = 'category'; // This is an Eloquent model
        $tran->setTranslation('name', 'en', $request->name);
        $tran->setTranslation('name', 'km', $request->km);
        $tran->setTranslation('name', 'zh', $request->zh);
        $tran->status = 1;
        $tran->save();
    }
    /**
     * Sync category relations in repository
     *
     * @param array $category
     *
     * @return mixed
     *
     */
    private function syncRelations($category, $attributes)
    {
        $category->related()->sync($attributes['relation_id'] ?? []);
    }
}
