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
        Schema::create('translate_languages', function (Blueprint $table) {
            $table->id();            
            $table->integer('re_id')->unsigned();
            $table->string('type')->nullable();
            $table->text('name')->nullable();
            $table->text('des')->nullable();       
            $table->text('included')->nullable();
            $table->text('excluded')->nullable();
            $table->text('lang')->nullable();
            $table->text('lang_one')->nullable();
            $table->text('lang_two')->nullable();
            $table->text('lang_three')->nullable();
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
        Schema::dropIfExists('translate_languages');
    }
};
