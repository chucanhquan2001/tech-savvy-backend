# Sử dụng PHP 8.1 FPM làm base image
FROM php:8.1-fpm

# Cài đặt các dependencies cần thiết
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    nano \
    libzip-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip

# Cài đặt Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Thiết lập thư mục làm việc
WORKDIR /var/www

# Sao chép mã nguồn Laravel vào container
COPY . .

# Cấp quyền cần thiết cho storage và bootstrap/cache
RUN chown -R www-data:www-data /var/www \
    && chmod -R 775 /var/www/storage \
    && chmod -R 775 /var/www/bootstrap/cache

# Cài đặt các dependencies của Laravel
RUN composer install --no-dev --optimize-autoloader

# Expose port 9000 (PHP-FPM)
EXPOSE 9000

# Khởi động PHP-FPM
CMD ["php-fpm"]
