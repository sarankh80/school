<?php

namespace App\DataTables;
use App\Traits\DataTableTrait;

use App\Models\ProviderAddress;
use Yajra\DataTables\Html\Button;
use Yajra\DataTables\Html\Column;
use Yajra\DataTables\Html\Editor\Editor;
use Yajra\DataTables\Html\Editor\Fields;
use Yajra\DataTables\Services\DataTable;
use Livewire\Livewire;

class ProviderAddressDataTable extends DataTable
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
            ->editColumn('status' , function ($address){
                return Livewire::mount('change-status', ['model' => $address, 'field' => 'status', 'wire:key' => $address->id])->html();
            })
            ->editColumn('addressable_id', function($address) {
                return ($address->addressable_id != null && isset($address->providers)) ? $address->providers->display_name : '-';
            })
            ->addColumn('action', function($address){
                return view('address.action',compact('address'))->render();
            })
            ->addIndexColumn()
            ->rawColumns(['action','status']);
    }

    /**
     * Get query source of dataTable.
     *
     * @param \App\Models\Address $model
     * @return \Illuminate\Database\Eloquent\Builder
     */
    public function query(ProviderAddress $model)
    {
        return $model->newQuery()->myAddress();
    }

    /**
     * Optional method if you want to use html builder.
     *
     * @return \Yajra\DataTables\Html\Builder
     */

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
            Column::make('addressable_id')
            ->title(__('messages.provider')),
            Column::make('address'),
            Column::make('status'),
            Column::computed('action')
                  ->exportable(false)
                  ->printable(false)
                  ->width(60)
                  ->addClass('text-center'),
        ];
    }
}
