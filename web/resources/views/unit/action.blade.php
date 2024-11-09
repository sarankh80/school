{{ Form::open(['route' => ['units.destroy', $unit->id], 'method' => 'delete', 'data--submit' => 'unit' . $unit->id]) }}
<div class="d-flex justify-content-end align-items-center">
    @if (!$unit->trashed())
        @can('unit edit')
            <a class="mr-2" href="{{ route('units.edit', $unit->id) }}"
                title="{{ __('messages.update_form_title', ['form' => __('messages.unit')]) }}"><i
                    class="fas fa-pen text-secondary"></i></a>
        @endcan

        @can('unit delete')
            <a class="mr-2" href="javascript:void(0)" data--submit="unit{{ $unit->id }}" data--confirmation='true'
                data-title="{{ __('messages.delete_form_title', ['form' => __('messages.unit')]) }}"
                title="{{ __('messages.delete_form_title', ['form' => __('messages.unit')]) }}"
                data-message='{{ __('messages.delete_msg') }}'>
                <i class="far fa-trash-alt text-danger"></i>
            </a>
        @endcan
    @endif
    @if (auth()->user()->hasAnyRole(['admin']) && $unit->trashed())
        <a href="{{ route('units.action', ['id' => $unit->id, 'type' => 'restore']) }}"
            title="{{ __('messages.restore_form_title', ['form' => __('messages.unit')]) }}" data--submit="confirm_form"
            data--confirmation='true' data--ajax='true'
            data-title="{{ __('messages.restore_form_title', ['form' => __('messages.unit')]) }}"
            data-message='{{ __('messages.restore_msg') }}' data-datatable="reload" class="mr-2">
            <i class="fas fa-redo text-secondary"></i>
        </a>
        <a href="{{ route('units.action', ['id' => $unit->id, 'type' => 'forcedelete']) }}"
            title="{{ __('messages.forcedelete_form_title', ['form' => __('messages.unit')]) }}"
            data--submit="confirm_form" data--confirmation='true' data--ajax='true'
            data-title="{{ __('messages.forcedelete_form_title', ['form' => __('messages.unit')]) }}"
            data-message='{{ __('messages.forcedelete_msg') }}' data-datatable="reload" class="mr-2">
            <i class="far fa-trash-alt text-danger"></i>
        </a>
    @endif
</div>
{{ Form::close() }}
