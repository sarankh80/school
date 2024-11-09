<?php

namespace App\Providers;

use Illuminate\Support\Facades\Route;
use Illuminate\Support\ServiceProvider;

class RestApiServiceProvider extends ServiceProvider
{
    /**
     * Register your middleware aliases here.
     *
     * @var array
     */
    protected $middlewareAliases = [
        'sanctum.provider'    => \App\Http\Middleware\ProviderMiddleware::class,
        'sanctum.customer' => \App\Http\Middleware\CustomerMiddleware::class,
    ];

    /**
     * Bootstrap services.
     *
     * @return void
     */
    public function boot()
    {
        $this->activateMiddlewareAliases();
    }

    /**
     * Register services.
     *
     * @return void
     */
    public function register()
    {
        $this->mapApiRoutes();
    }

    /**
     * Activate middleware aliases.
     *
     * @return void
     */
    protected function activateMiddlewareAliases()
    {
        collect($this->middlewareAliases)->each(function ($className, $alias) {
            $this->app['router']->aliasMiddleware($alias, $className);
        });
    }

    /**
     * Define the "api" routes for the application.
     *
     * @return void
     */
    protected function mapApiRoutes()
    {
        Route::prefix('api')
            ->middleware('api')
            ->group(base_path('routes/api.php'));
    }
}
