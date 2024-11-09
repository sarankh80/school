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
        Schema::rename('provider_address_mappings', 'addresses');
        Schema::rename('provider_service_address_mappings', 'address_service');
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::rename('addresses', 'provider_address_mappings');
        Schema::rename('address_service', 'provider_service_address_mappings');
    }
};
