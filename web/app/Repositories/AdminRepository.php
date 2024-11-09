<?php

namespace App\Repositories;

use Illuminate\Container\Container;
use Illuminate\Support\Facades\Storage;
use App\Eloquent\Repository;
use App\Models\Booking;
use App\Models\Admin;

class AdminRepository extends Repository
{
    /**
     * Create a new repository instance.
     *
     * @param  \Illuminate\Container\Container  $container
     * @return void
     */
    public function __construct(
        Container $container
    )
    {
        parent::__construct($container);
    }

    /**
     * Specify model class name.
     *
     * @return string
     */
    public function model(): string
    {
        return Admin::class;
    }
}
