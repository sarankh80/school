<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateCartRuleCouponUsageTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('cart_rule_coupon_usage', function (Blueprint $table) {
            $table->increments('id');
            $table->integer('times_used')->default(0);

            $table->integer('cart_rule_coupon_id')->unsigned();
            $table->foreign('cart_rule_coupon_id')->references('id')->on('cart_rule_coupons')->onDelete('cascade');

            $table->unsignedBigInteger('customer_id');
            $table->foreign('customer_id')->references('id')->on('users')->onDelete('cascade');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('cart_rule_coupon_usage');
    }
}
