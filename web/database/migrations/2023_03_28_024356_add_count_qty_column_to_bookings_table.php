<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::table('bookings', function (Blueprint $table) {
            $table->integer('total_item_count')->after('quantity')->default(0)->nullable();
            $table->integer('total_qty_ordered')->after('quantity')->default(0)->nullable();
            $table->integer('cart_id')->after('provider_id')->nullable();            
            $table->string('applied_cart_rule_ids')->after('provider_id')->nullable();
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::table('bookings', function (Blueprint $table) {
            $table->dropColumn('total_item_count');
            $table->dropColumn('total_qty_ordered');
            $table->dropColumn('applied_cart_rule_ids');
            $table->dropColumn('cart_id');
        });
    }
};
