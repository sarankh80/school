<?php

namespace App\Http\Livewire;

use Livewire\Component;

class CouponType extends Component
{
    public $coupon_type = 0;
    public $use_auto_generation;
    public $coupon_code;


    protected $listeners = [
        'selectedCouponType',
    ];

    public function mount()
    {

    }

    public function render()
    {
        return view('livewire.coupon-type');
    }

    public function selectedCouponType($coupon_type)
    {
        if ($coupon_type) {
            $this->coupon_type = $coupon_type;
        }else{
            $this->coupon_type = 0;
        }
    }
}
