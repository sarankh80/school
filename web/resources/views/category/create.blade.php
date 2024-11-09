<x-master-layout>
    <div class="container-fluid">
        <div class="row">
            <div class="col-lg-12">
                {{ Breadcrumbs::render('create_category') }}
            </div>
            <div class="col-lg-12">
                <div class="card">
                    <div class="card-body">
                        {{ Form::open(['method' => 'POST', 'route' => 'categories.store', 'enctype' => 'multipart/form-data', 'data-toggle' => 'validator', 'id' => 'category']) }}
                        <div class="row">
                            <div class="form-group col-md-4">
                                {{ Form::label('name', trans('messages.english') . ' <span class="text-danger">*</span>', ['class' => 'form-control-label'], false) }}
                                {{ Form::text('name', old('name'), ['placeholder' => trans('messages.name'), 'class' => 'form-control', 'required']) }}
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
                            <div class="form-group col-md-4">
                                {{ Form::label('name', trans('messages.order') . ' <span class="text-danger">*</span>', ['class' => 'form-control-label'], false) }}
                                {{ Form::number('position', old('position'), ['placeholder' => trans('messages.order'), 'class' => 'form-control', 'required']) }}
                                <small class="help-block with-errors text-danger"></small>
                            </div>

                            <div class="form-group col-md-4">
                                {{ Form::label('color', trans('messages.color'), ['class' => 'form-control-label']) }}
                                {{ Form::color('color', null, ['placeholder' => trans('messages.color'), 'class' => 'form-control', 'id' => 'color']) }}
                            </div>

                            <div class="form-group col-md-4">
                                {{ Form::label('status', trans('messages.status') . ' <span class="text-danger">*</span>', ['class' => 'form-control-label'], false) }}
                                {{ Form::select('status', ['1' => __('messages.active'), '0' => __('messages.inactive')], old('status'), ['id' => 'role', 'class' => 'form-control select2js', 'required']) }}
                            </div>

                            <div class="form-group col-md-4">
                                <label class="form-control-label" for="category_image">{{ __('messages.image') }}
                                </label>
                                <div class="custom-file">
                                    <input type="file" name="category_image" class="custom-file-input"
                                        accept="image/*">
                                    <label
                                        class="custom-file-label">{{ __('messages.choose_file', ['file' => __('messages.image')]) }}</label>
                                </div>
                                <span class="selected_file"></span>
                            </div>

                            <div class="form-group col-md-8">
                                {{ Form::label('relation_id', __('messages.category_relation'), ['class' => 'form-control-label'], false) }}
                                <br />
                                {{ Form::select('relation_id[]', $category_relations, old('relation_id'), [
                                    'class' => 'select2js form-group relation_id',
                                    'multiple' => 'multiple',
                                    'id' => 'relation_id',
                                    'data-placeholder' => __('messages.category_relation', ['select' => __('messages.category_relation')]),
                                ]) }}
                            </div>

                            <div class="form-group col-md-12">
                                {{ Form::label('description', trans('messages.description'), ['class' => 'form-control-label']) }}
                                {{ Form::textarea('description', null, ['class' => 'form-control textarea', 'rows' => 3, 'placeholder' => __('messages.description')]) }}
                            </div>

                            <div class="form-group col-md-12">
                                <tree-view value-field="id" name-field="parent_id" input-type="radio"
                                    items='@json($categories)'
                                    fallback-locale="{{ config('app.fallback_locale') }}"></tree-view>
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
                        {{ Form::submit(trans('messages.save'), ['class' => 'btn btn-md btn-primary float-right']) }}
                        {{ Form::close() }}
                    </div>
                </div>
            </div>
        </div>
    </div>
</x-master-layout>
