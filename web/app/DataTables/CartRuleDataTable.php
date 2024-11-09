<?php

namespace App\DataTables;
use App\Traits\DataTableTrait;

use App\Models\CartRule;
use Yajra\DataTables\Html\Button;
use Yajra\DataTables\Html\Column;
use Yajra\DataTables\Html\Editor\Editor;
use Yajra\DataTables\Html\Editor\Fields;
use Yajra\DataTables\Services\DataTable;
use Livewire\Livewire;

class CartRuleDataTable extends DataTable
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
            ->editColumn('status' , function ($cartRule){
                return Livewire::mount('change-status', ['model' => $cartRule, 'field' => 'status', 'wire:key' => $cartRule->id])->html();
            })
            ->addColumn('action', function($cartRule){
                return view('promotions.cart-rules.action', compact('cartRule'))->render();
            })
            ->addIndexColumn()
            ->rawColumns(['action', 'status']);
    }

    /**
     * Get query source of dataTable. 
     *
     * @param \App\Models\CartRule $model
     * @return \Illuminate\Database\Eloquent\Builder
     */
    public function query(CartRule $model)
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
