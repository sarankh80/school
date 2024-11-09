<template>
    <div>
        <div class="cart-rule-conditions">
            <div class="attribute">
                <div class="control-group">
                    <select :name="['conditions[' + index + '][attribute]']" class="control" v-model="condition.attribute">
                        <option value="">Choose a condition to add</option>
                        <optgroup v-for='(conditionAttribute, index) in condition_attributes' :label="conditionAttribute.label" v-bind:key="index">
                            <option v-for='(childAttribute, index) in conditionAttribute.children' :value="childAttribute.key" v-bind:key="index">
                                {{ childAttribute.label }}
                            </option>
                        </optgroup>
                    </select>
                </div>
            </div>

            <div class="operator">
                <div class="control-group" v-if="matchedAttribute">
                    <select :name="['conditions[' + index + '][operator]']" class="control" v-model="condition.operator">
                        <option v-for='operator in condition_operators[matchedAttribute.type]' :value="operator.operator"  v-bind:key="operator.index">
                            {{ operator.label }}
                        </option>
                    </select>
                </div>
            </div>

            <div class="value">
                <div v-if="matchedAttribute">
                    <input type="hidden" :name="['conditions[' + index + '][attribute_type]']" v-model="matchedAttribute.type">

                    <div v-if="matchedAttribute.key == 'product|category_ids' || matchedAttribute.key == 'product|category_ids' || matchedAttribute.key == 'product|parent::category_ids'">
                        <tree-view value-field="id" id-field="id" :name-field="'conditions[' + index + '][value]'" input-type="checkbox" :items='matchedAttribute.options' :behavior="'no'" fallback-locale="en"></tree-view>
                    </div>

                    <div v-else>
                        <div class="control-group" v-if="matchedAttribute.type == 'text' || matchedAttribute.type == 'price' || matchedAttribute.type == 'decimal' || matchedAttribute.type == 'integer'">
                            <input class="control" :name="['conditions[' + index + '][value]']" v-model="condition.value"/>
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
                                <option value="1">Yes</option>
                                <option value="0">No</option>
                            </select>
                        </div>

                        <div class="control-group" v-if="matchedAttribute.type == 'select' || matchedAttribute.type == 'radio'">
                            <select :name="['conditions[' + index + '][value]']" class="control" v-model="condition.value" v-if="matchedAttribute.key != 'cart|state'">
                                <option v-for='option in matchedAttribute.options' :value="option.id" v-bind:key="option.index">
                                    {{ option.admin_name }}
                                </option>
                            </select>

                            <select :name="['conditions[' + index + '][value]']" class="control" v-model="condition.value" v-else>
                                <optgroup v-for='option in matchedAttribute.options' :label="option.admin_name" v-bind:key="option.index">
                                    <option v-for='state in option.states' :value="state.code"  v-bind:key="state.index">
                                        {{ state.admin_name }}
                                    </option>
                                </optgroup>
                            </select>
                        </div>

                        <div class="control-group" v-if="matchedAttribute.type == 'multiselect' || matchedAttribute.type == 'checkbox'">
                            <select :name="['conditions[' + index + '][value][]']" class="control" v-model="condition.value" multiple>
                                <option v-for='option in matchedAttribute.options' :value="option.id"  v-bind:key="option.index">
                                    {{ option.admin_name }}
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
    </div>
</template>

<script>
export default {    
    props: ['index', 'condition', 'attribute_route'],

    data: function() {
        return {
            condition_attributes: [],

            attribute_type_indexes: {
                'cart': 0,

                'cart_item': 1,

                'product': 2
            },

            condition_operators: {
                'price': [{
                        'operator': '==',
                        'label': 'Is equal to'
                    }, {
                        'operator': '!=',
                        'label': 'Is not equal to'
                    }, {
                        'operator': '>=',
                        'label': 'Equals or greater than'
                    }, {
                        'operator': '<=',
                        'label': 'Equals or less than'
                    }, {
                        'operator': '>',
                        'label': 'Greater than'
                    }, {
                        'operator': '<',
                        'label': 'Less than'
                    }],
                'decimal': [{
                        'operator': '==',
                        'label': 'Is equal to'
                    }, {
                        'operator': '!=',
                        'label': 'Is not equal to'
                    }, {
                        'operator': '>=',
                        'label': 'Equals or greater than'
                    }, {
                        'operator': '<=',
                        'label': 'Equals or less than'
                    }, {
                        'operator': '>',
                        'label': 'Greater than'
                    }, {
                        'operator': '<',
                        'label': 'Less than'
                    }],
                'integer': [{
                    'operator': '==',
                        'label': 'Is equal to'
                    }, {
                        'operator': '!=',
                        'label': 'Is not equal to'
                    }, {
                        'operator': '>=',
                        'label': 'Equals or greater than'
                    }, {
                        'operator': '<=',
                        'label': 'Equals or less than'
                    }, {
                        'operator': '>',
                        'label': 'Greater than'
                    }, {
                        'operator': '<',
                        'label': 'Less than'
                    }],
                'text': [{
                    'operator': '==',
                        'label': 'Is equal to'
                    }, {
                        'operator': '!=',
                        'label': 'Is not equal to'
                    }, {
                        'operator': '{}',
                        'label': 'Contain'
                    }, {
                        'operator': '!{}',
                        'label': 'Does not contain'
                    }],
                'boolean': [{
                        'operator': '==',
                        'label': 'Is equal to'
                    }, {
                        'operator': '!=',
                        'label': 'Is not equal to'
                    }],
                'date': [{
                    'operator': '==',
                        'label': 'Is equal to'
                    }, {
                        'operator': '!=',
                        'label': 'Is not equal to'
                    }, {
                        'operator': '>=',
                        'label': 'Equals or greater than'
                    }, {
                        'operator': '<=',
                        'label': 'Equals or less than'
                    }, {
                        'operator': '>',
                        'label': 'Greater than'
                    }, {
                        'operator': '<',
                        'label': 'Less than'
                    }],
                'datetime': [{
                        'operator': '==',
                        'label': 'Is equal to'
                    }, {
                        'operator': '!=',
                        'label': 'Is not equal to'
                    }, {
                        'operator': '>=',
                        'label': 'Equals or greater than'
                    }, {
                        'operator': '<=',
                        'label': 'Equals or less than'
                    }, {
                        'operator': '>',
                        'label': 'Greater than'
                    }, {
                        'operator': '<',
                        'label': 'Less than'
                    }],
                'select': [{
                        'operator': '==',
                        'label': 'Is equal to'
                    }, {
                        'operator': '!=',
                        'label': 'Is not equal to'
                    }],
                'radio': [{
                        'operator': '==',
                        'label': 'Is equal to'
                    }, {
                        'operator': '!=',
                        'label': 'Is not equal to'
                    }],
                'multiselect': [{
                        'operator': '{}',
                        'label': 'Contain'
                    }, {
                        'operator': '!{}',
                        'label': 'Does not contain'
                    }],
                'checkbox': [{
                        'operator': '{}',
                        'label': 'Contain'
                    }, {
                        'operator': '!{}',
                        'label': 'Does not contain'
                    }]
            }
        }
    },

    computed: {
        matchedAttribute: function () {
            if (this.condition.attribute == '')
                return;

            let self = this;

            let attributeIndex = this.attribute_type_indexes[this.condition.attribute.split("|")[0]];

            let matchedAttribute = this.condition_attributes[attributeIndex]['children'].filter(function (attribute) {
                return attribute.key == self.condition.attribute;
            });

            if (matchedAttribute[0]['type'] == 'multiselect' || matchedAttribute[0]['type'] == 'checkbox') {
                this.condition.operator = '{}';

                this.condition.value = [];
            }

            return matchedAttribute[0];
        }
    },

    methods: {
        removeCondition: function() {
            this.$emit('onRemoveCondition', this.condition)
        },
    }, 
    mounted () {
        axios
        .get(this.attribute_route)
        .then(response => (this.condition_attributes = response.data))
    }
};
</script>
