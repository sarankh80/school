<?php

namespace App\Http\Livewire\Services;

use App\Models\Service;
use Livewire\Component;

class Media extends Component
{
    public $service = [];

    public function mount(Service $service)
    {
        $this->service = $service ?? new Service();
    }


    public function render()
    {
        return view('livewire.services.media');
    }
}
