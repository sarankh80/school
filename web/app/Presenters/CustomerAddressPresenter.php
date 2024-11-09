<?php

namespace App\Presenters;

use App\Transformers\CustomerAddressTransformer;
use Prettus\Repository\Presenter\FractalPresenter;

/**
 * Class CustomerAddressPresenter.
 *
 * @package namespace App\Presenters;
 */
class CustomerAddressPresenter extends FractalPresenter
{
    /**
     * Transformer
     *
     * @return \League\Fractal\TransformerAbstract
     */
    public function getTransformer()
    {
        return new CustomerAddressTransformer();
    }
}
