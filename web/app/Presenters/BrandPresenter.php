<?php

namespace App\Presenters;

use App\Transformers\BrandTransformer;
use Prettus\Repository\Presenter\FractalPresenter;

/**
 * Class BrandPresenter.
 *
 * @package namespace App\Presenters;
 */
class BrandPresenter extends FractalPresenter
{
    /**
     * Transformer
     *
     * @return \League\Fractal\TransformerAbstract
     */
    public function getTransformer()
    {
        return new BrandTransformer();
    }
}
