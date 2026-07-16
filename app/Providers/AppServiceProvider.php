<?php

namespace App\Providers;

<<<<<<< HEAD
use Illuminate\Support\Facades\URL;
=======
>>>>>>> 8d654fd50fd5611c4ef05a01dc141414a821a1f3
use Illuminate\Support\ServiceProvider;

class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     */
    public function register(): void
    {
        //
    }

    /**
     * Bootstrap any application services.
     */
    public function boot(): void
    {
<<<<<<< HEAD
        if ($this->app->environment('production')) {
            URL::forceScheme('https');
        }
    }
}
=======
        //
    }
}
>>>>>>> 8d654fd50fd5611c4ef05a01dc141414a821a1f3
