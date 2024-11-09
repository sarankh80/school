{{ Form::open(['route' => ['sliders.destroy', $slider->id], 'method' => 'delete', 'data--submit' => 'slider' . $slider->id]) }}
<div class="d-flex justify-content-end align-items-center">
    @if (!$slider->trashed())
        @can('slider edit')
            <a class=" mr-2" href="{{ route('sliders.edit', $slider->id) }}"
                title="{{ __('messages.update_form_title', ['form' => __('messages.slider')]) }}"><i
                    class="fas fa-pen text-secondary"></i></a>
        @endcan
        @can('slider delete')
            <a class="mr-2" href="javascript:void(0)" data--submit="slider{{ $slider->id }}" data--confirmation='true'
                data-title="{{ __('messages.delete_form_title', ['form' => __('messages.slider')]) }}"
                title="{{ __('messages.delete_form_title', ['form' => __('messages.slider')]) }}"
                data-message='{{ __('messages.delete_msg') }}'>
                <i class="far fa-trash-alt text-danger"></i>
            </a>
        @endif
        @endif
        @if (auth()->user()->hasAnyRole(['admin']) && $slider->trashed())
            <a href="{{ route('sliders.action', ['id' => $slider->id, 'type' => 'restore']) }}"
                title="{{ __('messages.restore_form_title', ['form' => __('messages.slider')]) }}"
                data--submit="confirm_form" data--confirmation='true' data--ajax='true'
                data-title="{{ __('messages.restore_form_title', ['form' => __('messages.slider')]) }}"
                data-message='{{ __('messages.restore_msg') }}' data-datatable="reload" class="mr-2">
                <i class="fas fa-redo text-secondary"></i>
            </a>
            <a href="{{ route('sliders.action', ['id' => $slider->id, 'type' => 'forcedelete']) }}"
                title="{{ __('messages.forcedelete_form_title', ['form' => __('messages.slider')]) }}"
                data--submit="confirm_form" data--confirmation='true' data--ajax='true'
                data-title="{{ __('messages.forcedelete_form_title', ['form' => __('messages.slider')]) }}"
                data-message='{{ __('messages.forcedelete_msg') }}' data-datatable="reload" class="mr-2">
                <i class="far fa-trash-alt text-danger"></i>
            </a>
        @endif
    </div>
    {{ Form::close() }}
