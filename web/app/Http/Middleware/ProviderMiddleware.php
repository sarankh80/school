<?php

namespace App\Http\Middleware;

use Closure;

class ProviderMiddleware
{
    /**
     * Handle an incoming request.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \Closure  $next
     * @param  string|null  $guard
     * @return mixed
     */
    public function handle($request, Closure $next, $guard = null)
    {
        /**
         * Provider model.
         *
         * @var App\Models\Provider
         */
        $customer = auth()->user();

        if ($customer && $customer->tokenCan('role:provider')) {
            return $next($request);
        }

        return response([
            'message' => __('rest-api::app.common-response.error.not-authorized'),
        ], 401);
    }
}