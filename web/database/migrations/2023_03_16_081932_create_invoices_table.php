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
        Schema::create('invoices', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('booking_id');
            $table->unsignedBigInteger('provider_id');
            $table->unsignedBigInteger('customer_id');
            $table->unsignedBigInteger('address_id');

            $table->integer('total_qty')->nullable();

            $table->string('currency_code')->nullable();

            $table->decimal('sub_total', 12, 4)->default(0)->nullable();

            $table->decimal('grand_total', 12, 4)->default(0)->nullable();

            $table->decimal('shipping_amount', 12, 4)->default(0)->nullable();

            $table->decimal('tax_amount', 12, 4)->default(0)->nullable();

            $table->decimal('discount_amount', 12, 4)->default(0)->nullable();

            $table->string('state')->nullable();

            $table->foreign('address_id')->references('id')->on('addresses')->onDelete('cascade');
            $table->foreign('booking_id')->references('id')->on('bookings')->onDelete('cascade');
            $table->foreign('provider_id')->references('id')->on('users')->onDelete('cascade');
            $table->foreign('customer_id')->references('id')->on('users')->onDelete('cascade');
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
        Schema::dropIfExists('invoices');
    }
};
