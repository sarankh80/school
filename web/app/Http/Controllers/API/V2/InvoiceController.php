<?php

namespace App\Http\Controllers\API\V2;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App\Repositories\InvoiceRepository;
use App\Repositories\BookingRepository;
use Prettus\Repository\Criteria\RequestCriteria;
use Prettus\Repository\Exceptions\RepositoryException;
use App\Criteria\LimitOffsetCriteria;
use App\Criteria\InvoiceByProviderCriteria;
use App\Criteria\InvoiceByCustomerCriteria;

class InvoiceController extends Controller
{
    /**
     * Display a listing of the bookings.
     *
     * @return BookingRepository
     */
    protected $bookingRepo;

    /**
     * Display a listing of the invoices.
     *
     * @return InvoiceRepository
     */
    protected $invoiceRepo;

    /**
     * Create a new controller instance.
     *
     * @param  \App\Repositories\BookingRepository  $bookingRepository
     * @param  \App\Repositories\InvoiceRepository  $invoiceRepository
     * @return void
     */
    public function __construct(
        protected BookingRepository $bookingRepository,
        protected InvoiceRepository $invoiceRepository
    )
    {
        $this->bookingRepo = $bookingRepository;
        $this->invoiceRepo = $invoiceRepository;
    }

    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index(Request $request)
    {
        try { 
            $this->invoiceRepo->pushCriteria(new RequestCriteria($request));
            $this->invoiceRepo->pushCriteria(new InvoiceByProviderCriteria($request));
            $this->invoiceRepo->pushCriteria(new InvoiceByCustomerCriteria($request));
            $this->invoiceRepo->pushCriteria(new LimitOffsetCriteria($request));

            if (!empty($request->page)) {
                $invoices = $this->invoiceRepo->paginate($limit = 10, $columns = ['*']);
            } else {
                $invoices = $this->invoiceRepo->get();
            }

        } catch (RepositoryException $e) {
            return $this->sendError($e->getMessage());
        }

        return $this->sendResponse($invoices, 'Invoices fetched successfully');
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  int  $bookingId
     * @return \Illuminate\Http\Response
     */
    public function store($bookingId)
    {
        $booking = $this->bookingRepo->findOrFail($bookingId);

        if (! $booking->canInvoice()) {
            session()->flash('error', trans('admin::app.sales.invoices.creation-error'));

            return redirect()->back();
        }

        $this->validate(request(), [
            'invoice.items.*' => 'required|numeric|min:0',
        ]);

        // if (! $this->invoiceRepository->haveProductToInvoice(request()->all())) {
        //     session()->flash('error', trans('admin::app.sales.invoices.product-error'));

        //     return redirect()->back();
        // }

        $this->invoiceRepository->create(array_merge(request()->all(), [
            'booking_id' => $bookingId,
        ]));

        return comman_message_response(__('messages.save_form', ['form' => __('messages.invoice')]));
    }

    /**
     * Show the view for the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\View\View
     */
    public function view($id)
    {
        $invoice = $this->invoiceRepository->findOrFail($id);

        return view($this->_config['view'], compact('invoice'));
    }

    /**
     * Send duplicate invoice.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function sendDuplicateInvoice(Request $request, $id)
    {
        $request->validate([
            'email' => 'required|email',
        ]);

        $invoice = $this->invoiceRepository->findOrFail($id);

        $this->sendDuplicateInvoiceMail($invoice, $request->email);

        session()->flash('success', trans('admin::app.sales.invoices.invoice-sent'));

        return redirect()->back();
    }

    /**
     * Print and download the for the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function printInvoice($id)
    {
        $invoice = $this->invoiceRepository->findOrFail($id);

        return $this->downloadPDF(
            view('admin::sales.invoices.pdf', compact('invoice'))->render(),
            'invoice-' . $invoice->created_at->format('d-m-Y')
        );
    }
}
