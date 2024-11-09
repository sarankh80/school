<?php

namespace Tests;

use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Foundation\Testing\TestCase as BaseTestCase;
use Illuminate\Support\Facades\Artisan;

abstract class TestCase extends BaseTestCase
{
    use CreatesApplication, RefreshDatabase;

    protected $faker;

    /**
     * Sets up the tests
     */
    public function setUp(): void
    {
        parent::setUp();

        Artisan::call('migrate'); // runs the migration

        Artisan::call('db:seed'); // runs the seed
    }
}
