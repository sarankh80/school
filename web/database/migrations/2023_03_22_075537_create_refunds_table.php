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
        Schema::create('refunds', function (Blueprint $table) {
            $table->id();
            $table->string('state')->nullable();
            $table->integer('total_qty')->nullable();

            $table->string('currency_code')->nullable();

            $table->decimal('adjustment_refund', 12, 4)->default(0)->nullable();
            $table->decimal('base_adjustment_refund', 12, 4)->default(0)->nullable();

            $table->decimal('adjustment_fee', 12, 4)->default(0)->nullable();
            $table->decimal('base_adjustment_fee', 12, 4)->default(0)->nullable();

            $table->decimal('sub_total', 12, 4)->default(0)->nullable();
            $table->decimal('base_sub_total', 12, 4)->default(0)->nullable();

            $table->decimal('grand_total', 12, 4)->default(0)->nullable();
            $table->decimal('base_grand_total', 12, 4)->default(0)->nullable();

            $table->decimal('shipping_amount', 12, 4)->default(0)->nullable();
            $table->decimal('base_shipping_amount', 12, 4)->default(0)->nullable();

            $table->decimal('tax_amount', 12, 4)->default(0)->nullable();
            $table->decimal('base_tax_amount', 12, 4)->default(0)->nullable();

            $table->decimal('discount_percent', 12, 4)->default(0)->nullable();
            $table->decimal('discount_amount', 12, 4)->default(0)->nullable();
            $table->decimal('base_discount_amount', 12, 4)->default(0)->nullable();
            
            $table->unsignedBigInteger('booking_id');
            $table->foreign('booking_id')->references('id')->on('bookings')->onDelete('cascade');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('refunds');
    }
};
