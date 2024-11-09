<?php

namespace App\Presenters;

use App\Transformers\ServiceDetailTransformer;
use Prettus\Repository\Presenter\FractalPresenter;

/**
 * Class ServiceDetailPresenter.
 *
 * @package namespace App\Presenters;
 */
class ServiceDetailPresenter extends FractalPresenter
{
    /**
     * Transformer
     *
     * @return \League\Fractal\TransformerAbstract
     */
    public function getTransformer()
    {
        return new ServiceDetailTransformer();
    }
}
