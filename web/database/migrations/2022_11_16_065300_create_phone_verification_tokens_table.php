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
        Schema::create('phone_verification_tokens', function (Blueprint $table) {
            $table->id();
            $table->string('phone_number', 255);
            $table->string('token', 10);
            $table->timestamp('expires_at')->nullable();
            $table->index(['phone_number', 'token']);      
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('phone_verification_tokens');
    }
};
