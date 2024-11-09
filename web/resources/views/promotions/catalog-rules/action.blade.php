{{ Form::open(['route' => ['catalog_rules.delete', $catalogRule->id], 'method' => 'delete', 'data--submit' => 'cart_rule' . $catalogRule->id]) }}
<div class="d-flex justify-content-end align-items-center">
    @can('catalog rule edit')
        <a class="mr-2" href="{{ route('catalog_rules.edit', $catalogRule->id) }}"
            title="{{ __('messages.update_form_title', ['form' => __('messages.cart-rules')]) }}"><i
                class="fas fa-pen text-secondary"></i></a>
    @endcan

    @can('catalog rule delete')
        <a class="mr-2" href="javascript:void(0)" data--submit="cart_rule{{ $catalogRule->id }}" data--confirmation='true'
            data-title="{{ __('messages.delete_form_title', ['form' => __('messages.cart-rules')]) }}"
            title="{{ __('messages.delete_form_title', ['form' => __('messages.cart-rules')]) }}"
            data-message='{{ __('messages.delete_msg') }}'>
            <i class="far fa-trash-alt text-danger"></i>
        </a>
    @endcan
</div>
{{ Form::close() }}
