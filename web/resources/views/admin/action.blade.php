{{ Form::open(['route' => ['admins.destroy', $admin->id], 'method' => 'delete', 'data--submit' => 'user' . $admin->id]) }}
<div class="d-flex justify-content-end align-items-center">
    @if (!$admin->trashed())
        @can('user view')
            <a class="mr-2" href="{{ route('admins.show', $admin->id) }}"><i class="far fa-eye text-secondary"></i></a>
        @endcan
        @can('user edit')
            <a class="mr-2" href="{{ route('admins.edit', $admin->id) }}"
                title="{{ __('messages.update_form_title', ['form' => __('messages.user')]) }}"><i
                    class="fas fa-pen text-secondary"></i></a>
        @endcan
        @can('user delete')
            <a class="mr-2 text-danger" href="javascript:void(0)" data--submit="user{{ $admin->id }}"
                data--confirmation='true'
                data-title="{{ __('messages.delete_form_title', ['form' => __('messages.user')]) }}"
                title="{{ __('messages.delete_form_title', ['form' => __('messages.user')]) }}"
                data-message='{{ __('messages.delete_msg') }}'>
                <i class="far fa-trash-alt"></i>
            </a>
        @endcan
    @endif
    @if (auth()->user()->hasAnyRole(['admin']) && $admin->trashed())
        <a href="{{ route('users.action', ['id' => $admin->id, 'type' => 'restore']) }}"
            title="{{ __('messages.restore_form_title', ['form' => __('messages.user')]) }}" data--submit="confirm_form"
            data--confirmation='true' data--ajax='true'
            data-title="{{ __('messages.restore_form_title', ['form' => __('messages.user')]) }}"
            data-message='{{ __('messages.restore_msg') }}' data-datatable="reload" class=" mr-2">
            <i class="fas fa-redo text-secondary"></i>
        </a>
        <a href="{{ route('users.action', ['id' => $admin->id, 'type' => 'forcedelete']) }}"
            title="{{ __('messages.forcedelete_form_title', ['form' => __('messages.user')]) }}"
            data--submit="confirm_form" data--confirmation='true' data--ajax='true'
            data-title="{{ __('messages.forcedelete_form_title', ['form' => __('messages.user')]) }}"
            data-message='{{ __('messages.forcedelete_msg') }}' data-datatable="reload" class="mr-2">
            <i class="far fa-trash-alt text-danger"></i>
        </a>
    @endif
</div>
{{ Form::close() }}