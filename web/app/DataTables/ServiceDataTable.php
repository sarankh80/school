<?php

namespace App\DataTables;
use App\Traits\DataTableTrait;

use App\Models\Service;
use Yajra\DataTables\Html\Button;
use Yajra\DataTables\Html\Column;
use Yajra\DataTables\Html\Editor\Editor;
use Yajra\DataTables\Html\Editor\Fields;
use Yajra\DataTables\Services\DataTable;
use Livewire\Livewire;

class ServiceDataTable extends DataTable
{
    use DataTableTrait;
    /**
     * Build DataTable class.
     *
     * @param mixed $query Results from query() method.
     * @return \Yajra\DataTables\DataTableAbstract
     */
    public function dataTable($query)
    {
        return datatables()
            ->eloquent($query)
            ->editColumn('name' , function ($service){
                $name = $service->name; 
                if($service->deleted_at ==null){
                    $name = Service::find($service->id)->translate()->where('type','service')->first()->name??$service->name; 
                }
                return $name;
            })
            ->editColumn('category_id' , function ($service){
                return ($service->category_id != null && isset($service->category)) ? $service->category->name : '-';
            })
            ->filterColumn('category_id',function($query,$keyword){
                $query->whereHas('category',function ($q) use($keyword){
                    $q->where('name','like','%'.$keyword.'%');
                });
            })
            ->editColumn('price' , function ($service){
                return getPriceFormat($service->price);
            })
            
            ->editColumn('discount' , function ($service){
                return $service->discount ? $service->discount .'%' : '-';
            })
            ->editColumn('visible' , function ($service){
                return Livewire::mount('services.visible', ['model' => $service, 'field' => 'visible', 'wire:key' => $service->id])->html();
            })
            ->editColumn('status' , function ($service){
                return Livewire::mount('change-status', ['model' => $service, 'field' => 'status', 'wire:key' => $service->id])->html();
            })
            ->addColumn('action', function($service){
                return view('service.action',compact('service'))->render();
            })
            ->addIndexColumn()
            ->rawColumns(['action', 'visible', 'status', 'is_featured']);
    }

    /**
     * Get query source of dataTable. 
     *
     * @param \App\Models\Service $model
     * @return \Illuminate\Database\Eloquent\Builder
     */
    public function query(Service $model)
    {
        if(auth()->user()->hasAnyRole(['admin'])){
            $model = $model->withTrashed();
            if($this->provider_id !== null){
                $model =  $model->providerService($this->provider_id);
            }
        }
        return $model->newQuery()->myService();
    }
    /**
     * Get columns.
     *
     * @return array
     */
    protected function getColumns()
    {
        return [
            Column::make('DT_RowIndex')
                ->searchable(false)
                ->title(__('messages.srno'))
                ->orderable(false),
            Column::make('sku'),
            Column::make('name'),
            Column::make('category_id')
                ->title(__('messages.category')),
            Column::make('price'),
            Column::make('discount'),
            Column::make('visible'),
            Column::make('status'),
            Column::computed('action')
                  ->exportable(false)
                  ->printable(false)
                  ->width(60)
                  ->addClass('text-center'),
        ];
    }
}
