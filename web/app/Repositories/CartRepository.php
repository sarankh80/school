<?php

namespace App\Repositories;

use App\Eloquent\Repository;
use App\Models\Cart;

class CartRepository extends Repository
{
    /**
     * Specify Model class name
     *
     * @return string
     */
    function model(): string
    {
        return Cart::class;
    }

    /**
     * Method to detach associations. Use this only with guest cart only.
     * 
     * @param  int  $cartId
     * @return bool
     */
    public function deleteParent($cartId)
    {
        return $this->model->destroy($cartId);
    }
}