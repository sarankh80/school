<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Repositories\UnitRepository;
use App\DataTables\UnitDataTable;
use App\Http\Requests\UnitRequest;
use App\Models\Unit;

class UnitController extends Controller
{
    /**
     * @var UnitRepository
     */
    protected $unitRepo;

    public function __construct(UnitRepository $unitRepository)
    {
        $this->unitRepo = $unitRepository;
    }
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index(UnitDataTable $dataTable)
    {
        return $dataTable->render('unit.index', ['assets' => $dataTable]);
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        return view('unit.create');
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  App\Http\Requests\UnitRequest  $request
     * @return \Illuminate\Http\Response
     */
    public function store(UnitRequest $request)
    {
        $this->unitRepo->create($request->all());

        return redirect(route('units.index'))->withSuccess('Unit created successfully');
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function edit($id)
    {
        $unit = $this->unitRepo->find($id);
        
        return view('unit.edit', compact('unit'));

    }

    /**
     * Update the specified resource in storage.
     *
     * @param  App\Http\Requests\UnitRequest  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(UnitRequest $request, $id)
    {
        $this->unitRepo->update($request->all(), $id);

        return redirect(route('units.index'))->withSuccess(trans('messages.update_form_title', ['form' => trans('messages.unit')]));
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy($id)
    {
        $unit = Unit::find($id);
        $msg = __('messages.msg_fail_to_delete', ['name' => __('messages.unit')]);

        if ($unit != '') {
            $unit->delete();
            $msg = __('messages.msg_deleted', ['name' => __('messages.unit')]);
        }

        return redirect()->back()->withSuccess($msg);
    }
        
    public function action(Request $request)
    {
        $id = $request->id;

        $unit  = Unit::withTrashed()->where('id', $id)->first();
        $msg = __('messages.not_found_entry', ['name' => __('messages.unit')]);
        if ($request->type == 'restore') {
            $unit->restore();
            $msg = __('messages.msg_restored', ['name' => __('messages.unit')]);
        }
        if ($request->type === 'forcedelete') {
            $unit->forceDelete();
            $msg = __('messages.msg_forcedelete', ['name' => __('messages.unit')]);
        }
        return comman_custom_response(['message' => $msg, 'status' => true]);
    }
}
