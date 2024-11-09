<div>
    <div class="control-group">
        <label for="coupon_type" class="required">{{ __('admin::app.promotions.cart-rules.coupon-type') }}</label>

        <select class="control" id="coupon_type" wire:model="coupon_type">
            <option value="0" {{ old('coupon_type') == 0 ? 'selected' : '' }}>
                {{ __('admin::app.promotions.cart-rules.no-coupon') }}
            </option>
            <option value="1" {{ old('coupon_type') == 1 ? 'selected' : '' }}>
                {{ __('admin::app.promotions.cart-rules.specific-coupon') }}
            </option>
        </select>
    </div>
    @if ($coupon_type)
        <div class="control-group">
            <label for="use_auto_generation"
                class="required">{{ __('admin::app.promotions.cart-rules.auto-generate-coupon') }}</label>

            <select class="control" wire:model="use_auto_generation" id="use_auto_generation"
                name="use_auto_generation">
                <option value="0">
                    {{ __('admin::app.promotions.cart-rules.no') }}
                </option>
                <option value="1">
                    {{ __('admin::app.promotions.cart-rules.yes') }}
                </option>
            </select>
        </div>

        <div>
            <div class="control-group">
                <label for="coupon_code"
                    class="required">{{ __('admin::app.promotions.cart-rules.coupon-code') }}</label>
                <input class="control" wire:model="coupon_code" id="coupon_code" name="coupon_code"
                    value="{{ old('coupon_code') }}" />
            </div>
        </div>

        <div class="control-group">
            <label for="uses_per_coupon">Uses Per Coupon</label>
            <input class="control" id="uses_per_coupon" name="uses_per_coupon" value="{{ old('uses_per_coupon') }}" />
        </div>
    @endif
</div>

@section('bottom_script')
    <script>
        $(document).on('change', '#coupon_type', function(e) {
            livewire.emit('selectedCouponType', e.target.value);
        })
    </script>
@endsection
