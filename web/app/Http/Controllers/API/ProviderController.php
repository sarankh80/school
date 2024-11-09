<?php

namespace App\Http\Controllers\API;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Models\User;
use App\Models\Booking;
use App\Models\Service;
use App\DataTables\ProviderDataTable;
use App\DataTables\ServiceDataTable;
use App\Http\Requests\ProviderCreate;
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
    public function store(ProviderCreate $request)
    {

        $loginuser = \Auth::user();
        if(demoUserPermission()){
            return  redirect()->back()->withErrors(trans('messages.demo_permission_denied'));
        }
        $data = $request->all();
        $id = $data['id'];
        $data['user_type'] = $data['user_type'] ?? 'provider';
        $data['is_featured'] = 0;
       
        if($request->has('is_featured')){
			$data['is_featured'] = 1;
		}

        $data['display_name'] = $data['first_name']." ".$data['last_name'];
        // Save User data...
        if($id == null){
            $data['password'] = bcrypt($data['password']);
            $user = User::create($data);
        }else{
            $user = User::findOrFail($id);
            // User data...
            // $user->removeRole($user->user_type);
            $user->fill($data)->update();
        }
        if($data['status'] == 1 && auth()->user()->hasAnyRole(['admin'])){
            try {
                \Mail::send('verification.verification_email',
                array(), function($message) use ($user)
                {
                    $message->from(env('MAIL_FROM_ADDRESS'));
                    $message->to($user->email);
                });
            } catch (\Throwable $th) {
                //throw $th;
            }
           
        }
        $user->assignRole($data['user_type']);
        storeMediaFile($user,$request->profile_image, 'profile_image');
        $message = __('messages.update_form',[ 'form' => __('messages.provider') ] );
		if($user->wasRecentlyCreated){
			$message = __('messages.save_form',[ 'form' => __('messages.provider') ] );
		}
        if($user->providerTaxMapping()->count() > 0)
        {
            $user->providerTaxMapping()->delete();
        }
        if($request->tax_id != null) {
            foreach($request->tax_id as $tax) {
                $provider_tax = [
                    'provider_id'   => $user->id,
                    'tax_id'   => $tax,
                ];
                $user->providerTaxMapping()->insert($provider_tax);
            }
        }

        if($request->is('api/*')) {
            return comman_message_response($message);
		}

		return redirect(route('providers.index'))->withSuccess($message);
    }

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show(ServiceDataTable $dataTable,$id)
    {
        $auth_user = authSession();
        $providerdata = User::with('getServiceRating')->where('user_type','provider')->where('id',$id)->first();

        if(empty($providerdata))
        {
            $msg = __('messages.not_found_entry',['name' => __('messages.provider')] );
            return redirect(route('providers.index'))->withError($msg);
        }
        $pageTitle = __('messages.view_form_title',['form'=> __('messages.provider')]);
        return $dataTable
        ->with('provider_id',$id)
        ->render('provider.view', compact('pageTitle' ,'providerdata' ,'auth_user' ));
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function edit($id)
    {
        //
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
        //
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy($id)
    {
        if(demoUserPermission()){
            return  redirect()->back()->withErrors(trans('messages.demo_permission_denied'));
        }
        $provider = User::find($id);
        $msg= __('messages.msg_fail_to_delete',['name' => __('messages.provider')] );
        
        if($provider != '') { 
            $provider->delete();
            $msg= __('messages.msg_deleted',['name' => __('messages.provider')] );
        }

        return redirect()->back()->withSuccess($msg);
    }
    public function action(Request $request){
        $id = $request->id;

        $provider  = User::withTrashed()->where('id',$id)->first();
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
