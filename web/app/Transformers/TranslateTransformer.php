<?php

namespace App\Transformers;

use App\Models\TranslateLanguage;
use League\Fractal\TransformerAbstract;

class TranslateTransformer extends TransformerAbstract
{
    /**
     * @param \App\Brand $brand
     * @return array
     */
    public function transform(TranslateLanguage $translate)
    {
        return [
            'id' => (int) $translate->id,
            're_id'=> (int) $translate->id,
            'type' => $translate->name,            
            'name' => $translate->name,            
            'included' => $translate->included,
            'excluded' => $translate->excluded,
            'lang' => $translate->excluded,
            'lang_one' => $translate->excluded,
            'lang_two' => $translate->excluded,
            'lang_three' => $translate->excluded,
        ];
    }
}