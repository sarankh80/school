<x-master-layout>
    <div class="container-fluid">
        <div class="row">
            <div class="col-lg-12">
                {{ Breadcrumbs::render('edit_brand', $brand->id) }}
            </div>
            <div class="col-lg-12">
                <div class="card">
                    <div class="card-body">
                        {{ Form::model($brand, ['method' => 'PUT', 'route' => ['brands.update', $brand->id], 'data-toggle' => 'validator', 'id' => 'brand']) }}
                        {{ Form::hidden('id') }}
                        <div class="row">

                            <div class="form-group col-md-6">
                                {{ Form::label('name', __('messages.name') . ' <span class="text-danger">*</span>', ['class' => 'form-control-label'], false) }}
                                {{ Form::text('name', old('name'), ['placeholder' => __('messages.name'), 'class' => 'form-control', 'required']) }}
                                <small class="help-block with-errors text-danger"></small>
                            </div>
                            <?php
                                $language_option = settingSession('get')->language_option;
                                if(!empty($language_option)){
                                    $language_array = languagesArray($language_option);
                                }
                            ?>
                            @if(count($language_array) > 0 )
                                @foreach($language_array as $lang)
                                @if($lang['id']!="en")
                                <div class="form-group col-md-4">
                                    {{ Form::label($lang['title'], $lang['title'] . ' <span class="text-danger">*</span>', ['class' => 'form-control-label'], false) }}
                                    {{ Form::text($lang['id'], old('name'), ['placeholder' => trans('messages.name'), 'class' => 'form-control', 'required']) }}
                                    <small class="help-block with-errors text-danger"></small>
                                </div>
                                @endif
                                @endforeach
                            @endif
                            <div class="form-group col-md-6">
                                {{ Form::label('status', __('messages.status') . ' <span class="text-danger">*</span>', ['class' => 'form-control-label'], false) }}
                                {{ Form::select('status', ['1' => __('messages.active'), '0' => __('messages.inactive')], old('status'), ['id' => 'role', 'class' => 'form-control select2js', 'required']) }}
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
