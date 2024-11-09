<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Http\Requests\BrandCreateRequest;
use App\DataTables\BrandDataTable;
use App\Repositories\BrandRepository;
use App\Models\Brand;

class BrandController extends Controller
{
    /**
     * @var BrandRepository
     */
    protected $brandRepo;

    public function __construct(BrandRepository $brandRepository){
        $this->brandRepo = $brandRepository;
    }

    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index(BrandDataTable $dataTable)
    {
        $assets = ['datatable'];
        return $dataTable->render('brand.index', compact('assets'));
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        return view('brand.create');
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(BrandCreateRequest $request)
    {
        $params = $request->all();               
        $brand = $this->brandRepo->create($params);
        tranSlateLaguage($brand->id,$request,'brand');
		return redirect(route('brands.index'))->withSuccess('Brand created successfully');
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function edit($id)
    {
        $brand = $this->brandRepo->skipPresenter()->find($id);
        $brand->km = Brand::find($brand->id)->translate()->first()?Brand::find($brand->id)->translate()->first()->getTranslation('name', 'km'):$brand->name;
        $brand->zh = Brand::find($brand->id)->translate()->first()?Brand::find($brand->id)->translate()->first()->getTranslation('name', 'zh'):$brand->name;
        return view('brand.edit', compact('brand'));
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, $id)
    {
        $this->brandRepo->update($request->all(), $id);
        tranSlateLaguage($id,$request,'brand');
        return redirect(route('brands.index'))->withSuccess('Brand updated successfully');
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy($id)
    {
        $this->brandRepo->delete($id);
        return redirect()->back()->withSuccess( __('messages.msg_deleted',['name' => __('messages.brand')] ));
    }

    public function action(Request $request){
        $id = $request->id;
        $brand = Brand::withTrashed()->where('id',$id)->first();
        $msg = __('messages.not_found_entry',['name' => __('messages.brand')] );
        if($request->type === 'restore'){
            $brand->restore();
            $msg = __('messages.msg_restored',['name' => __('messages.brand')] );
        }

        if($request->type === 'forcedelete'){
            $brand->forceDelete();
            $msg = __('messages.msg_forcedelete',['name' => __('messages.brand')] );
        }

        return comman_custom_response(['message'=> $msg , 'status' => true]);
    }
}
