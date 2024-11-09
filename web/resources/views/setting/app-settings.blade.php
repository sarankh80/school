{{ Form::model($settings, ['method' => 'POST','route' => ['saveAppDownload'],'enctype'=>'multipart/form-data','data-toggle'=>'validator']) }}
<div class="row">
    <div class="col-lg-6">
        <div class="form-group">
            <label for="" class="col-sm-6 form-control-label">{{ __('messages.title') }}</label>
            <div class="col-sm-12">
                {{ Form::text('title', null, ['class'=>"form-control" ,'placeholder'=> __('messages.title') ]) }}
            </div>
        </div>
    </div>
    <div class="col-lg-6">
        <div class="form-group">
            <label for="" class="col-sm-6 form-control-label">{{ __('messages.description') }}</label>
            <div class="col-sm-12">
                {{ Form::textarea('description', null, ['class'=>"form-control" ,'placeholder'=> __('messages.description') ]) }}
            </div>
        </div>
    </div>
    <div class="col-lg-6">
        <div class="form-group">
            <label for="" class="col-sm-6 form-control-label">{{ __('messages.playstore_url') }}</label>
            <div class="col-sm-12">
                {{ Form::text('playstore_url', null, ['class'=>"form-control" ,'placeholder'=> __('messages.playstore_url') ]) }}
            </div>
        </div>
    </div>
    <div class="col-lg-6">
        <div class="form-group">
            <label for="" class="col-sm-6 form-control-label">{{ __('messages.appstore_url') }}</label>
            <div class="col-sm-12">
                {{ Form::text('appstore_url', null, ['class'=>"form-control" ,'placeholder'=> __('messages.appstore_url') ]) }}
            </div>
        </div>
    </div>
    <div class="form-group">
        <label for="avatar" class="col-sm-3 form-control-label">{{ __('messages.logo') }}</label>
        <div class="col-sm-12">
            <div class="row">
                <div class="col-sm-4">
                    <img src="{{ getSingleMedia($settings,'app_image') }}" width="100"  id="app_image_preview" alt="app_image" class="image app_image app_image_preview">
                    @if(getMediaFileExit($settings, 'app_image'))
                        <a class="text-danger remove-file" href="{{ route('remove.file', ['id' => $settings->id, 'type' => 'app_image']) }}"
                            data--submit="confirm_form"
                            data--confirmation='true'
                            data--ajax="true"
                            title='{{ __("messages.remove_file_title" , ["name" =>  __("messages.image") ]) }}'
                            data-title='{{ __("messages.remove_file_title" , ["name" =>  __("messages.image") ]) }}'
                            data-message='{{ __("messages.remove_file_msg") }}'>
                            <i class="ri-close-circle-line"></i>
                        </a>
                    @endif
                </div>
                <div class="col-sm-8">
                    <div class="custom-file col-md-12">
                        {{ Form::file('app_image', ['class'=>"custom-file-input custom-file-input-sm detail" , 'id'=>"app_image" , 'lang'=>"en" , 'accept'=>"image/*"]) }}
                        <label class="custom-file-label" for="app_image">{{ __('messages.image') }}</label>
                    </div>
                </div>
            </div>

        </div>
    </div>
    <div class="col-lg-12"> 
        <div class="form-group">
            <div class="col-md-offset-3 col-sm-12 ">
                {{ Form::submit(__('messages.save'), ['class'=>"btn btn-md btn-primary float-md-right"]) }}
            </div>
        </div>
     </div>
</div>
{{ Form::close() }}