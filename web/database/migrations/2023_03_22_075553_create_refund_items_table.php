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
        Schema::create('refund_items', function (Blueprint $table) {
            $table->id();
            $table->string('name')->nullable();
            $table->string('description')->nullable();
            $table->string('sku')->nullable();
            $table->integer('qty')->nullable();

            $table->decimal('price', 12,4)->default(0);
            $table->decimal('base_price', 12,4)->default(0);

            $table->decimal('total', 12,4)->default(0);
            $table->decimal('base_total', 12,4)->default(0);

            $table->decimal('tax_amount', 12,4)->default(0)->nullable();
            $table->decimal('base_tax_amount', 12,4)->default(0)->nullable();
            
            $table->decimal('discount_percent', 12, 4)->default(0)->nullable();
            $table->decimal('discount_amount', 12, 4)->default(0)->nullable();
            $table->decimal('base_discount_amount', 12, 4)->default(0)->nullable();

            $table->unsignedBigInteger('service_id')->unsigned()->nullable();
            $table->unsignedBigInteger('booking_item_id')->nullable();
            $table->foreign('booking_item_id')->references('id')->on('booking_items')->onDelete('cascade');
            
            $table->unsignedBigInteger('refund_id')->nullable();
            $table->foreign('refund_id')->references('id')->on('refunds')->onDelete('cascade');

            $table->unsignedBigInteger('parent_id')->nullable();
            $table->foreign('parent_id')->references('id')->on('refund_items')->onDelete('cascade');

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
        Schema::dropIfExists('refund_items');
    }
};
