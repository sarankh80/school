<?php

namespace App\DataTables;
use App\Traits\DataTableTrait;

use App\Models\Brand;
use Yajra\DataTables\Html\Button;
use Yajra\DataTables\Html\Column;
use Yajra\DataTables\Html\Editor\Editor;
use Yajra\DataTables\Html\Editor\Fields;
use Yajra\DataTables\Services\DataTable;

class BrandDataTable extends DataTable
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
            ->editColumn('name' , function ($brand){
                $name = $brand->name; 
                if($brand->deleted_at ==null){
                    $name = Brand::find($brand->id)->translate()->where('type','brand')->first()->name??$brand->name; 
                }
                return $name;
            })
            ->editColumn('status' , function ($brand){
                $disabled = $brand->deleted_at ? 'disabled': '';
                return '<div class="custom-control custom-switch custom-switch-text custom-switch-color custom-control-inline">
                    <div class="custom-switch-inner">
                        <input type="checkbox" class="custom-control-input bg-success change_status" '.$disabled.' data-type="service_status" '.($brand->status ? "checked" : "").' value="'.$brand->id.'" id="'.$brand->id.'" data-id="'.$brand->id.'" >
                        <label class="custom-control-label" for="'.$brand->id.'" data-on-label="" data-off-label=""></label>
                    </div>
                </div>';
            })
            ->addColumn('action', function($brand){
                return view('brand.action',compact('brand'))->render();
            })
            ->addIndexColumn()
            ->rawColumns(['action','status']);
    }

    /**
     * Get query source of dataTable.
     *
     * @param \App\Models\Brand $model
     * @return \Illuminate\Database\Eloquent\Builder
     */
    public function query(Brand $model)
    {
        if(auth()->user()->hasAnyRole(['admin'])){
            $model = $model->withTrashed();
        }
        return $model->newQuery();
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
            Column::make('name'),
            Column::make('status'),
            Column::computed('action')
                  ->exportable(false)
                  ->printable(false)
                  ->width(60)
                  ->addClass('text-center'),
        ];
    }
}
