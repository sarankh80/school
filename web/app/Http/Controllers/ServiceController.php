<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Service;
use App\DataTables\ServiceDataTable;
use App\Repositories\ServiceRepository;
use App\Repositories\CategoryRepository;
use App\Repositories\TagRepository;
use App\Http\Requests\ServiceCreateRequest;
use App\Http\Requests\ServiceUpdateRequest;
use App\Criteria\ServiceExceptCriteria;

class ServiceController extends Controller
{
    /**
     * @var ServiceRepository
     */
    protected $serviceRepo;

    /**
     * @var CategoryRepository
     */
    protected $categoryRepo;

    /**
     * @var TagRepository
     */
    protected $tagRepo;

    public function __construct(ServiceRepository $serviceRepository, TagRepository $tagRepository, CategoryRepository $categoryRepository){
        $this->serviceRepo = $serviceRepository;
        $this->categoryRepo = $categoryRepository;
        $this->tagRepo = $tagRepository;
    }
 
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index(ServiceDataTable $dataTable)
    {
        return $dataTable->render('service.index', ['assets' => $dataTable]);
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        $categories = $this->categoryRepo->skipPresenter()->get();
        $services = $this->serviceRepo->skipPresenter()->get()->pluck('name', 'id');
        $tags = $this->tagRepo->get()->pluck('name');
        return view('service.create', compact('categories', 'services', 'tags'));
    } 

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(ServiceCreateRequest $request)
    {
        $services = $request->all();
               
        $service = $this->serviceRepo->create($services);
        tranSlateLaguage($service->id,$request,'service');
		return redirect(route('services.index'))->withSuccess('Service created successfully');
    }

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show($id)
    {
        //
    }
 
    /**
     * Show the form for editing the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function edit($id)
    {
        $service = $this->serviceRepo->skipPresenter()->find($id);
        
        $categories = $this->categoryRepo->skipPresenter()->get();

        $this->serviceRepo->pushCriteria(new ServiceExceptCriteria($service->id));
        $services = $this->serviceRepo->skipPresenter()->get()->pluck('name', 'id');
        $service->km = Service::find($service->id)->translate()->first()?Service::find($service->id)->translate()->first()->getTranslation('name', 'km'):$service->name;
        $service->zh = Service::find($service->id)->translate()->first()?Service::find($service->id)->translate()->first()->getTranslation('name', 'zh'):$service->name;
        $service->description_km = Service::find($service->id)->translate()->first()?Service::find($service->id)->translate()->first()->getTranslation('des', 'km'):$service->description;
        $service->description_zh = Service::find($service->id)->translate()->first()?Service::find($service->id)->translate()->first()->getTranslation('des', 'zh'):$service->description;
        $service->included_km = Service::find($service->id)->translate()->first()?Service::find($service->id)->translate()->first()->getTranslation('included', 'km'):$service->included;
        $service->included_zh = Service::find($service->id)->translate()->first()?Service::find($service->id)->translate()->first()->getTranslation('included', 'zh'):$service->included;
        $service->excluded_km = Service::find($service->id)->translate()->first()?Service::find($service->id)->translate()->first()->getTranslation('excluded', 'km'):$service->excluded;
        $service->excluded_zh = Service::find($service->id)->translate()->first()?Service::find($service->id)->translate()->first()->getTranslation('excluded', 'zh'):$service->excluded;
        return view('service.edit', compact('service', 'categories', 'services'));
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(ServiceUpdateRequest $request, $id)
    {
        $this->serviceRepo->update($request, $id);
        tranSlateLaguage($id,$request,'service');
		return redirect(route('services.index'))->withSuccess('Service updated successfully');
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy($id)
    {
        $this->serviceRepo->delete($id);
        
        return redirect()->back()->withSuccess( __('messages.msg_deleted',['name' => __('messages.service')] ));
    }

    public function action(Request $request){
        $id = $request->id;
        $service = Service::withTrashed()->where('id',$id)->first();
        $msg = __('messages.not_found_entry',['name' => __('messages.service')] );
        if($request->type === 'restore'){
            $service->restore();
            $msg = __('messages.msg_restored',['name' => __('messages.service')] );
        }

        if($request->type === 'forcedelete'){
            $service->forceDelete();
            $msg = __('messages.msg_forcedelete',['name' => __('messages.service')] );
        }

        return comman_custom_response(['message'=> $msg , 'status' => true]);
    }

    /**
     * Display a listing of the tag resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function tags()
    {
        $tags = $this->tagRepo->get()->pluck('name');
        
        return response()->json($tags, '200');
    }
}