<?php

namespace App\DataTables;
use App\Traits\DataTableTrait;

use App\Models\CatalogRule;
use Yajra\DataTables\Html\Button;
use Yajra\DataTables\Html\Column;
use Yajra\DataTables\Html\Editor\Editor;
use Yajra\DataTables\Html\Editor\Fields;
use Yajra\DataTables\Services\DataTable;
use Livewire\Livewire;

class CatalogRuleDataTable extends DataTable
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
            ->editColumn('status' , function ($catalogRule){
                return Livewire::mount('change-status', ['model' => $catalogRule, 'field' => 'status', 'wire:key' => $catalogRule->id])->html();
            })
            ->addColumn('action', function($catalogRule){
                return view('promotions.catalog-rules.action', compact('catalogRule'))->render();
            })
            ->addIndexColumn()
            ->rawColumns(['action', 'status']);
    }

    /**
     * Get query source of dataTable. 
     *
     * @param \App\Models\CatalogRule $model
     * @return \Illuminate\Database\Eloquent\Builder
     */
    public function query(CatalogRule $model)
    {
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
            Column::make('starts_from')
                ->title(__('messages.start_at')),
            Column::make('ends_till')
                ->title(__('messages.end_at')),
            Column::make('sort_order')
                ->title(__('messages.priority')),
            Column::make('status'),
            Column::computed('action')
                  ->exportable(false)
                  ->printable(false)
                  ->width(60)
                  ->addClass('text-center'),
        ];
    }
}
