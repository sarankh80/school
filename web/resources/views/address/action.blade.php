{{ Form::open(['route' => ['addresses.destroy', $address->id], 'method' => 'delete', 'data--submit' => 'providertype' . $address->id]) }}
<div class="d-flex justify-content-end align-items-center">
    @can('provideraddress edit')
        <a class="mr-2" href="{{ route('addresses.edit', $address->id) }}"
            title="{{ __('messages.update_form_title', ['form' => __('messages.provider_address')]) }}"><i
                class="fas fa-pen text-secondary"></i></a>
    @endcan
    @can('provideraddress delete')
        <a class="mr-2 text-danger" href="javascript:void(0)" data--submit="providertype{{ $address->id }}"
            data--confirmation='true'
            data-title="{{ __('messages.delete_form_title', ['form' => __('messages.provider_address')]) }}"
            title="{{ __('messages.delete_form_title', ['form' => __('messages.address')]) }}"
            data-message='{{ __('messages.delete_msg') }}'>
            <i class="far fa-trash-alt"></i>
        </a>
    @endcan
</div>
{{ Form::close() }}
