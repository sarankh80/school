<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Models\Provider;
use App\Models\Booking;
use App\Models\Service;
use App\DataTables\ProviderDataTable;
use App\DataTables\ServiceDataTable;
use App\Http\Requests\ProviderCreateRequest;
use App\Http\Requests\ProviderUpdateRequest;
use App\Repositories\ProviderRepository;
use App\Repositories\ProviderTypeRepository;
use App\Repositories\CountryRepository;

class ProviderController extends Controller  
{
    /**
     * @var ProviderRepository
     */
    protected $providerRepo;

    /**
     * @var ProviderTypeRepository
     */
    protected $providerTypeRepo;

    /**
     * @var CountryRepository
     */
    protected $countryRepo;

    public function __construct(ProviderRepository $providerRepository, ProviderTypeRepository $providerTypeRepository, CountryRepository $countryRepository)
    {
        $this->providerRepo = $providerRepository;
        $this->providerTypeRepo = $providerTypeRepository;
        $this->countryRepo = $countryRepository;
    }

    /** 
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index(ProviderDataTable $dataTable, Request $request)
    {
        return $dataTable->render('provider.index', ['assets' => $dataTable]);
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        $providerTypes = $this->providerTypeRepo->get()->pluck('name', 'id');
        $countries = $this->countryRepo->get()->pluck('name', 'id');
        
        return view('provider.create', compact('providerTypes', 'countries'));
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\ProviderCreate  $request
     * @return \Illuminate\Http\Response
     */
    public function store(ProviderCreateRequest $request)
    {
        $this->providerRepo->create($request);

		return redirect(route('providers.index'))->withSuccess(__('messages.save_form',[ 'form' => __('messages.provider') ] ));
    }

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show(ServiceDataTable $dataTable, $id)
    {
        $provider = $this->providerRepo->find($id);

        return $dataTable->with('provider_id', $id)->render('provider.view', compact('provider'));
    }

    /** 
     * Show the form for editing the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function edit($id)
    {
        $provider = $this->providerRepo->find($id);
        $providerTypes = $this->providerTypeRepo->get()->pluck('name', 'id');
        $countries = $this->countryRepo->get()->pluck('name', 'id');

        return view('provider.edit', compact('provider', 'providerTypes', 'countries'));
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(ProviderUpdateRequest $request, $id)
    {
        $this->providerRepo->update($request, $id);

		return redirect(route('providers.index'))->withSuccess(__('messages.save_form',[ 'form' => __('messages.provider') ] ));
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy($id)
    {
        $provider = Provider::find($id);
        $msg= __('messages.msg_fail_to_delete',['name' => __('messages.provider')] );
        
        if($provider != '') { 
            $provider->delete();
            $msg= __('messages.msg_deleted',['name' => __('messages.provider')] );
        }

        return redirect()->back()->withSuccess($msg);
    }

    public function action(Request $request){
        $id = $request->id;

        $provider  = Provider::withTrashed()->where('id',$id)->first();
        $msg = __('messages.not_found_entry',['name' => __('messages.provider')] );
        if($request->type == 'restore') {
            $provider->restore();
            $msg = __('messages.msg_restored',['name' => __('messages.provider')] );
        }

        if($request->type === 'forcedelete'){
            $provider->forceDelete();
            $msg = __('messages.msg_forcedelete',['name' => __('messages.provider')] );
        }
        
        return comman_custom_response(['message'=> $msg , 'status' => true]);
    }
}
