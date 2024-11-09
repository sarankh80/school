<?php

namespace App\Http\Livewire\Services;

use Livewire\Component;
use App\Models\Category;
use App\Models\User;
use App\Models\Service;
use App\Models\SubCategory;
use App\Models\Address;
use App\Models\Brand;
use App\Models\Unit;
use App\Repositories\CategoryRepository;

class ServiceForm extends Component
{
    public $brands = [];
    public $units = [];
    public $brand_id;
    public $unit_id;
    public $service;
    public $name;
    public $lang;
    public $status;
    public $type;
    public $sku;
    public $price;
    public $discount;
    public $description;
    public $included;
    public $excluded;
    public $duration;
    public $is_featured;
    public $visible;
    public $price_estimate;
    public $check_visible;

    protected $rules = [
        'name' => 'required',
        'price' => 'required',
        'status' => 'required',
        'type' => 'required'
    ];

    protected $listeners = [
        'selectedBrandItem',
        'selectedUnitItem',
    ];

    public function mount(Service $service)
    {
        $this->name = old('name') ?? $service->name;
        $this->lang = old('lang') ?? $service->name;
        $this->brand_id = old('brand_id') ?? $service->brand_id;
        $this->unit_id = old('brand_id') ?? $service->unit_id;
        $this->status = old('status') ?? $service->status;
        $this->type = old('type') ?? $service->type;
        $this->price = old('price') ?? $service->price;
        $this->description = old('description') ?? $service->description;
        $this->included = old('description') ?? $service->included;
        $this->excluded = old('description') ?? $service->excluded;
        $this->discount = old('discount') ?? $service->discount;
        $this->duration = old('duration') ?? $service->duration;
        $this->sku = old('sku') ?? $service->sku;
        $this->is_featured = old('is_featured') ?? $service->is_featured;
        $this->visible = old('visible') ?? $service->visible;
        $this->price_estimate = old('is_featured') ?? $service->price_estimate;
        $this->check_visible = $this->visible == 1 ? 'checked' : false;

        $this->service = $service;
    }

    public function hydrate()
    {
        $this->emit('select2');
    }
        
    public function render()
    {
        $this->brands = Brand::where('status', 1)->get();
        $this->units = Unit::all();

        return view('livewire.services.service-form');
    }

    public function selectedBrandItem($brand_id)
    {
        if ($brand_id) {
            $this->brand_id = $brand_id;
        }else{
            $this->brand_id = null;
        }
    }

    public function selectedUnitItem($unit_id)
    {
        if ($unit_id) {
            $this->unit_id = $unit_id;
        }else{
            $this->unit_id = null;
        }
    }
}