<?php

namespace App\Transformers;

use League\Fractal\TransformerAbstract;
use Spatie\Tags\Tag;

/**
 * Class TagTransformer.
 *
 * @package namespace App\Transformers;
 */
class TagTransformer extends TransformerAbstract
{
    /**
     * List of resources to automatically include
     *
     * @var array
     */
    protected  array $defaultIncludes = [];
    /**
     * Transform the Tag model.
     *
     * @param Spatie\Tags\Tag $tag
     *
     * @return array
     */
    public function transform(Tag $tag): array 
    {
        return [
            'id'              => (int) $tag->id, 
            'name'            => $tag->name,
        ];
    }
}
