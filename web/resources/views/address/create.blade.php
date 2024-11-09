<x-master-layout>
    <div class="container-fluid">
        <div class="row">
            <div class="col-lg-12">
                <div class="card card-block card-stretch">
                    <div class="card-body p-0">
                        <div class="d-flex justify-content-between align-items-center p-3">
                            {{ Breadcrumbs::render('create_address') }}
                            @can('provideraddress list')
                                <a href="{{ route('addresses.index') }}" class="float-right btn btn-sm btn-primary"><i
                                        class="fa fa-angle-double-left"></i> {{ __('messages.back') }}</a>
                            @endcan
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-lg-12">
                <div class="card">
                    <div class="card-body">
                        {{ Form::open(['method' => 'POST', 'route' => 'addresses.store', 'data-toggle' => 'validator', 'id' => 'provideraddress']) }}
                        <div class="row">
                            @hasrole('admin')
                                <div class="form-group col-md-4">
                                    {{ Form::label('addressable_id', __('messages.select_name', ['select' => __('messages.providers')]) . ' <span class="text-danger">*</span>', ['class' => 'form-control-label'], false) }}
                                    <br />
                                    {{ Form::select('addressable_id', $providers, null, [
                                        'class' => 'select2js form-group providers',
                                        'required',
                                        'data-placeholder' => __('messages.select_name', ['select' => __('messages.providers')]),
                                        'data-ajax--url' => route('ajax-list', ['type' => 'provider']),
                                    ]) }}
                                </div>
                            @endhasrole

                            <div class="form-group col-md-4">
                                {{ Form::label('latitude', __('messages.latitude') . ' <span class="text-danger">*</span>', ['class' => 'form-control-label'], false) }}
                                {{ Form::number('latitude', old('latitude'), ['placeholder' => '00.0000', 'class' => 'form-control', 'required', 'step' => 'any']) }}
                            </div>

                            <div class="form-group col-md-4">
                                {{ Form::label('longitude', __('messages.longitude') . ' <span class="text-danger">*</span>', ['class' => 'form-control-label'], false) }}
                                {{ Form::number('longitude', old('longitude'), ['placeholder' => '00.0000', 'class' => 'form-control', 'required', 'step' => 'any']) }}
                            </div>

                            <div class="form-group col-md-4">
                                {{ Form::label('status', __('messages.status') . ' <span class="text-danger">*</span>', ['class' => 'form-control-label'], false) }}
                                {{ Form::select('status', ['1' => __('messages.active'), '0' => __('messages.inactive')], old('status'), ['id' => 'role', 'class' => 'form-control select2js', 'required']) }}
                            </div>

                            <div class="form-group col-md-4">
                                {{ Form::label('address', __('messages.address') . ' <span class="text-danger">*</span>', ['class' => 'form-control-label'], false) }}
                                {{ Form::textarea('address', null, ['class' => 'form-control textarea', 'required', 'rows' => 3, 'placeholder' => __('messages.address')]) }}
                                <small class="help-block with-errors text-danger"></small>
                            </div>

                            <div class="form-group col-md-4">
                                {{ Form::label('service_id', __('messages.select_name', ['select' => __('messages.service')]), ['class' => 'form-control-label'], false) }}
                                <br />
                                {{ Form::select('service_id[]', $services, old('service_id'), [
                                    'class' => 'select2js form-group service_id',
                                    'id' => 'service_id',
                                    'multiple' => 'multiple',
                                    'data-placeholder' => __('messages.select_name', ['select' => __('messages.service')]),
                                ]) }}
                            </div>
                        </div>
                        {{ Form::submit(__('messages.save'), ['class' => 'btn btn-md btn-primary float-right']) }}
                        {{ Form::close() }}
                    </div>
                </div>
            </div>
        </div>
    </div>
</x-master-layout>
