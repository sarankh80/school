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
        Schema::table('booking_items', function (Blueprint $table) {
            $table->string('coupon_code')->after('booking_id')->nullable();
            $table->string('name')->after('booking_id')->nullable();
            $table->string('sku')->after('booking_id')->nullable();
            $table->integer('qty_refunded')->after('quantity')->nullable();
            $table->integer('qty_canceled')->after('quantity')->nullable();
            $table->integer('qty_invoiced')->after('quantity')->nullable();
            $table->integer('qty_shipped')->after('quantity')->nullable();
            $table->integer('qty_ordered')->after('quantity')->nullable();
            $table->double('base_price', 22, 4)->after('price')->default(0);
            $table->double('discount_amount', 22, 4)->after('discount')->default(0);
            $table->renameColumn('discount', 'discount_percent');
            $table->double('base_total', 22, 4)->after('total')->default(0);
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::table('booking_items', function (Blueprint $table) {
            $table->dropColumn('coupon_code');
            $table->dropColumn('name');
            $table->dropColumn('name');
            $table->dropColumn('qty_refunded');
            $table->dropColumn('qty_canceled');
            $table->dropColumn('qty_invoiced');
            $table->dropColumn('qty_shipped');
            $table->dropColumn('qty_ordered');
            $table->dropColumn('base_price');
            $table->dropColumn('discount_amount');
            $table->renameColumn('discount_percent', 'discount');
            $table->dropColumn('base_total');
        });    
    }
};
