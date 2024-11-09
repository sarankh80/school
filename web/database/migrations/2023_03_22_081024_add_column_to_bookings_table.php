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
            $table->decimal('discount_amount', 12, 4)->after('discount')->default(0)->nullable();
            $table->string('coupon_code', 191)->after('coupon_id')->nullable();
            $table->string('currency_code', 191)->after('total_amount')->nullable();
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
            $table->dropColumn('discount_amount');
            $table->dropColumn('coupon_code');
            $table->dropColumn('currency_code');
        });
    }
};
