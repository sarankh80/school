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
        Schema::create('invoice_items', function (Blueprint $table) {
            $table->id();
            $table->string('name')->nullable();
            $table->string('description')->nullable();
            $table->string('sku')->nullable();
            $table->integer('qty')->nullable();

            $table->decimal('base_price', 12,4)->default(0);
            $table->decimal('price', 12,4)->default(0);

            $table->decimal('base_total', 12,4)->default(0);
            $table->decimal('total', 12,4)->default(0);

            $table->decimal('discount_percent', 12,4)->default(0)->nullable();
            $table->decimal('discount_amount', 12,4)->default(0)->nullable();

            $table->unsignedBigInteger('service_id');

            $table->unsignedBigInteger('invoice_id');
            $table->foreign('invoice_id')->references('id')->on('invoices')->onDelete('cascade');

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
        Schema::dropIfExists('invoice_items');
    }
};
