<x-master-layout>
    <div class="container-fluid">
        <div class="row">
            <div class="col-lg-12">
                {{ Breadcrumbs::render('create_provider') }}
            </div>
            <div class="col-lg-12">
                <div class="card">
                    <div class="card-body">
                        {{ Form::open(['method' => 'POST', 'route' => 'providers.store', 'enctype' => 'multipart/form-data', 'data-toggle' => 'validator', 'id' => 'provider']) }}
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
                                {{ Form::label('providertype_id', __('messages.select_name', ['select' => __('messages.providertype')]) . ' <span class="text-danger">*</span>', ['class' => 'form-control-label'], false) }}
                                <br />
                                {{ Form::select('providertype_id', $providerTypes, null, [
                                    'class' => 'select2js form-group providertype',
                                    'required',
                                    'data-placeholder' => __('messages.select_name', ['select' => __('messages.providertype')]),
                                    'data-ajax--url' => route('ajax-list', ['type' => 'providertype']),
                                ]) }}
                            </div>

                            <div class="form-group col-md-4">
                                {{ Form::label('country_id', __('messages.select_name', ['select' => __('messages.country')]), ['class' => 'form-control-label'], false) }}
                                <br />
                                {{ Form::select('country_id', $countries, null, [
                                    'class' => 'select2js form-group country',
                                    'data-placeholder' => __('messages.select_name', ['select' => __('messages.country')]),
                                    'data-ajax--url' => route('ajax-list', ['type' => 'country']),
                                ]) }}
                            </div>

                            <div class="form-group col-md-4">
                                {{ Form::label('state_id', __('messages.select_name', ['select' => __('messages.state')]), ['class' => 'form-control-label'], false) }}
                                <br />
                                {{ Form::select(
                                    'state_id',
                                    [],
                                    [
                                        'class' => 'select2js form-group state_id',
                                        'data-placeholder' => __('messages.select_name', ['select' => __('messages.state')]),
                                    ],
                                ) }}
                            </div>

                            <div class="form-group col-md-4">
                                {{ Form::label('city_id', __('messages.select_name', ['select' => __('messages.city')]), ['class' => 'form-control-label'], false) }}
                                <br />
                                {{ Form::select('city_id', [], old('city_id'), [
                                    'class' => 'select2js form-group city_id',
                                    'data-placeholder' => __('messages.select_name', ['select' => __('messages.city')]),
                                ]) }}
                            </div>
                            <div class="form-group col-md-4">
                                {{ Form::label('name', __('messages.select_name', ['select' => __('messages.tax')]), ['class' => 'form-control-label'], false) }}
                                <br />
                                {{ Form::select('tax_id[]', [], old('tax_id'), [
                                    'class' => 'select2js form-group tax_id',
                                    'id' => 'tax_id',
                                    'multiple' => 'multiple',
                                    'data-placeholder' => __('messages.select_name', ['select' => __('messages.tax')]),
                                ]) }}

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
                                <label class="form-control-label"
                                    for="profile_image">{{ __('messages.profile_image') }} </label>
                                <div class="custom-file">
                                    <input type="file" name="profile_image" class="custom-file-input"
                                        accept="image/*">
                                    <label
                                        class="custom-file-label">{{ __('messages.choose_file', ['file' => __('messages.profile_image')]) }}</label>
                                </div>
                                <span class="selected_file"></span>
                            </div>
                            <div class="form-group col-md-12">
                                {{ Form::label('address', __('messages.address'), ['class' => 'form-control-label']) }}
                                {{ Form::textarea('address', null, ['class' => 'form-control textarea', 'rows' => 3, 'placeholder' => __('messages.address')]) }}
                            </div>
                        </div>
                        <div class="row">
                            <div class="form-group col-md-6">
                                <div class="custom-control custom-checkbox custom-control-inline">
                                    {{ Form::checkbox('is_featured', null, null, ['class' => 'custom-control-input', 'id' => 'is_featured']) }}
                                    <label class="custom-control-label"
                                        for="is_featured">{{ __('messages.set_as_featured') }}
                                    </label>
                                </div>
                            </div>
                        </div>
                        {{ Form::submit(__('messages.save'), ['class' => 'btn btn-md btn-primary float-right']) }}
                        {{ Form::close() }}
                    </div>
                </div>
            </div>
        </div>
    </div>

    @section('bottom_script')
        <script type="text/javascript">
            (function($) {
                "use strict";
                $(document).ready(function() {
                    var country_id = 0;
                    var state_id = 0;
                    var city_id = 0;

                    var provider_id = 0;
                    var provider_tax_id = [];

                    getTax(provider_id, provider_tax_id)
                    stateName(country_id, state_id);
                    $(document).on('change', '#country_id', function() {
                        var country = $(this).val();
                        $('#state_id').empty();
                        $('#city_id').empty();
                        stateName(country);
                    })
                    $(document).on('change', '#state_id', function() {
                        var state = $(this).val();
                        $('#city_id').empty();
                        cityName(state, city_id);
                    })
                })

                function stateName(country, state = "") {
                    var state_route = "{{ route('ajax-list', ['type' => 'state', 'country_id' => '']) }}" + country;
                    state_route = state_route.replace('amp;', '');

                    $.ajax({
                        url: state_route,
                        success: function(result) {
                            $('#state_id').select2({
                                width: '100%',
                                placeholder: "{{ trans('messages.select_name', ['select' => trans('messages.state')]) }}",
                                data: result.results
                            });
                            if (state != null) {
                                $("#state_id").val(state).trigger('change');
                            }
                        }
                    });
                }

                function cityName(state, city = "") {
                    var city_route = "{{ route('ajax-list', ['type' => 'city', 'state_id' => '']) }}" + state;
                    city_route = city_route.replace('amp;', '');

                    $.ajax({
                        url: city_route,
                        success: function(result) {
                            $('#city_id').select2({
                                width: '100%',
                                placeholder: "{{ trans('messages.select_name', ['select' => trans('messages.city')]) }}",
                                data: result.results
                            });
                            if (city != null || city != 0) {
                                $("#city_id").val(city).trigger('change');
                            }
                        }
                    });
                }

                function getTax(provider_id, provider_tax_id = "") {
                    var provider_tax_route = "{{ route('ajax-list', ['type' => 'provider_tax', 'provider_id' => '']) }}" +
                        provider_id;
                    provider_tax_route = provider_tax_route.replace('amp;', '');

                    $.ajax({
                        url: provider_tax_route,
                        success: function(result) {
                            $('#tax_id').select2({
                                width: '100%',
                                placeholder: "{{ trans('messages.select_name', ['select' => trans('messages.tax')]) }}",
                                data: result.results
                            });
                            if (provider_tax_id != "") {
                                $('#tax_id').val(provider_tax_id.split(',')).trigger('change');
                            }
                        }
                    });
                }
            })(jQuery);
        </script>
    @endsection
</x-master-layout>
