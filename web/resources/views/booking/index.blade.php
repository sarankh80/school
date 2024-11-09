<x-master-layout>
    <div class="container-fluid">
        <div class="row">
            <div class="col-lg-12">
                <div class="card card-block card-stretch">
                    <div class="card-body p-0">
                        <div class="d-flex justify-content-between align-items-center p-3">
                            <h5 class="font-weight-bold">{{ $pageTitle ?? trans('messages.list') }}</h5>
                            @if($auth_user->can('booking add'))
                            <a href="{{ route('booking.create') }}" class="float-right mr-1 btn btn-sm btn-primary"><i class="fa fa-plus-circle"></i> {{ __('messages.add_form_title',['form' => __('messages.booking')  ]) }}</a>
                            @endif
                        </div>
                        {{ Form::open(['method' => 'GET', 'route' => 'booking.index', 'enctype' => 'multipart/form-data', 'data-toggle' => 'validator', 'id' => 'booking']) }}
                        <div class="container-fluid">
                            <div class="row">
                                <div class="form-group col-md-4">
                                    {{ Form::label('status', __('messages.select_name',[ 'select' => __('messages.status') ]),['class'=>'form-control-label']) }}
                                    <br />
                                    {{ Form::select('status',$status,$select,[ 'id' => 'status' ,'class' =>'form-control select2js booking_status']) }}
                                </div>
                                <div class="form-group col-md-4 my-4">
                                    {{ Form::submit( __('messages.search'), ['class'=>'btn_search btn btn-md btn-primary float-right']) }}
                                </div>
                            </div>                            
                        </div>
                        {{ Form::close() }}
                        {{ $dataTable->table(['class' => 'table  w-100'],false) }}
                    </div>
                </div>
            </div>
        </div>
    </div>
@section('bottom_script')
    {{ $dataTable->scripts() }}
@endsection
</x-master-layout>