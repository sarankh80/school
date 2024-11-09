<x-master-layout>
    <div class="container-fluid">
        <div class="row">
            <div class="col-lg-12">
                {{ Breadcrumbs::render('edit_category', $category->id) }}
            </div>
            <div class="col-lg-12">
                <div class="card">
                    <div class="card-body">
                        {{ Form::model($category, ['method' => 'PUT', 'route' => ['categories.update', $category->id], 'enctype' => 'multipart/form-data', 'data-toggle' => 'validator', 'id' => 'category']) }}
                        {{ Form::hidden('id') }}
                        <div class="row">
                            <div class="form-group col-md-4">
                                {{ Form::label('name', trans('messages.name') . ' <span class="text-danger">*</span>', ['class' => 'form-control-label'], false) }}
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

                            @if (getMediaFileExit($category, 'category_image'))
                                <div class="col-md-2 mb-2">
                                    @php
                                        $extention = imageExtention(getSingleMedia($category, 'category_image'));
                                    @endphp
                                    <img id="category_image_preview"
                                        src="{{ getSingleMedia($category, 'category_image') }}" alt="#"
                                        class="attachment-image mt-1"
                                        style="background-color:{{ $extention == 'svg' ? $category->color : '' }}">
                                    <a class="text-danger remove-file"
                                        href="{{ route('remove.file', ['id' => $category->id, 'type' => 'category_image']) }}"
                                        data--submit="confirm_form" data--confirmation='true' data--ajax="true"
                                        title='{{ __('messages.remove_file_title', ['name' => __('messages.image')]) }}'
                                        data-title='{{ __('messages.remove_file_title', ['name' => __('messages.image')]) }}'
                                        data-message='{{ __('messages.remove_file_msg') }}'>
                                        <i class="ri-close-circle-line"></i>
                                    </a>
                                </div>
                            @endif


                            <div class="form-group col-md-8">
                                {{ Form::label('relation_id', __('messages.category_relation'), ['class' => 'form-control-label'], false) }}
                                <br />
                                {{ Form::select('relation_id[]', $category_relations, $category->related->pluck('id'), [
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
                                    items='@json($categories)' value='@json($category->parent_id)'
                                    fallback-locale="{{ config('app.fallback_locale') }}"></tree-view>
                            </div>
                        </div>
                        <div class="row">
                            <div class="form-group col-md-6">
                                <div class="custom-control custom-checkbox custom-control-inline">
                                    <!-- <input type="checkbox" name="is_featured" value="1" class="custom-control-input" id="is_featured"> -->
                                    {{ Form::checkbox('is_featured', $category->is_featured, null, ['class' => 'custom-control-input', 'id' => 'is_featured']) }}
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
