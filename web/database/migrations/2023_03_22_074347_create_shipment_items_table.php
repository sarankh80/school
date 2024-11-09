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
        Schema::create('shipment_items', function (Blueprint $table) {
            $table->id();
            $table->string('name')->nullable();
            $table->string('description')->nullable();
            $table->string('sku')->nullable();
            $table->integer('qty')->nullable();
            $table->integer('weight')->nullable();

            $table->decimal('price', 12, 4)->default(0)->nullable();
            $table->decimal('base_price', 12, 4)->default(0)->nullable();
            $table->decimal('total', 12, 4)->default(0)->nullable();
            $table->decimal('base_total', 12, 4)->default(0)->nullable();

            $table->unsignedBigInteger('service_id')->nullable();
            $table->unsignedBigInteger('booking_item_id')->nullable();
            $table->unsignedBigInteger('shipment_id');
            $table->foreign('shipment_id')->references('id')->on('shipments')->onDelete('cascade');
            $table->json('additional')->nullable();
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
        Schema::dropIfExists('shipment_items');
    }
};
