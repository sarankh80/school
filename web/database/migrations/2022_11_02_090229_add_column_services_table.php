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
        Schema::table('services', function(Blueprint $table){
            $table->unsignedBigInteger('brand_id')->nullable()->after('category_id');
            $table->string('sku', 200)->after('brand_id');
            $table->double('cost', 22, 4)->nullable()->before('price')->default('0');
            $table->double('quantity', 22, 4)->nullable()->before('cost')->default('0');
            $table->double('alert_quantity', 22, 4)->nullable()->before('quantity')->default('0');
            $table->tinyInteger('price_estimate')->nullable()->default(0);
            $table->tinyInteger('enable_stock')->nullable()->default('0');
            $table->tinyInteger('visible')->nullable()->default('1');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::table('services', function(Blueprint $table){
            $table->dropColumn('brand_id');
            $table->dropColumn('sku');
            $table->dropColumn('cost');
            $table->dropColumn('quantity');
            $table->dropColumn('alert_quantity');
            $table->dropColumn('price_estimate');
            $table->dropColumn('enable_stock');
            $table->dropColumn('visible');
        });
    }
};
