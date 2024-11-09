<?php

namespace App\Presenters;

use App\Transformers\ServiceTransformer;
use Prettus\Repository\Presenter\FractalPresenter;

/**
 * Class ServicePresenter.
 *
 * @package namespace App\Presenters;
 */
class ServicePresenter extends FractalPresenter
{
    /**
     * Transformer
     *
     * @return \League\Fractal\TransformerAbstract
     */
    public function getTransformer()
    {
        return new ServiceTransformer();
    }
}
