<x-master-layout>
    <div class="container-fluid">
        <div class="row">
            <div class="col-lg-12">
                {{ Breadcrumbs::render('create_catalog_rule') }}
            </div>
            <div class="col-lg-12">
                <div class="card">
                    <div class="card-body">
                        <form method="POST" action="{{ route('catalog_rules.store') }}">
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
                                                <input class="control" id="name" name="name"
                                                    value="{{ old('name') }}" />
                                            </div>


                                            <div class="control-group">
                                                {{ Form::label('description', __('messages.description')) }}
                                                <textarea class="control" id="description" name="description">{{ old('description') }}</textarea>
                                            </div>

                                            <div class="control-group">
                                                <label
                                                    for="status">{{ __('messages.promotions.cart-rules.status') }}</label>

                                                <label class="switch">
                                                    <input type="checkbox" id="status" name="status" value="1"
                                                        {{ old('status') ? 'checked' : '' }}>
                                                    <span class="slider round"></span>
                                                </label>
                                            </div>

                                            <div class="control-group multi-select">
                                                <label for="channels"
                                                    class="required">{{ __('messages.promotions.cart-rules.channels') }}</label>

                                                <select class="control" id="channels" name="channels[]"
                                                    multiple="multiple">

                                                    @foreach (core()->getAllChannels() as $channel)
                                                        <option value="{{ $channel->id }}"
                                                            {{ old('channels') && in_array($channel->id, old('channels')) ? 'selected' : '' }}>
                                                            {{ core()->getChannelName($channel) }}
                                                        </option>
                                                    @endforeach

                                                </select>
                                            </div>

                                            <div class="control-group">
                                                <label for="customer_groups"
                                                    class="required">{{ __('messages.promotions.cart-rules.customer-groups') }}</label>

                                                <select class="control" id="customer_groups" name="customer_groups[]"
                                                    multiple="multiple">

                                                    @foreach ($customerGroups as $customerGroup)
                                                        <option value="{{ $customerGroup->id }}"
                                                            {{ old('customer_groups') && in_array($customerGroup->id, old('customer_groups')) ? 'selected' : '' }}>
                                                            {{ $customerGroup->name }}
                                                        </option>
                                                    @endforeach

                                                </select>
                                            </div>

                                            <div class="control-group date">
                                                <label
                                                    for="starts_from">{{ __('messages.promotions.cart-rules.from') }}</label>
                                                <datetime>
                                                    <input type="text" name="starts_from" class="control"
                                                        value="{{ old('starts_from') }}" />
                                                </datetime>
                                            </div>

                                            <div class="control-group date">
                                                {{ Form::label('ends_till', __('messages.promotions.cart-rules.to')) }}
                                                <datetime>
                                                    <input type="text" name="ends_till" class="control"
                                                        value="{{ old('ends_till') }}" />
                                                </datetime>
                                            </div>

                                            <div class="control-group">
                                                {{ Form::label('sort_order', __('messages.promotions.cart-rules.priority')) }}
                                                <input type="text" class="control" id="sort_order" name="sort_order"
                                                    value="{{ old('sort_order') ?? 0 }}" />
                                            </div>

                                        </div>
                                    </accordian>

                                    <condition attribute_route="{{ route('cart_rules.attributes') }}"></condition>

                                    <accordian title="{{ __('messages.promotions.cart-rules.actions') }}"
                                        :active="false">
                                        <div slot="body">
                                            <div class="control-group">
                                                <label for="action_type"
                                                    class="required">{{ __('messages.promotions.cart-rules.action-type') }}</label>

                                                <select class="control" id="action_type" name="action_type">
                                                    <option value="by_percent"
                                                        {{ old('action_type') == 'by_percent' ? 'selected' : '' }}>
                                                        {{ __('messages.promotions.cart-rules.percentage-product-price') }}
                                                    </option>
                                                    <option value="by_fixed"
                                                        {{ old('action_type') == 'by_fixed' ? 'selected' : '' }}>
                                                        {{ __('messages.promotions.cart-rules.fixed-amount') }}
                                                    </option>
                                                    <option value="cart_fixed"
                                                        {{ old('action_type') == 'cart_fixed' ? 'selected' : '' }}>
                                                        {{ __('messages.promotions.cart-rules.fixed-amount-whole-cart') }}
                                                    </option>
                                                    <option value="buy_x_get_y"
                                                        {{ old('action_type') == 'buy_x_get_y' ? 'selected' : '' }}>
                                                        {{ __('messages.promotions.cart-rules.buy-x-get-y-free') }}
                                                    </option>
                                                </select>
                                            </div>

                                            <div class="control-group">
                                                <label for="discount_amount"
                                                    class="required">{{ __('messages.promotions.cart-rules.discount-amount') }}</label>
                                                <input class="control" id="discount_amount" name="discount_amount"
                                                    value="{{ old('discount_amount') ?? 0 }}" />
                                            </div>

                                            <div class="control-group">
                                                <label
                                                    for="discount_quantity">{{ __('messages.promotions.cart-rules.discount-quantity') }}</label>
                                                <input class="control" id="discount_quantity" name="discount_quantity"
                                                    value="{{ old('discount_quantity') ?? 0 }}" />
                                            </div>

                                            <div class="control-group">
                                                <label
                                                    for="discount_step">{{ __('messages.promotions.cart-rules.discount-step') }}</label>
                                                <input class="control" id="discount_step" name="discount_step"
                                                    value="{{ old('discount_step') ?? 0 }}" />
                                            </div>

                                            <div class="control-group">
                                                <label
                                                    for="apply_to_shipping">{{ __('messages.promotions.cart-rules.apply-to-shipping') }}</label>

                                                <select class="control" id="apply_to_shipping"
                                                    name="apply_to_shipping">
                                                    <option value="0"
                                                        {{ !old('apply_to_shipping') ? 'selected' : '' }}>
                                                        {{ __('messages.promotions.cart-rules.no') }}</option>
                                                    <option value="1"
                                                        {{ old('apply_to_shipping') ? 'selected' : '' }}>
                                                        {{ __('messages.promotions.cart-rules.yes') }}</option>
                                                </select>
                                            </div>

                                            <div class="control-group">
                                                <label
                                                    for="free_shipping">{{ __('messages.promotions.cart-rules.free-shipping') }}</label>

                                                <select class="control" id="free_shipping" name="free_shipping">
                                                    <option value="0"
                                                        {{ !old('free_shipping') ? 'selected' : '' }}>
                                                        {{ __('messages.promotions.cart-rules.no') }}</option>
                                                    <option value="1"
                                                        {{ old('free_shipping') ? 'selected' : '' }}>
                                                        {{ __('messages.promotions.cart-rules.yes') }}</option>
                                                </select>
                                            </div>

                                            <div class="control-group">
                                                <label
                                                    for="end_other_rules">{{ __('messages.promotions.cart-rules.end-other-rules') }}</label>

                                                <select class="control" id="end_other_rules" name="end_other_rules">
                                                    <option value="0"
                                                        {{ !old('end_other_rules') ? 'selected' : '' }}>
                                                        {{ __('messages.promotions.cart-rules.no') }}
                                                    </option>

                                                    <option value="1"
                                                        {{ old('end_other_rules') ? 'selected' : '' }}>
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

@push('scripts')
    <script type="text/x-template" id="catalog-rule-template">
        <div>
            <form method="POST" action="{{ route('catalog_rules.store') }}" @submit.prevent="onSubmit">
                <div class="page-header">
                    <div class="page-title">
                        <h1>
                        <i class="icon angle-left-icon back-link"
                            onclick="window.location = '{{ route('catalog_rules.index') }}'"></i>

                            {{ __('promotions.catalog-rules.add-title') }}
                        </h1>
                    </div>

                    <div class="page-action">
                        <button type="submit" class="btn btn-lg btn-primary">
                            {{ __('promotions.catalog-rules.save-btn-title') }}
                        </button>
                    </div>
                </div>

                <div class="page-content">
                    <div class="form-container">
                        @csrf()

                        {!! view_render_event('bagisto.admin.promotions.catalog-rules.create.before') !!}

                        <accordian title="{{ __('promotions.catalog-rules.rule-information') }}" :active="true">
                            <div slot="body">
                                <div class="control-group" :class="[errors.has('name') ? 'has-error' : '']">
                                    <label for="name" class="required">{{ __('promotions.catalog-rules.name') }}</label>
                                    <input v-validate="'required'" class="control" id="name" name="name" data-vv-as="&quot;{{ __('promotions.catalog-rules.name') }}&quot;" value="{{ old('name') }}"/>
                                    <span class="control-error" v-if="errors.has('name')">@{{ errors.first('name') }}</span>
                                </div>

                                <div class="control-group">
                                    <label for="description">{{ __('promotions.catalog-rules.description') }}</label>
                                    <textarea class="control" id="description" name="description">{{ old('description') }}</textarea>
                                </div>

                                <div class="control-group">
                                    <label for="status">{{ __('promotions.catalog-rules.status') }}</label>

                                    <label class="switch">
                                        <input type="checkbox" id="status" name="status" value="1" {{ old('status') ? 'checked' : '' }}>
                                        <span class="slider round"></span>
                                    </label>
                                </div>

                                <div class="control-group multi-select" :class="[errors.has('channels[]') ? 'has-error' : '']">
                                    <label for="channels" class="required">{{ __('promotions.catalog-rules.channels') }}</label>

                                    <select class="control" id="channels" name="channels[]" v-validate="'required'" data-vv-as="&quot;{{ __('promotions.catalog-rules.channels') }}&quot;" multiple="multiple">

                                        @foreach(core()->getAllChannels() as $channel)
                                            <option value="{{ $channel->id }}" {{ old('channels') && in_array($channel->id, old('channels')) ? 'selected' : '' }}>
                                                {{ core()->getChannelName($channel) }}
                                            </option>
                                        @endforeach

                                    </select>

                                    <span class="control-error" v-if="errors.has('channels[]')">@{{ errors.first('channels[]') }}</span>
                                </div>

                                <div class="control-group multi-select" :class="[errors.has('customer_groups[]') ? 'has-error' : '']">
                                    <label for="customer_groups" class="required">{{ __('promotions.catalog-rules.customer-groups') }}</label>

                                    <select class="control" id="customer_groups" name="customer_groups[]" v-validate="'required'" data-vv-as="&quot;{{ __('promotions.catalog-rules.customer-groups') }}&quot;" multiple="multiple">

                                        @foreach(app('App\Repositories\CustomerGroupRepository')->all() as $customerGroup)
                                            <option value="{{ $customerGroup->id }}" {{ old('customer_groups') && in_array($customerGroup->id, old('customer_groups')) ? 'selected' : '' }}>
                                                {{ $customerGroup->name }}
                                            </option>
                                        @endforeach

                                    </select>

                                    <span class="control-error" v-if="errors.has('customer_groups[]')">@{{ errors.first('customer_groups[]') }}</span>
                                </div>


                                <div class="control-group date">
                                    <label for="starts_from">{{ __('promotions.catalog-rules.from') }}</label>
                                    <date>
                                        <input type="text" name="starts_from" class="control" value="{{ old('starts_from') }}"/>
                                    </date>
                                </div>

                                <div class="control-group date">
                                    <label for="ends_till">{{ __('promotions.catalog-rules.to') }}</label>
                                    <date>
                                        <input type="text" name="ends_till" class="control" value="{{ old('ends_till') }}"/>
                                    </date>
                                </div>

                                <div class="control-group">
                                    <label for="sort_order">{{ __('promotions.catalog-rules.priority') }}</label>
                                    <input type="text" class="control" id="sort_order" name="sort_order" value="{{ old('sort_order') ?? 0 }}"/>
                                </div>
                            </div>
                        </accordian>

                        <accordian title="{{ __('promotions.catalog-rules.conditions') }}" :active="false">
                            <div slot="body">
                                <div class="control-group">
                                    <label for="condition_type">{{ __('promotions.catalog-rules.condition-type') }}</label>

                                    <select class="control" id="condition_type" name="condition_type" v-model="condition_type">
                                        <option value="1">{{ __('promotions.catalog-rules.all-conditions-true') }}</option>
                                        <option value="2">{{ __('promotions.catalog-rules.any-condition-true') }}</option>
                                    </select>
                                </div>

                                <catalog-rule-condition-item
                                    v-for='(condition, index) in conditions'
                                    :condition="condition"
                                    :key="index"
                                    :index="index"
                                    @onRemoveCondition="removeCondition($event)">
                                </catalog-rule-condition-item>                                     

                                <button type="button" class="btn btn-lg btn-primary" style="margin-top: 20px;" @click="addCondition">
                                    {{ __('promotions.catalog-rules.add-condition') }}
                                </button>
                            </div>
                        </accordian>

                        <accordian title="{{ __('promotions.catalog-rules.actions') }}" :active="false">
                            <div slot="body">
                                <div class="control-group" :class="[errors.has('action_type') ? 'has-error' : '']">
                                    <label for="action_type" class="required">{{ __('promotions.catalog-rules.action-type') }}</label>

                                    <select class="control" id="action_type" name="action_type" v-validate="'required'" data-vv-as="&quot;{{ __('promotions.catalog-rules.action-type') }}&quot;">
                                        <option value="by_percent" {{ old('action_type') == 'by_percent' ? 'selected' : '' }}>
                                            {{ __('promotions.catalog-rules.percentage-product-price') }}
                                        </option>
                                        <option value="by_fixed" {{ old('action_type') == 'by_fixed' ? 'selected' : '' }}>
                                            {{ __('promotions.catalog-rules.fixed-amount') }}
                                        </option>
                                    </select>

                                    <span class="control-error" v-if="errors.has('action_type')">@{{ errors.first('action_type') }}</span>
                                </div>

                                <div class="control-group" :class="[errors.has('discount_amount') ? 'has-error' : '']">
                                    <label for="discount_amount" class="required">{{ __('promotions.catalog-rules.discount-amount') }}</label>
                                    <input v-validate="'required'" class="control" id="discount_amount" name="discount_amount" data-vv-as="&quot;{{ __('promotions.catalog-rules.discount-amount') }}&quot;" value="{{ old('discount_amount') ?? 0 }}"/>
                                    <span class="control-error" v-if="errors.has('discount_amount')">@{{ errors.first('discount_amount') }}</span>
                                </div>

                                <div class="control-group">
                                    <label for="end_other_rules">{{ __('promotions.catalog-rules.end-other-rules') }}</label>

                                    <select class="control" id="end_other_rules" name="end_other_rules">
                                        <option value="0" {{ ! old('end_other_rules') ? 'selected' : '' }}>
                                            {{ __('promotions.catalog-rules.no') }}
                                        </option>

                                        <option value="1" {{ old('end_other_rules') ? 'selected' : '' }}>
                                            {{ __('promotions.catalog-rules.yes') }}
                                        </option>
                                    </select>
                                </div>
                            </div>
                        </accordian>

                        {!! view_render_event('bagisto.admin.promotions.catalog-rules.create.after') !!}
                    </div>
                </div>
            </form>
        </div>
    </script>

    <script type="text/x-template" id="catalog-rule-condition-item-template">
        <div class="catalog-rule-conditions">
            <div class="attribute">
                <div class="control-group">
                    <select :name="['conditions[' + index + '][attribute]']" class="control" v-model="condition.attribute">
                        <option value="">{{ __('promotions.catalog-rules.choose-condition-to-add') }}</option>
                        <optgroup v-for='(conditionAttribute, index) in condition_attributes' :label="conditionAttribute.label">
                            <option v-for='(childAttribute, index) in conditionAttribute.children' :value="childAttribute.key">
                                @{{ childAttribute.label }}
                            </option>
                        </optgroup>
                    </select>
                </div>
            </div>

            <div class="operator">
                <div class="control-group" v-if="matchedAttribute">
                    <select :name="['conditions[' + index + '][operator]']" class="control" v-model="condition.operator">
                        <option v-for='operator in condition_operators[matchedAttribute.type]' :value="operator.operator">
                            @{{ operator.label }}
                        </option>
                    </select>
                </div>
            </div>

            <div class="value">
                <div v-if="matchedAttribute">
                    <input type="hidden" :name="['conditions[' + index + '][attribute_type]']" v-model="matchedAttribute.type">

                    <div v-if="matchedAttribute.key == 'product|category_ids'">
                        <tree-view value-field="id" id-field="id" :name-field="'conditions[' + index + '][value]'" input-type="checkbox" :items='matchedAttribute.options' :behavior="'no'" fallback-locale="{{ config('app.fallback_locale') }}"></tree-view>
                    </div>

                    <div v-else>
                        <div class="control-group" :class="[errors.has('conditions[' + index + '][value]') ? 'has-error' : '']" v-if="matchedAttribute.type == 'text' || matchedAttribute.type == 'price' || matchedAttribute.type == 'decimal' || matchedAttribute.type == 'integer'">
                            <input v-validate="matchedAttribute.type == 'price' ? 'decimal:2' : '' || matchedAttribute.type == 'decimal' ? 'decimal:2' : '' || matchedAttribute.type == 'integer' ? 'decimal:2' : '' || matchedAttribute.type == 'text' ? 'regex:^([A-Za-z0-9_ \'\-]+)$' : ''" class="control" :name="['conditions[' + index + '][value]']" v-model="condition.value" data-vv-as="&quot;{{ __('promotions.catalog-rules.conditions') }}&quot;"/>
                            <span class="control-error" v-if="errors.has('conditions[' + index + '][value]')" v-text="errors.first('conditions[' + index + '][value]')"></span>
                        </div>

                        <div class="control-group date" v-if="matchedAttribute.type == 'date'">
                            <date>
                                <input class="control" :name="['conditions[' + index + '][value]']" v-model="condition.value"/>
                            </date>
                        </div>

                        <div class="control-group date" v-if="matchedAttribute.type == 'datetime'">
                            <datetime>
                                <input class="control" :name="['conditions[' + index + '][value]']" v-model="condition.value"/>
                            </datetime>
                        </div>

                        <div class="control-group" v-if="matchedAttribute.type == 'boolean'">
                            <select :name="['conditions[' + index + '][value]']" class="control" v-model="condition.value">
                                <option value="1">{{ __('promotions.catalog-rules.yes') }}</option>
                                <option value="0">{{ __('promotions.catalog-rules.no') }}</option>
                            </select>
                        </div>

                        <div class="control-group" v-if="matchedAttribute.type == 'select' || matchedAttribute.type == 'radio'">
                            <select :name="['conditions[' + index + '][value]']" class="control" v-model="condition.value" v-if="matchedAttribute.key != 'catalog|state'">
                                <option v-for='option in matchedAttribute.options' :value="option.id">
                                    @{{ option.admin_name }}
                                </option>
                            </select>

                            <select :name="['conditions[' + index + '][value]']" class="control" v-model="condition.value" v-else>
                                <optgroup v-for='option in matchedAttribute.options' :label="option.admin_name">
                                    <option v-for='state in option.states' :value="state.code">
                                        @{{ state.admin_name }}
                                    </option>
                                </optgroup>
                            </select>
                        </div>

                        <div class="control-group multi-select" v-if="matchedAttribute.type == 'multiselect' || matchedAttribute.type == 'checkbox'">
                            <select :name="['conditions[' + index + '][value][]']" class="control" v-model="condition.value" multiple>
                                <option v-for='option in matchedAttribute.options' :value="option.id">
                                    @{{ option.admin_name }}
                                </option>
                            </select>
                        </div>
                    </div>
                </div>
            </div>

            <div class="actions">
                <i class="icon trash-icon" @click="removeCondition"></i>
            </div>
        </div>
    </script>

    <script>
        Vue.component('catalog-rule', {
            template: '#catalog-rule-template',

            inject: ['$validator'],

            data: function() {
                return {
                    condition_type: 1,

                    conditions: []
                }
            },

            methods: {
                addCondition: function() {
                    this.conditions.push({
                        'attribute': '',
                        'operator': '==',
                        'value': '',
                    });
                },

                removeCondition: function(condition) {
                    let index = this.conditions.indexOf(condition)

                    this.conditions.splice(index, 1)
                },

                onSubmit: function(e) {
                    this.$root.onSubmit(e)
                },

                onSubmit: function(e) {
                    this.$root.onSubmit(e)
                },

                redirectBack: function(fallbackUrl) {
                    this.$root.redirectBack(fallbackUrl)
                }
            }
        });

        Vue.component('catalog-rule-condition-item', {
            template: '#catalog-rule-condition-item-template',

            props: ['index', 'condition'],

            data: function() {
                return {
                    condition_attributes: @json(app('\Webkul\CatalogRule\Repositories\CatalogRuleRepository')->getConditionAttributes()),

                    attribute_type_indexes: {
                        'product': 0
                    },

                    condition_operators: {
                        'price': [{
                            'operator': '==',
                            'label': '{{ __('promotions.catalog-rules.is-equal-to') }}'
                        }, {
                            'operator': '!=',
                            'label': '{{ __('promotions.catalog-rules.is-not-equal-to') }}'
                        }, {
                            'operator': '>=',
                            'label': '{{ __('promotions.catalog-rules.equals-or-greater-than') }}'
                        }, {
                            'operator': '<=',
                            'label': '{{ __('promotions.catalog-rules.equals-or-less-than') }}'
                        }, {
                            'operator': '<=',
                            'label': '{{ __('promotions.catalog-rules.greater-than') }}'
                        }, {
                            'operator': '<=',
                            'label': '{{ __('promotions.catalog-rules.less-than') }}'
                        }],
                        'decimal': [{
                            'operator': '==',
                            'label': '{{ __('promotions.catalog-rules.is-equal-to') }}'
                        }, {
                            'operator': '!=',
                            'label': '{{ __('promotions.catalog-rules.is-not-equal-to') }}'
                        }, {
                            'operator': '>=',
                            'label': '{{ __('promotions.catalog-rules.equals-or-greater-than') }}'
                        }, {
                            'operator': '<=',
                            'label': '{{ __('promotions.catalog-rules.equals-or-less-than') }}'
                        }, {
                            'operator': '>',
                            'label': '{{ __('promotions.catalog-rules.greater-than') }}'
                        }, {
                            'operator': '<',
                            'label': '{{ __('promotions.catalog-rules.less-than') }}'
                        }],
                        'integer': [{
                            'operator': '==',
                            'label': '{{ __('promotions.catalog-rules.is-equal-to') }}'
                        }, {
                            'operator': '!=',
                            'label': '{{ __('promotions.catalog-rules.is-not-equal-to') }}'
                        }, {
                            'operator': '>=',
                            'label': '{{ __('promotions.catalog-rules.equals-or-greater-than') }}'
                        }, {
                            'operator': '<=',
                            'label': '{{ __('promotions.catalog-rules.equals-or-less-than') }}'
                        }, {
                            'operator': '>',
                            'label': '{{ __('promotions.catalog-rules.greater-than') }}'
                        }, {
                            'operator': '<',
                            'label': '{{ __('promotions.catalog-rules.less-than') }}'
                        }],
                        'text': [{
                            'operator': '==',
                            'label': '{{ __('promotions.catalog-rules.is-equal-to') }}'
                        }, {
                            'operator': '!=',
                            'label': '{{ __('promotions.catalog-rules.is-not-equal-to') }}'
                        }, {
                            'operator': '{}',
                            'label': '{{ __('promotions.catalog-rules.contain') }}'
                        }, {
                            'operator': '!{}',
                            'label': '{{ __('promotions.catalog-rules.does-not-contain') }}'
                        }],
                        'boolean': [{
                            'operator': '==',
                            'label': '{{ __('promotions.catalog-rules.is-equal-to') }}'
                        }, {
                            'operator': '!=',
                            'label': '{{ __('promotions.catalog-rules.is-not-equal-to') }}'
                        }],
                        'date': [{
                            'operator': '==',
                            'label': '{{ __('promotions.catalog-rules.is-equal-to') }}'
                        }, {
                            'operator': '!=',
                            'label': '{{ __('promotions.catalog-rules.is-not-equal-to') }}'
                        }, {
                            'operator': '>=',
                            'label': '{{ __('promotions.catalog-rules.equals-or-greater-than') }}'
                        }, {
                            'operator': '<=',
                            'label': '{{ __('promotions.catalog-rules.equals-or-less-than') }}'
                        }, {
                            'operator': '>',
                            'label': '{{ __('promotions.catalog-rules.greater-than') }}'
                        }, {
                            'operator': '<',
                            'label': '{{ __('promotions.catalog-rules.less-than') }}'
                        }],
                        'datetime': [{
                            'operator': '==',
                            'label': '{{ __('promotions.catalog-rules.is-equal-to') }}'
                        }, {
                            'operator': '!=',
                            'label': '{{ __('promotions.catalog-rules.is-not-equal-to') }}'
                        }, {
                            'operator': '>=',
                            'label': '{{ __('promotions.catalog-rules.equals-or-greater-than') }}'
                        }, {
                            'operator': '<=',
                            'label': '{{ __('promotions.catalog-rules.equals-or-less-than') }}'
                        }, {
                            'operator': '>',
                            'label': '{{ __('promotions.catalog-rules.greater-than') }}'
                        }, {
                            'operator': '<',
                            'label': '{{ __('promotions.catalog-rules.less-than') }}'
                        }],
                        'select': [{
                            'operator': '==',
                            'label': '{{ __('promotions.catalog-rules.is-equal-to') }}'
                        }, {
                            'operator': '!=',
                            'label': '{{ __('promotions.catalog-rules.is-not-equal-to') }}'
                        }],
                        'radio': [{
                            'operator': '==',
                            'label': '{{ __('promotions.catalog-rules.is-equal-to') }}'
                        }, {
                            'operator': '!=',
                            'label': '{{ __('promotions.catalog-rules.is-not-equal-to') }}'
                        }],
                        'multiselect': [{
                            'operator': '{}',
                            'label': '{{ __('promotions.catalog-rules.contains') }}'
                        }, {
                            'operator': '!{}',
                            'label': '{{ __('promotions.catalog-rules.does-not-contain') }}'
                        }],
                        'checkbox': [{
                            'operator': '{}',
                            'label': '{{ __('promotions.catalog-rules.contains') }}'
                        }, {
                            'operator': '!{}',
                            'label': '{{ __('promotions.catalog-rules.does-not-contain') }}'
                        }]
                    }
                }
            },

            computed: {
                matchedAttribute: function() {
                    if (this.condition.attribute == '')
                        return;

                    let self = this;

                    let attributeIndex = this.attribute_type_indexes[this.condition.attribute.split("|")[0]];

                    matchedAttribute = this.condition_attributes[attributeIndex]['children'].filter(function(
                        attribute) {
                        return attribute.key == self.condition.attribute;
                    });

                    if (matchedAttribute[0]['type'] == 'multiselect' || matchedAttribute[0]['type'] ==
                        'checkbox') {
                        this.condition.operator = '{}';

                        this.condition.value = [];
                    }

                    return matchedAttribute[0];
                }
            },

            methods: {
                removeCondition: function() {
                    this.$emit('onRemoveCondition', this.condition)
                }
            }
        });
    </script>
@endpush
