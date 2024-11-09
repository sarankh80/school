<x-master-layout>
    <div class="container-fluid">
        <div class="row">
            <div class="col-lg-12">
                {{ Breadcrumbs::render('create_cart_rule') }}
            </div>
            <div class="col-lg-12">
                <div class="card">
                    <div class="card-body">
                        <form method="POST" action="{{ route('cart_rules.update', $cartRule->id) }}">
                            <div class="page-content">
                                <div class="form-container">
                                    @csrf()

                                    {!! view_render_event('bagisto.admin.promotions.cart-rules.create.before') !!}

                                    <accordian title="{{ __('messages.promotions.cart-rules.rule-information') }}"
                                        :active="true">
                                        <div slot="body">
                                            <div class="control-group">
                                                <label for="name"
                                                    class="required">{{ __('messages.promotions.cart-rules.name') }}</label>
                                                <input v-validate="'required'" class="control" id="name"
                                                    name="name" value="{{ old('name', $cartRule->name) }}" />

                                            </div>


                                            <div class="control-group">
                                                {{ Form::label('description', __('messages.description')) }}
                                                <textarea class="control" id="description" name="description">{{ old('description', $cartRule->description) }}</textarea>
                                            </div>

                                            <div class="control-group">
                                                <label
                                                    for="status">{{ __('messages.promotions.cart-rules.status') }}</label>

                                                <label class="switch">
                                                    <input type="checkbox" id="status" name="status" value="1"
                                                        {{ old('status', $cartRule->status) ? 'checked' : '' }}>
                                                    <span class="slider round"></span>
                                                </label>
                                            </div>

                                            <div class="control-group multi-select">
                                                <label for="channels"
                                                    class="required">{{ __('messages.promotions.cart-rules.channels') }}</label>

                                                @php
                                                    $selectedOptionIds = old('channels') ?: $cartRule->channels->pluck('id')->toArray();
                                                @endphp

                                                <select class="control" id="channels" name="channels[]"
                                                    multiple="multiple">

                                                    @foreach (core()->getAllChannels() as $channel)
                                                        <option value="{{ $channel->id }}"
                                                            {{ in_array($channel->id, $selectedOptionIds) ? 'selected' : '' }}>
                                                            {{ core()->getChannelName($channel) }}
                                                        </option>
                                                    @endforeach

                                                </select>
                                            </div>

                                            <div class="control-group">
                                                <label for="customer_groups"
                                                    class="required">{{ __('messages.promotions.cart-rules.customer-groups') }}</label>

                                                @php
                                                    $selectedOptionIds = old('customer_groups') ?: $cartRule->customer_groups->pluck('id')->toArray();
                                                @endphp

                                                <select class="control" id="customer_groups" name="customer_groups[]"
                                                    multiple="multiple">

                                                    @foreach ($customerGroups as $customerGroup)
                                                        <option value="{{ $customerGroup->id }}"
                                                            {{ in_array($customerGroup->id, $selectedOptionIds) ? 'selected' : '' }}>
                                                            {{ $customerGroup->name }}
                                                        </option>
                                                    @endforeach

                                                </select>
                                            </div>

                                            <coupon-type type="{{ $cartRule->coupon_type }}"
                                                auto_generation="{{ $cartRule->use_auto_generation }}"
                                                code="{{ $cartRule->coupon_code }}"
                                                per_coupon="{{ $cartRule->uses_per_coupon }}"></coupon-type>

                                            <div class="control-group">
                                                <label
                                                    for="usage_per_customer">{{ __('messages.promotions.cart-rules.uses-per-customer') }}</label>
                                                <input class="control" id="usage_per_customer" name="usage_per_customer"
                                                    value="{{ old('usage_per_customer', $cartRule->usage_per_customer) }}" />
                                                <span
                                                    class="control-info">{{ __('messages.promotions.cart-rules.uses-per-customer-control-info') }}</span>
                                            </div>

                                            <div class="control-group date">
                                                <label
                                                    for="starts_from">{{ __('messages.promotions.cart-rules.from') }}</label>
                                                <datetime>
                                                    <input type="text" name="starts_from" class="control"
                                                        value="{{ old('starts_from', $cartRule->starts_from) }}" />
                                                </datetime>
                                            </div>

                                            <div class="control-group date">
                                                {{ Form::label('ends_till', __('messages.promotions.cart-rules.to')) }}
                                                <datetime>
                                                    <input type="text" name="ends_till" class="control"
                                                        value="{{ old('ends_till', $cartRule->ends_till) }}" />
                                                </datetime>
                                            </div>

                                            <div class="control-group">
                                                {{ Form::label('sort_order', __('messages.promotions.cart-rules.priority')) }}
                                                <input type="text" class="control" id="sort_order" name="sort_order"
                                                    value="{{ old('sort_order', $cartRule->sort_order) ?? 0 }}" />
                                            </div>

                                        </div>
                                    </accordian>

                                    <condition condition_route="{{ route('cart_rules.conditions', $cartRule->id) }}"
                                        attribute_route="{{ route('cart_rules.attributes') }}"></condition>

                                    <accordian title="{{ __('messages.promotions.cart-rules.actions') }}"
                                        :active="false">
                                        <div slot="body">
                                            <div class="control-group">
                                                <label for="action_type"
                                                    class="required">{{ __('messages.promotions.cart-rules.action-type') }}</label>

                                                <select class="control" id="action_type" name="action_type">
                                                    <option value="by_percent"
                                                        {{ old('action_type', $cartRule->action_type) == 'by_percent' ? 'selected' : '' }}>
                                                        {{ __('messages.promotions.cart-rules.percentage-product-price') }}
                                                    </option>
                                                    <option value="by_fixed"
                                                        {{ old('action_type', $cartRule->action_type) == 'by_fixed' ? 'selected' : '' }}>
                                                        {{ __('messages.promotions.cart-rules.fixed-amount') }}
                                                    </option>
                                                    <option value="cart_fixed"
                                                        {{ old('action_type', $cartRule->action_type) == 'cart_fixed' ? 'selected' : '' }}>
                                                        {{ __('messages.promotions.cart-rules.fixed-amount-whole-cart') }}
                                                    </option>
                                                    <option value="buy_x_get_y"
                                                        {{ old('action_type', $cartRule->action_type) == 'buy_x_get_y' ? 'selected' : '' }}>
                                                        {{ __('messages.promotions.cart-rules.buy-x-get-y-free') }}
                                                    </option>
                                                </select>
                                            </div>

                                            <div class="control-group">
                                                <label for="discount_amount"
                                                    class="required">{{ __('messages.promotions.cart-rules.discount-amount') }}</label>
                                                <input class="control" id="discount_amount" name="discount_amount"
                                                    value="{{ old('discount_amount', $cartRule->discount_amount) ?? 0 }}" />
                                            </div>

                                            <div class="control-group">
                                                <label
                                                    for="discount_quantity">{{ __('messages.promotions.cart-rules.discount-quantity') }}</label>
                                                <input class="control" id="discount_quantity" name="discount_quantity"
                                                    value="{{ old('discount_quantity', $cartRule->discount_quantity) ?? 0 }}" />
                                            </div>

                                            <div class="control-group">
                                                <label
                                                    for="discount_step">{{ __('messages.promotions.cart-rules.discount-step') }}</label>
                                                <input class="control" id="discount_step" name="discount_step"
                                                    value="{{ old('discount_step', $cartRule->discount_step) ?? 0 }}" />
                                            </div>

                                            <div class="control-group">
                                                <label
                                                    for="apply_to_shipping">{{ __('messages.promotions.cart-rules.apply-to-shipping') }}</label>

                                                <select class="control" id="apply_to_shipping"
                                                    name="apply_to_shipping">
                                                    <option value="0"
                                                        {{ !old('apply_to_shipping', $cartRule->apply_to_shipping) ? 'selected' : '' }}>
                                                        {{ __('messages.promotions.cart-rules.no') }}</option>
                                                    <option value="1"
                                                        {{ old('apply_to_shipping', $cartRule->apply_to_shipping) ? 'selected' : '' }}>
                                                        {{ __('messages.promotions.cart-rules.yes') }}</option>
                                                </select>
                                            </div>

                                            <div class="control-group">
                                                <label
                                                    for="free_shipping">{{ __('messages.promotions.cart-rules.free-shipping') }}</label>

                                                <select class="control" id="free_shipping" name="free_shipping">
                                                    <option value="0"
                                                        {{ !old('free_shipping', $cartRule->free_shipping) ? 'selected' : '' }}>
                                                        {{ __('messages.promotions.cart-rules.no') }}</option>
                                                    <option value="1"
                                                        {{ old('free_shipping', $cartRule->free_shipping) ? 'selected' : '' }}>
                                                        {{ __('messages.promotions.cart-rules.yes') }}</option>
                                                </select>
                                            </div>

                                            <div class="control-group">
                                                <label
                                                    for="end_other_rules">{{ __('messages.promotions.cart-rules.end-other-rules') }}</label>

                                                <select class="control" id="end_other_rules" name="end_other_rules">
                                                    <option value="0"
                                                        {{ !old('end_other_rules', $cartRule->end_other_rules) ? 'selected' : '' }}>
                                                        {{ __('messages.promotions.cart-rules.no') }}
                                                    </option>

                                                    <option value="1"
                                                        {{ old('end_other_rules', $cartRule->end_other_rules) ? 'selected' : '' }}>
                                                        {{ __('messages.promotions.cart-rules.yes') }}
                                                    </option>
                                                </select>
                                            </div>
                                        </div>
                                    </accordian>
                                    {!! view_render_event('bagisto.admin.promotions.cart-rules.create.after') !!}
                                </div>
                            </div>
                            <div class="page-footer">
                                <div class="page-action">
                                    {{ Form::submit(__('messages.save'), ['class' => 'btn btn-md btn-primary float-right']) }}
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</x-master-layout>
