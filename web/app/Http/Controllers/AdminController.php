<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\DataTables\AdminDataTable;
use App\Models\Booking;
use App\Models\Payment;
use App\Repositories\AdminRepository;

class AdminController extends Controller
{     
    /**
    * @var AdminRepository
    */
    protected $adminRepo;

    public function __construct(AdminRepository $adminRepository)
    {
        $this->adminRepo = $adminRepository;
    }
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index(AdminDataTable $dataTable)
    {
        return $dataTable->render('admin.index', ['assets' => $dataTable]);
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        return view('admin.create');
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        $data = $request->all();
        $data['display_name'] = $data['first_name']." ".$data['last_name'];
        $data['user_type'] = "admin";
        $data['password'] = bcrypt($data['password']);

        $user = $this->adminRepo->create($data);

        $user->assignRole("admin");

		return redirect(route('admins.index'))->withSuccess(__('messages.save_form', [ 'form' => __('messages.user') ]));
    }

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show($id)
    {
        $admin = $this->adminRepo->findOrFail($id);

        $admin_pending_trans  = Payment::where('customer_id', $id)->where('payment_status','pending')->get();

        return view('admin.view', compact('admin' ,'admin_pending_trans' ));
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function edit($id)
    {
        $admin = $this->adminRepo->findOrFail($id);
        
        return view('admin.edit', compact('admin'));
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
        $customer = $this->adminRepo->findOrFail($id);

        $data = $request->all();

        $data['display_name'] = $data['first_name']." ".$data['last_name'];
        $data['user_type'] = "admin";

        $customer->fill($data)->update();

		return redirect(route('admins.index'))->withSuccess(__('messages.update_form', [ 'form' => __('messages.user') ] ));  
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy($id)
    {
        $customer = $this->adminRepo->findOrFail($id);
        $customer->delete();

        return redirect()->back()->withSuccess(__('messages.msg_deleted',['name' => __('messages.user')] ));
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  Request  $id
     * @return \Illuminate\Http\Response
     */
    public function action(Request $request){
        $id = $request->id;
        $customer = $this->adminRepo->withTrashed()->where('id', $id)->first();
        $msg = __('messages.not_found_entry',['name' => __('messages.user')] );

        if($request->type == 'restore') {
            $customer->restore();
            $msg = __('messages.msg_restored',['name' => __('messages.user')] );
        }

        if($request->type === 'forcedelete') {
            $customer->forceDelete();
            $msg = __('messages.msg_forcedelete',['name' => __('messages.user')]);
        }

        return comman_custom_response(['message'=> $msg , 'status' => true]);
    }
}
