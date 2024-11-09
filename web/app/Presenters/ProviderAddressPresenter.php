<?php

namespace App\Presenters;

use App\Transformers\ProviderAddressTransformer;
use Prettus\Repository\Presenter\FractalPresenter;

/**
 * Class ProviderAddressPresenter.
 *
 * @package namespace App\Presenters;
 */
class ProviderAddressPresenter extends FractalPresenter
{
    /**
     * Transformer
     *
     * @return \League\Fractal\TransformerAbstract
     */
    public function getTransformer()
    {
        return new ProviderAddressTransformer();
    }
}
