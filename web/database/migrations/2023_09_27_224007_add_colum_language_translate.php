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
        Schema::table('translate_languages', function (Blueprint $table) {
            $table->tinyInteger('status')->default(1)->comment('1- Active , 0- InActive');
            $table->timestamp('deleted_at')->nullable();
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::table('translate_languages', function (Blueprint $table) {
            $table->tinyInteger('status')->comment('1- Active , 0- InActive');
            $table->timestamp('deleted_at')->nullable();
        });
    }
};
