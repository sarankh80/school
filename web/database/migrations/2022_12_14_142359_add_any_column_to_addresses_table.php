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
        Schema::table('addresses', function (Blueprint $table) {
            $table->string('title')->nullable()->after('addressable_type');
            $table->string('type')->nullable()->after('addressable_type');
            $table->string('floor')->nullable()->after('address');
            $table->string('note')->nullable()->after('address');
            $table->tinyInteger('is_default')->default(0)->after('address');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::table('addresses', function (Blueprint $table) {
            $table->dropColumn('title');
            $table->dropColumn('type');
            $table->dropColumn('floor');
            $table->dropColumn('note');
            $table->dropColumn('is_default');
        });
    }
};
