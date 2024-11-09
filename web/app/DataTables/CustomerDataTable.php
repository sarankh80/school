<?php

namespace App\DataTables;
use App\Traits\DataTableTrait;

use App\Models\Customer;
use Yajra\DataTables\Html\Button;
use Yajra\DataTables\Html\Column;
use Yajra\DataTables\Html\Editor\Editor;
use Yajra\DataTables\Html\Editor\Fields;
use Yajra\DataTables\Services\DataTable;

class CustomerDataTable extends DataTable
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
            ->editColumn('status', function($customer) {
                if($customer->status == '0'){
                    $status = '<span class="badge badge-danger">'.__('messages.inactive').'</span>';
                }else{
                    $status = '<span class="badge badge-success">'.__('messages.active').'</span>';
                }
                return $status;
            })
            ->editColumn('address', function($customer) {
                return ($customer->address != null && isset($customer->address)) ? $customer->address : '-';
            })
            ->addColumn('action', function($customer){
                return view('customer.action', compact('customer'))->render();
            })
            ->addIndexColumn()
            ->rawColumns(['action','status']);
    }

    /**
     * Get query source of dataTable.
     *
     * @param \App\Models\Customer $model
     * @return \Illuminate\Database\Eloquent\Builder
     */
    public function query(Customer $model)
    {
        if(auth()->user()->hasAnyRole(['admin'])){
            $model = $model->whereNotNull('phone_verified_at')->withTrashed();
        }
        $query = $model->newQuery();
        return $query;
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
                ->orderable(false)
                ->width(60),
            Column::make('display_name')
                ->title(__('messages.name')),
            Column::make('phone_number'),
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
