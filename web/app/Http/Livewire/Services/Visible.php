<?php

namespace App\Http\Livewire\Services;

use Livewire\Component;
use Illuminate\Database\Eloquent\Model;

class Visible extends Component
{
    public Model $model;
    
    public string $field;

    public bool $visible;

    public $disabled;

    public function mount()
    {
        $this->visible = (bool) $this->model->getAttribute($this->field);
        $this->disabled = $this->model->deleted_at ? 'disabled' : '';
    }

    public function updating($field, $value)
    {
        $this->model->setAttribute($this->field, $value)->save();
    }

    public function render()
    {
        return view('livewire.services.visible');
    }
}
