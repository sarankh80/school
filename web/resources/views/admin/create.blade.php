<x-master-layout>
    <div class="container-fluid">
        <div class="row">
            <div class="col-lg-12">
                {{ Breadcrumbs::render('create_admin') }}
            </div>
            <div class="col-lg-12">
                <div class="card">
                    <div class="card-body">
                        {{ Form::open(['method' => 'POST', 'route' => 'admins.store', 'enctype' => 'multipart/form-data', 'data-toggle' => 'validator', 'id' => 'user']) }}
                        <div class="row">
                            <div class="form-group col-md-4">
                                {{ Form::label('first_name', __('messages.first_name') . ' <span class="text-danger">*</span>', ['class' => 'form-control-label'], false) }}
                                {{ Form::text('first_name', old('first_name'), ['placeholder' => __('messages.first_name'), 'class' => 'form-control', 'required']) }}
                                <small class="help-block with-errors text-danger"></small>
                            </div>

                            <div class="form-group col-md-4">
                                {{ Form::label('last_name', __('messages.last_name') . ' <span class="text-danger">*</span>', ['class' => 'form-control-label'], false) }}
                                {{ Form::text('last_name', old('last_name'), ['placeholder' => __('messages.last_name'), 'class' => 'form-control', 'required']) }}
                                <small class="help-block with-errors text-danger"></small>
                            </div>

                            <div class="form-group col-md-4">
                                {{ Form::label('username', __('messages.username') . ' <span class="text-danger">*</span>', ['class' => 'form-control-label'], false) }}
                                {{ Form::text('username', old('username'), ['placeholder' => __('messages.username'), 'class' => 'form-control', 'required']) }}
                                <small class="help-block with-errors text-danger"></small>
                            </div>

                            <div class="form-group col-md-4">
                                {{ Form::label('email', __('messages.email') . ' <span class="text-danger">*</span>', ['class' => 'form-control-label'], false) }}
                                {{ Form::email('email', old('email'), ['placeholder' => __('messages.email'), 'class' => 'form-control', 'required']) }}
                                <small class="help-block with-errors text-danger"></small>
                            </div>
                            <div class="form-group col-md-4">
                                {{ Form::label('password', __('messages.password') . ' <span class="text-danger">*</span>', ['class' => 'form-control-label'], false) }}
                                {{ Form::password('password', ['class' => 'form-control', 'placeholder' => __('messages.password'), 'required']) }}
                                <small class="help-block with-errors text-danger"></small>
                            </div>

                            <div class="form-group col-md-4">
                                {{ Form::label('phone_number', __('messages.phone_number') . ' <span class="text-danger">*</span>', ['class' => 'form-control-label'], false) }}
                                {{ Form::text('phone_number', old('phone_number'), ['placeholder' => __('messages.phone_number'), 'class' => 'form-control', 'required']) }}
                                <small class="help-block with-errors text-danger"></small>
                            </div>

                            <div class="form-group col-md-4">
                                {{ Form::label('status', __('messages.status') . ' <span class="text-danger">*</span>', ['class' => 'form-control-label'], false) }}
                                {{ Form::select('status', ['1' => __('messages.active'), '0' => __('messages.inactive')], old('status'), ['class' => 'form-control select2js', 'required']) }}
                            </div>
                            <div class="form-group col-md-4">
                                {{ Form::label('address', __('messages.address'), ['class' => 'form-control-label']) }}
                                {{ Form::textarea('address', null, ['class' => 'form-control textarea', 'rows' => 3, 'placeholder' => __('messages.address')]) }}
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
