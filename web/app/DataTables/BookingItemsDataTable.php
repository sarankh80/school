<?php

namespace App\DataTables;
use App\Traits\DataTableTrait;

use App\Models\BookingItem;
use Yajra\DataTables\Html\Button;
use Yajra\DataTables\Html\Column;
use Yajra\DataTables\Html\Editor\Editor;
use Yajra\DataTables\Html\Editor\Fields;
use Yajra\DataTables\Services\DataTable;

class BookingItemsDataTable extends DataTable
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
            ->editColumn('price' , function ($item){
                return $item->price ? getPriceFormat($item->price) : '-';
            })
            ->editColumn('total' , function ($item){
                return $item->total ? getPriceFormat($item->total) : '-';
            })
            ->addColumn('action', function($item){
                return view('bookingitem.action', compact('item'))->render();
            })
            ->addIndexColumn()
            ->rawColumns(['action']);
    }

    /**
     * Get query source of dataTable.
     *
     * @param \App\Models\BookingItem $model
     * @return \Illuminate\Database\Eloquent\Builder
     */
    public function query(BookingItem $model)
    {
        return $model->newQuery()->where('booking_id', $this->booking_id);
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
                ->width(30),
            Column::make('name')
                ->title(__('messages.name'))
                ->orderable(false),
            Column::make('price')
                ->searchable(false)
                ->title(__('messages.price'))
                ->orderable(false),
            Column::make('quantity')
                ->title(__('messages.quantity'))
                ->orderable(false),
            Column::make('total')
                ->title(__('messages.sub_total'))
                ->orderable(false),
            Column::computed('action')
                ->exportable(false)
                ->printable(false)
                ->width(30)
                ->addClass('text-center'),
        ];
    }
}
