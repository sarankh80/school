<template>
    <div>
        <accordian title="Conditions"
            :active="false">
            <div slot="body">
                <div class="control-group">
                    <label
                        for="condition_type">Condition Type</label>

                    <select class="control" id="condition_type" name="condition_type">
                        <option value="1">All Condition are True</option>
                        <option value="2">Any Condition is True</option>
                    </select>
                </div>

                <cart-rule-condition-item v-for='(condition, index) in conditions'
                    :condition="condition" :key="index" :index="index"
                    :attribute_route= "attribute_route"
                    @onRemoveCondition="removeCondition($event)">
                </cart-rule-condition-item>
                <button type="button" class="btn btn-lg btn-primary" @click="addCondition"
                    style="margin-top: 20px;">
                    Add Condition
                </button>
            </div>
        </accordian>
    </div>
</template>

<script>
export default {  
    props: {
        attribute_route: String,
        condition_route: String,
    },
  
    data: function() {
        return {
            conditions: [],

            action_type: "by_percent"
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

        redirectBack: function(fallbackUrl) {
            this.$root.redirectBack(fallbackUrl)
        }
    },

    mounted () {
        if(this.condition_route == 'undefined')
            return;

        axios
        .get(this.condition_route)
        .then(response => {
            console.log(response.data);
            this.conditions = response.data;
        })
    }
};
</script>
