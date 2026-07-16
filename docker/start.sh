<<<<<<< HEAD
start.sh
1
100%
#!/usr/bin/env bash
set -euo pipefail

PORT_TO_USE="${PORT:-80}"

# Render injects $PORT; Apache must listen on that port.
sed -i "s/^Listen .*/Listen ${PORT_TO_USE}/" /etc/apache2/ports.conf
sed -i "s/<VirtualHost \*:.*>/<VirtualHost *:${PORT_TO_USE}>/" /etc/apache2/sites-available/000-default.conf

php artisan storage:link || true
php artisan package:discover --ansi || true
php artisan migrate --force || true
php artisan optimize || true

# Do not start Reverb here — run docker/start-reverb.sh as a separate
# Render web service (see render.yaml). Background workers are not reachable
# from the browser for WebSockets.

exec apache2-foreground
=======
set -e

PORT_TO_USE=${PORT:-80}
sed -i "s/Listen 80/Listen ${PORT_TO_USE}/" /etc/apache2/ports.conf
sed -i "s/:80/:${PORT_TO_USE}/" /etc/apache2/sites-available/000-default.conf

php artisan storage:link || true
php artisan db:seed  || true
php artisan migrate --force || true
php artisan optimize || true

apache2-foreground
>>>>>>> 8d654fd50fd5611c4ef05a01dc141414a821a1f3
