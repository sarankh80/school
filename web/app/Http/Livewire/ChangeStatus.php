<?php

namespace App\Http\Livewire;

use Livewire\Component;
use Illuminate\Database\Eloquent\Model;

class ChangeStatus extends Component
{
    public Model $model;
    
    public string $field;

    public bool $status;

    public $disabled;

    public function mount()
    {
        $this->status = (bool) $this->model->getAttribute($this->field);
        $this->disabled = $this->model->deleted_at ? 'disabled' : '';
    }

    public function updating($field, $value)
    {
        $this->model->setAttribute($this->field, $value)->save();
    }

    public function render()
    {
        return view('livewire.change-status');
    }
}
