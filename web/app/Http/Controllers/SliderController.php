<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Slider;
use App\Models\Service;
use App\DataTables\SliderDataTable;
use App\Http\Requests\SliderRequest;
use App\Repositories\SliderRepository;
use App\Repositories\ServiceRepository;

class SliderController extends Controller
{
        /**
     * @var SliderRepository
     */
    protected $sliderRepo;

    public function __construct(ServiceRepository $serviceRepository, SliderRepository $sliderRepository)
    {
        $this->serviceRepo = $serviceRepository;
        $this->sliderRepo = $sliderRepository;
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
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index(SliderDataTable $dataTable)
    {
        return $dataTable->render('slider.index', ['assets' => $dataTable]);
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {   
        $services = $this->serviceRepo->skipPresenter()->get()->pluck('name', 'id');
        return view('slider.create', compact('services'));
    }
    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {               
        $this->sliderRepo->create($request);

		return redirect(route('sliders.index'))->withSuccess( __('messages.save_form', [ 'form' => __('messages.slider') ] ));
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function edit($id)
    {
        $services = $this->serviceRepo->skipPresenter()->get()->pluck('name', 'id');
        $slider = $this->sliderRepo->skipPresenter()->find($id);

        return view('slider.edit', compact('services', 'slider'));
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
        $this->sliderRepo->update($request, $id);

        return redirect(route('sliders.index'))->withSuccess(trans('messages.update_form_title', ['form' => trans('messages.slider')]));
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy($id)
    {
        $this->sliderRepo->delete($id);

        return redirect(route('sliders.index'))->withSuccess( __('messages.msg_deleted',['name' => __('messages.slider')] ));
    }
    
    public function action(Request $request){
        $id = $request->id;

        $slider  = Slider::withTrashed()->where('id',$id)->first();
        $msg = __('messages.not_found_entry',['name' => __('messages.slider')] );
        if($request->type == 'restore') {
            $slider->restore();
            $msg = __('messages.msg_restored',['name' => __('messages.slider')] );
        }

        if($request->type === 'forcedelete'){
            $slider->forceDelete();
            $msg = __('messages.msg_forcedelete',['name' => __('messages.slider')] );
        }
        return comman_custom_response(['message'=> $msg , 'status' => true]);
    }
}
