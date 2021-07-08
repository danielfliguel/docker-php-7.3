FROM php:7.3-apache

ARG DEBIAN_FRONTEND=noninteractive

# SCRIPTS
COPY scripts/*.sh /root/

# DEPENDENCIES
RUN apt-get update \
&& apt-get install -y cron \
libzip-dev \
apt-utils \
build-essential \
wget \
unzip \
curl \
gcc \
g++ \
make \
vim \
git \
imagemagick \
libbz2-dev \
libssl-dev \
libcurl4-openssl-dev \
libxml2-dev \
libpng-dev \
libgmp-dev \
pkg-config \
libc-client-dev \
libkrb5-dev \
libldb-dev \
libldap2-dev \
libpq-dev \
libicu-dev \
libjpeg-dev \
libjpeg62-turbo-dev \
libgtk2.0-dev \
libpcre3-dev \
libxslt-dev \
libfreetype6-dev \
gnupg \
unixodbc-dev \
apt-transport-https \
--no-install-recommends \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/* 

# SQL SERVER DRIVE
RUN pecl channel-update pecl.php.net
RUN pecl install sqlsrv
RUN pecl install pdo_sqlsrv
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN curl https://packages.microsoft.com/config/debian/9/prod.list > /etc/apt/sources.list.d/mssql-release.list
RUN apt-get update
RUN ACCEPT_EULA=Y apt-get install -y msodbcsql17

# PHP EXTENSIONS
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-png-dir=/usr/include/ --with-jpeg-dir=/usr/include/
RUN docker-php-ext-configure bcmath --enable-bcmath
RUN docker-php-ext-configure imap --with-kerberos --with-imap-ssl
RUN docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu 
RUN docker-php-ext-configure intl
RUN docker-php-ext-install \
bz2 \
calendar \
dba \
gd \
bcmath \
gettext \
gmp \
imap \
intl \
ldap \
mysqli \
pcntl \
pdo_mysql \
pdo_pgsql \
pgsql \
soap \
sockets \
xmlrpc \
xsl \
zip

# XDEBUG
RUN pecl install xdebug
RUN docker-php-ext-enable xdebug

# COMPOSER
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# SMTP CLIENT
RUN wget https://github.com/mailhog/mhsendmail/releases/download/v0.2.0/mhsendmail_linux_amd64
RUN chmod +x mhsendmail_linux_amd64
RUN mv mhsendmail_linux_amd64 /usr/local/bin/mhsendmail

# APACHE
RUN echo "\nServerName localhost" >> /etc/apache2/apache2.conf
RUN chmod -R 755 /var/www/html
RUN chown -R www-data:www-data /var/www/html
RUN a2enmod rewrite

EXPOSE 80