<?php

namespace App\Transformers;

use App\Models\Category;
use League\Fractal\TransformerAbstract;
use League\Fractal\Manager;
use League\Fractal\Serializer\ArraySerializer;


class CategoryTransformer extends TransformerAbstract
{
    /**
     * List of resources to automatically include
     *
     * @var array
     */
    protected  array $defaultIncludes = ['brands', 'children'];

    /**
     * @param \App\Category $category
     * @return array
     */
    public function transform(Category $category): array
    {
        $translate = $category->translate;
        return [
            'id' => (int) $category->id,
            'name' => $translate->first()->name?? $category->name,
            'description' => $translate->first()->des?? $category->description,
            'image' => getSingleMedia($category, 'category_image',null),
            '_lft' => $category->_lft,
            '_rft' => $category->_rft,
            'parent_id' => $category->parent_id,
            'position' => $category->position,
            'color' => $category->color,
            'counts' => $category->where('parent_id',$category->id)->count(),
            'is_featured' => $category->is_featured,
            'deleted_at' => $category->deleted_at,
            'created_at' => $category->created_at,
            'updated_at' => $category->updated_at
        ];
    }

    /**
     * Include brands
     *
     * @param Category $category
     * @return \League\Fractal\Resource\collection
     */
    public function includeBrands(Category $category)
    {
        $brands = $category->brands;

        return $this->collection($brands, new BrandTransformer);
    }

    /**
     * Include brands
     *
     * @param Category $category
     * @return \League\Fractal\Resource\collection
     */
    public function includeChildren(Category $category)
    {
        $children = $category->children;

        return $this->collection($children, new CategoryTransformer);
    }
    public function includeTranslate(Category $category)
    {
        $translate = $category->translate;
        return $this->collection($translate, new TranslateTransformer);
    }
}