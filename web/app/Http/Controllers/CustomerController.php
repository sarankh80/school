<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\DataTables\CustomerDataTable;
use App\Models\User;
use App\Models\Booking;
use App\Models\Payment;
use App\Repositories\CustomerRepository;

class CustomerController extends Controller
{     
    /**
    * @var CustomerRepository
    */
   protected $customerRepo;

   public function __construct(CustomerRepository $customerRepository)
   {
       $this->customerRepo = $customerRepository;
   }
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index(CustomerDataTable $dataTable)
    {
        return $dataTable->render('customer.index', ['assets' => $dataTable]);
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        return view('customer.create');
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
        $data['password'] = bcrypt($data['password']);

        $user = $this->customerRepo->create($data);

        $user->assignRole("user");

		return redirect(route('users.index'))->withSuccess(__('messages.save_form', [ 'form' => __('messages.user') ]));
    }

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show($id)
    {
        $customer = $this->customerRepo->findOrFail($id);

        $customer_pending_trans  = Payment::where('customer_id', $id)->where('payment_status','pending')->get();

        return view('customer.view', compact('customer' ,'customer_pending_trans' ));
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function edit($id)
    {
        $customer = $this->customerRepo->findOrFail($id);
        
        return view('customer.edit', compact('customer'));
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
        $customer = $this->customerRepo->findOrFail($id);

        $data = $request->all();

        $data['display_name'] = $data['first_name']." ".$data['last_name'];

        $customer->fill($data)->update();

		return redirect(route('users.index'))->withSuccess(__('messages.update_form', [ 'form' => __('messages.user') ] ));  
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy($id)
    {
        $customer = $this->customerRepo->findOrFail($id);
        $customer->delete();

        return redirect()->back()->withSuccess(__('messages.msg_deleted',['name' => __('messages.user')] ));
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function action(Request $request){
        $id = $request->id;
        $customer = $this->customerRepo->withTrashed()->where('id', $id)->first();
        $msg = __('messages.not_found_entry',['name' => __('messages.user')] );
        if($request->type == 'restore') {
            $customer->restore();
            $msg = __('messages.msg_restored',['name' => __('messages.user')] );
        }
        if($request->type === 'forcedelete'){
            $customer->forceDelete();
            $msg = __('messages.msg_forcedelete',['name' => __('messages.user')]);
        }

        return comman_custom_response(['message'=> $msg , 'status' => true]);
    }
}
