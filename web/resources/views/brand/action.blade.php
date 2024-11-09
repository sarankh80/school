{{ Form::open(['route' => ['brands.destroy', $brand->id], 'method' => 'delete', 'data--submit' => 'brand' . $brand->id]) }}
<div class="d-flex justify-content-end align-items-center">
    @if (!$brand->trashed())
        @can('brand edit')
            <a class="mr-2" href="{{ route('brands.edit', $brand->id) }}"
                title="{{ __('messages.update_form_title', ['form' => __('messages.brand')]) }}"><i
                    class="fas fa-pen text-secondary"></i></a>
        @endcan

        @can('brand delete')
            <a class="mr-2" href="javascript:void(0)" data--submit="brand{{ $brand->id }}" data--confirmation='true'
                data-title="{{ __('messages.delete_form_title', ['form' => __('messages.brand')]) }}"
                title="{{ __('messages.delete_form_title', ['form' => __('messages.brand')]) }}"
                data-message='{{ __('messages.delete_msg') }}'>
                <i class="far fa-trash-alt text-danger"></i>
            </a>
        @endcan
    @endif
    @if (auth()->user()->hasAnyRole(['admin']) && $brand->trashed())
        <a href="{{ route('brand.action', ['id' => $brand->id, 'type' => 'restore']) }}"
            title="{{ __('messages.restore_form_title', ['form' => __('messages.brand')]) }}"
            data--submit="confirm_form" data--confirmation='true' data--ajax='true'
            data-title="{{ __('messages.restore_form_title', ['form' => __('messages.brand')]) }}"
            data-message='{{ __('messages.restore_msg') }}' data-datatable="reload" class="mr-2">
            <i class="fas fa-redo text-secondary"></i>
        </a>
        <a href="{{ route('brand.action', ['id' => $brand->id, 'type' => 'forcedelete']) }}"
            title="{{ __('messages.forcedelete_form_title', ['form' => __('messages.brand')]) }}"
            data--submit="confirm_form" data--confirmation='true' data--ajax='true'
            data-title="{{ __('messages.forcedelete_form_title', ['form' => __('messages.brand')]) }}"
            data-message='{{ __('messages.forcedelete_msg') }}' data-datatable="reload" class="mr-2">
            <i class="far fa-trash-alt text-danger"></i>
        </a>
    @endif
</div>
{{ Form::close() }}
