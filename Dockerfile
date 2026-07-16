# --------------------------------------------------
# Stage 1: Build frontend assets using Node
# --------------------------------------------------
FROM node:20-alpine AS frontend

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci

COPY resources ./resources
COPY public ./public
<<<<<<< HEAD
COPY vite.config.js postcss.config.js tailwind.config.js ./

RUN npm run build

# Verify that Vite generated the manifest and a non-trivial CSS bundle
RUN test -f public/build/manifest.json \
    && echo "Frontend build completed successfully" \
    && ls -la public/build/assets \
    && css_file="$(ls public/build/assets/*.css | head -n 1)" \
    && css_size="$(wc -c < "$css_file")" \
    && echo "CSS bundle: $css_file ($css_size bytes)" \
    && test "$css_size" -gt 10000
=======
COPY vite.config.js ./

RUN npm run build

# Verify that Vite generated the manifest
RUN test -f public/build/manifest.json \
    && echo "Frontend build completed successfully" \
    && ls -la public/build
>>>>>>> 8d654fd50fd5611c4ef05a01dc141414a821a1f3


# --------------------------------------------------
# Stage 2: Laravel PHP and Apache
# --------------------------------------------------
FROM php:8.4-apache

ENV COMPOSER_ALLOW_SUPERUSER=1 \
    COMPOSER_MEMORY_LIMIT=-1 \
    COMPOSER_PROCESS_TIMEOUT=2000 \
    APACHE_DOCUMENT_ROOT=/var/www/html/public

RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    curl \
    unzip \
    zip \
    libzip-dev \
    libpq-dev \
    libicu-dev \
    libonig-dev \
    libxml2-dev \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    && docker-php-ext-configure gd \
        --with-freetype \
        --with-jpeg \
    && docker-php-ext-install -j"$(nproc)" \
        bcmath \
        gd \
        intl \
        mbstring \
        opcache \
        pcntl \
        pdo_mysql \
        pdo_pgsql \
        sockets \
        zip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

<<<<<<< HEAD
RUN a2enmod rewrite headers \
    && printf 'ServerName localhost\n' > /etc/apache2/conf-available/servername.conf \
    && a2enconf servername

# Pin DocumentRoot to Laravel's public/ (avoid ${APACHE_DOCUMENT_ROOT} expansion issues)
COPY docker/000-default.conf /etc/apache2/sites-available/000-default.conf

RUN sed -ri -e 's!AllowOverride None!AllowOverride All!g' \
=======
RUN a2enmod rewrite \
    && sed -ri \
        -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' \
        -e 's!AllowOverride None!AllowOverride All!g' \
        /etc/apache2/sites-available/*.conf \
>>>>>>> 8d654fd50fd5611c4ef05a01dc141414a821a1f3
        /etc/apache2/apache2.conf \
        /etc/apache2/conf-available/*.conf

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

COPY composer.json composer.lock ./

RUN composer install \
    --no-dev \
    --prefer-dist \
    --no-interaction \
    --no-progress \
    --optimize-autoloader \
    --no-scripts

<<<<<<< HEAD
# Copy Laravel source
COPY . .

# Remove any stale local Vite build
RUN rm -rf /var/www/html/public/build

# Copy one complete Vite build from the frontend stage
COPY --from=frontend /app/public/build /var/www/html/public/build

# Verify manifest and matching asset files
RUN test -f /var/www/html/public/build/manifest.json \
    && echo "Vite files in final image:" \
    && find /var/www/html/public/build -maxdepth 2 -type f -print

# Rebuild autoloader after full source copy (install used --no-scripts)
RUN composer dump-autoload --optimize --no-scripts \
    && mkdir -p \
        storage/logs \
        storage/framework/cache/data \
        storage/framework/sessions \
        storage/framework/views \
        bootstrap/cache \
=======
# Copy Laravel application
COPY . .

# Copy compiled frontend assets
COPY --from=frontend /app/public/build /var/www/html/public/build

# Verify final manifest location
RUN test -f /var/www/html/public/build/manifest.json \
    && echo "Vite manifest successfully copied" \
    && ls -la /var/www/html/public/build

RUN mkdir -p \
        storage/framework/cache/data \
        storage/framework/sessions \
        storage/framework/views \
        storage/logs \
        bootstrap/cache \
    && composer dump-autoload \
        --no-dev \
        --optimize \
        --no-interaction \
        --no-scripts \
>>>>>>> 8d654fd50fd5611c4ef05a01dc141414a821a1f3
    && chown -R www-data:www-data storage bootstrap/cache \
    && chmod -R 775 storage bootstrap/cache \
    && chmod +x docker/start.sh

EXPOSE 80

CMD ["./docker/start.sh"]