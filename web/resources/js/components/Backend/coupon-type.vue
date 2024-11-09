<template>
    <div>
        <div class="control-group">
            <label for="coupon_type" class="required">Coupon Type</label>
            <select v-model="coupon_type" class="control" id="coupon_type" name="coupon_type" v-validate="'required'" data-vv-as="Coupon Type">
                <option value="0">No Coupon</option>
                <option value="1">Specific Coupon</option>
            </select>
        </div>
        <div v-if="parseInt(coupon_type)">
            <div class="control-group">
                <label for="use_auto_generation"
                    class="required">Auto Generate Coupon</label>

                <select class="control" v-validate="'required'" v-model="use_auto_generation" id="use_auto_generation" name="use_auto_generation">
                    <option value="0">No</option>
                    <option value="1">Yes</option>
                </select>
            </div>
            <div v-if="! parseInt(use_auto_generation)">
                <div class="control-group">
                    <label for="coupon_code" class="required">Coupon Code</label>
                    <input class="control" v-model="coupon_code" id="coupon_code" name="coupon_code" />
                </div>
            </div>

            <div class="control-group">
                <label for="uses_per_coupon">Uses Per Coupon</label>
                <input v-validate="'numeric'" v-model="uses_per_coupon" class="control" id="uses_per_coupon" name="uses_per_coupon"/>
            </div>
        </div>
    </div>
</template>

<script>
export default {   
    props: {
        type: String,
        auto_generation: String,
        code: String,
        per_coupon: String,
    },

    data: function() {
        return {
            coupon_type: this.type,

            use_auto_generation: this.auto_generation,

            coupon_code: this.code,

            uses_per_coupon: this.per_coupon
        }
    }
};
</script>
