<div class="row">
        <div class="form-group col-md-4">
            {{ Form::label('sku', __('messages.sku') . ' <span class="text-danger">*</span>', ['class' => 'form-control-label'], false) }}
            {{ Form::text('sku', old('sku'), ['placeholder' => __('messages.sku'), 'class' => 'form-control', 'required', 'wire:model' => 'sku']) }}
            <small class="help-block with-errors text-danger"></small>
        </div>

        <div class="form-group col-md-4">
            {{ Form::label('name', __('messages.name') . ' <span class="text-danger">*</span>', ['class' => 'form-control-label'], false) }}
            {{ Form::text('name', old('name'), ['placeholder' => __('messages.name'), 'class' => 'form-control', 'required', 'wire:model' => 'name']) }}
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
                {{ Form::label($lang['title'], $lang['title'] . ' <span class="text-danger"></span>', ['class' => 'form-control-label'], false) }}
                {{ Form::text($lang['id'], old('name'), ['placeholder' => trans('messages.name'), 'class' => 'form-control', 'wire:model' => '']) }}
                <small class="help-block with-errors text-danger"></small>
            </div>
            @endif
            @endforeach
        @endif
        <div class="form-group col-md-4">
            {{ Form::label('name', __('messages.brand'), ['class' => 'form-control-label'], false) }}
            <br />
            <select name="brand_id" id="brand_id" wire:model="brand_id" class="select2js form-group">
                <option value=''>Choose a brand</option>
                @foreach ($brands as $brand)
                    <option value={{ $brand->id }}>{{ $brand->name }}</option>
                @endforeach
            </select>

        </div>

        <div class="form-group col-md-4">
            {{ Form::label('price', __('messages.price') . ' <span class="text-danger">*</span>', ['class' => 'form-control-label'], false) }}
            {{ Form::number('price', null, ['min' => 0.01, 'step' => 'any', 'placeholder' => __('messages.price'), 'wire:model' => 'price', 'class' => 'form-control', 'required']) }}
        </div>

        <div class="form-group col-md-4">
            {{ Form::label('unit', __('messages.unit') . ' <span class="text-danger">*</span>', ['class' => 'form-control-label'], false) }}
            <br />
            <select name="unit_id" id="unit_id" wire:model="unit_id" required class="select2js form-group">
                <option value=''>Choose a unit</option>
                @foreach ($units as $unit)
                    <option value={{ $unit->id }}>{{ $unit->name }}</option>
                @endforeach
            </select>
        </div>


        <div class="form-group col-md-4">
            {{ Form::label('discount', __('messages.discount') . ' %', ['class' => 'form-control-label']) }}
            {{ Form::number('discount', null, ['min' => 0, 'step' => 'any', 'placeholder' => __('messages.discount'), 'wire:model' => 'discount', 'class' => 'form-control']) }}
        </div>

        <div class="form-group col-md-4">
            <label class="form-control-label" for="service_attachment">{{ __('messages.image') }}
                <span class="text-danger">*</span>
            </label>
            <div class="custom-file">
                <input type="file" name="service_attachment[]" class="custom-file-input"
                    data-file-error="{{ __('messages.files_not_allowed') }}" multiple>
                <label
                    class="custom-file-label">{{ __('messages.choose_file', ['file' => __('messages.attachments')]) }}</label>
            </div>
            <span class="selected_file"></span>
        </div>
        <div class="form-group col-md-4">
            {{ Form::label('duration', __('messages.duration'), ['class' => 'form-control-label'], false) }}
            {{ Form::text('duration', old('duration'), ['placeholder' => __('messages.duration'), 'wire:model' => 'duration', 'class' => 'form-control min-datetimepicker-time']) }}
        </div>
        <div class="form-group col-md-4">
            {{ Form::label('type', __('messages.type') . ' <span class="text-danger">*</span>', ['class' => 'form-control-label'], false) }}
            <select name="type" id="type" wire:model="type" class="form-control" required>
                <option value="service">{{ __('messages.service') }}</option>
                <option value="product">{{ __('messages.product') }}</option>
            </select>
        </div>
        <div class="form-group col-md-4">
            {{ Form::label('status', __('messages.status') . ' <span class="text-danger">*</span>', ['class' => 'form-control-label'], false) }}
            <select name="status" id="status" wire:model="status" class="form-control" required>
                <option value="1">{{ __('messages.active') }}</option>
                <option value="0">{{ __('messages.inactive') }}</option>
            </select>
        </div>
    </div>

    @livewire('services.media', ['service' => $service])

    <div class="row">
        <div class="form-group col-md-12">
            {{ Form::label('description', __('messages.description'), ['class' => 'form-control-label']) }}
            {{ Form::textarea('description', null, ['class' => 'form-control textarea', 'rows' => 3, 'placeholder' => __('messages.description'), 'wire:model' => 'description']) }}
        </div>
        @if(count($language_array) > 0 )
            @foreach($language_array as $lang)
            @if($lang['id']!="en")
            <div class="form-group col-md-12">
                {{ Form::label("description_".$lang['title'], __('messages.description')." ".$lang['title'] . ' <span class="text-danger">*</span>', ['class' => 'form-control-label'], false) }}
                {{ Form::textarea('description_'.$lang['id'], null, ['class' => 'form-control textarea', 'rows' => 3, 'placeholder' => __('messages.description'), 'wire:model' => 'description']) }}
            </div>
            @endif
            @endforeach
        @endif   
        <div class="form-group col-md-6">
            {{ Form::label('included', __('messages.included'), ['class' => 'form-control-label']) }}
            {{ Form::textarea('included', null, ['class' => 'form-control textarea', 'rows' => 3, 'placeholder' => __('messages.included'), 'wire:model' => 'included']) }}
        </div>
        @if(count($language_array) > 0 )
            @foreach($language_array as $lang)
            @if($lang['id']!="en")
            <div class="form-group col-md-6">
                {{ Form::label("included_".$lang['title'], __('messages.included')." ".$lang['title'] . ' <span class="text-danger">*</span>', ['class' => 'form-control-label'], false) }}
                {{ Form::textarea('included_'.$lang['id'], null, ['class' => 'form-control textarea', 'rows' => 3, 'placeholder' => __('messages.included'), 'wire:model' => 'included']) }}
            </div>
            @endif
            @endforeach
        @endif       
        <div class="form-group col-md-6">
            {{ Form::label('excluded', __('messages.excluded'), ['class' => 'form-control-label']) }}
            {{ Form::textarea('excluded', null, ['class' => 'form-control textarea', 'rows' => 3, 'placeholder' => __('messages.excluded'), 'wire:model' => 'excluded']) }}
        </div>
        @if(count($language_array) > 0 )
            @foreach($language_array as $lang)
            @if($lang['id']!="en")
            <div class="form-group col-md-6">
                {{ Form::label("excluded_".$lang['title'], __('messages.excluded')." ".$lang['title'] . ' <span class="text-danger">*</span>', ['class' => 'form-control-label'], false) }}
                {{ Form::textarea('excluded_'.$lang['id'], null, ['class' => 'form-control textarea', 'rows' => 3, 'placeholder' => __('messages.excluded'), 'wire:model' => 'excluded']) }}
            </div>
            @endif
            @endforeach
        @endif     
        <div class="form-group col-md-12">
            <div class="custom-control custom-checkbox custom-control-inline">
                {{ Form::checkbox('is_featured', null, null, ['class' => 'custom-control-input', 'value' => 1, 'id' => 'is_featured', 'wire:model' => 'is_featured']) }}
                <label class="custom-control-label" for="is_featured">{{ __('messages.set_as_featured') }}</label>
            </div>
        </div>
        <div class="form-group col-md-12">
            <div class="custom-control custom-checkbox custom-control-inline">
                {{ Form::checkbox('visible', null, null, ['class' => 'custom-control-input', 'value' => 1, 'checked' => $check_visible, 'id' => 'visible', 'wire:model' => 'visible']) }}
                <label class="custom-control-label" for="visible">{{ __('messages.visible') }}</label>
            </div>
        </div>
        <div class="form-group col-md-12">
            <div class="custom-control custom-checkbox custom-control-inline">
                {{ Form::checkbox('price_estimate', null, null, ['class' => 'custom-control-input', 'value' => 1, 'id' => 'price_estimate', 'wire:model' => 'price_estimate']) }}
                <label class="custom-control-label" for="price_estimate">{{ __('messages.price_estimate') }}</label>
            </div>
        </div>
    </div>
    @section('bottom_script')
        <script>
            $(document).ready(function() {
                window.initSelectCategoryDrop = () => {
                    $('#category_id').select2({
                        placeholder: 'Select a category'
                    });
                }

                window.initSelectBrandDrop = () => {
                    $('#brand_id').select2({
                        placeholder: 'Select a brand',
                        allowClear: true
                    });
                }

                window.initSelectUnitDrop = () => {
                    $('#unit_id').select2({
                        placeholder: 'Select a unit',
                        allowClear: true
                    });
                }

                $('#brand_id').on('change', function(e) {
                    livewire.emit('selectedBrandItem', e.target.value)
                });

                $('#unit_id').on('change', function(e) {
                    livewire.emit('selectedUnitItem', e.target.value)
                });

                window.livewire.on('select2', () => {
                    initSelectCategoryDrop();
                    initSelectBrandDrop();
                    initSelectUnitDrop();
                });
            });
        </script>
    @endsection