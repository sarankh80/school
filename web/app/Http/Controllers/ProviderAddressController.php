<?php

namespace App\Http\Controllers;

use App\DataTables\ProviderAddressDataTable;
use App\Repositories\ProviderAddressRepository;
use App\Repositories\ProviderRepository;
use App\Repositories\ServiceRepository;
use App\Http\Requests\AddressRequest;

class ProviderAddressController extends Controller
{
    /**
     * @var ProviderAddressRepository
     */
    protected $addressRepo;

    /**
     * @var ProviderRepository
     */
    protected $providerRepo;

    /**
     * @var ServiceRepository
     */
    protected $serviceRepo;

    public function __construct(ServiceRepository $serviceRepository, ProviderAddressRepository $addressRepository, ProviderRepository $providerRepository){
        $this->addressRepo = $addressRepository;
        $this->serviceRepo = $serviceRepository;
        $this->providerRepo = $providerRepository;
    }

    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index(ProviderAddressDataTable $dataTable)
    {
        return $dataTable->render('address.index', ['assets' => $dataTable]);
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        $providers = $this->providerRepo->get()->pluck('display_name', 'id');
        $services = $this->serviceRepo->skipPresenter()->get()->pluck('name', 'id');

        return view('address.create', compact('providers', 'services'));
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(AddressRequest $request)
    {
        $param = $request->all();

        $this->addressRepo->create($param);

        return redirect(route('addresses.index'))->withSuccess(__('messages.save_form',['form' => __('messages.provider_address')]));   
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
        $address = $this->addressRepo->skipPresenter()->find($id);
        $providers = $this->providerRepo->get()->pluck('display_name', 'id');
        $services = $this->serviceRepo->skipPresenter()->get()->pluck('name', 'id');

        return view('address.edit', compact('address', 'providers', 'services'));
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(AddressRequest $request, $id)
    {
        $param = $request->all();

        $this->addressRepo->update($param, $id);

        return redirect(route('addresses.index'))->withSuccess(__('messages.update_form_title',['form' => __('messages.provider_address')]));   
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy($id)
    {
        $providerAddress = $this->addressRepo->find($id);

        $msg = __('messages.msg_fail_to_delete',['item' => __('messages.provider_address')] );
        
        if($providerAddress != '') { 
            $providerAddress->delete();
            $msg = __('messages.msg_deleted',['name' => __('messages.provider_address')] );
        }

        return redirect()->back()->withSuccess($msg);
    }
}
