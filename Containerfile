FROM debian:bookworm
ARG DEBIAN_FRONTEND=noninteractive
ARG TZ=Etc/UTC

# basic installation
RUN apt update && apt -y upgrade
RUN apt install -y curl apt-transport-https lsb-release 7zip

# install php 8.3
RUN curl -sSLo /usr/share/keyrings/deb.sury.org-php.gpg https://packages.sury.org/php/apt.gpg
RUN sh -c 'echo "deb [signed-by=/usr/share/keyrings/deb.sury.org-php.gpg] https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list'
RUN apt update && apt -y upgrade

# install php extensions
RUN apt install -y php8.3 php8.3-cli php8.3-curl php8.3-mysql php8.3-zip php8.3-gd php8.3-mbstring php8.3-common
RUN apt install -y php8.3-fpm

# configure httpd
RUN a2dismod mpm_event
RUN a2enmod rewrite headers proxy_fcgi setenvif mpm_prefork
RUN a2enconf php8.3-fpm
RUN sed -Ei '/<Directory \/var\/www\/>/,/<\/Directory>/ s/(AllowOverride)[^\n]+/\1 All/' /etc/apache2/apache2.conf

# install composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php composer-setup.php
RUN rm composer-setup.php
RUN mv composer.phar /usr/local/bin/composer

# prepare default project
RUN rm -rf /var/www/html/*
RUN composer create-project rsthn/rose-api /var/www/html
RUN chown -R www-data:www-data /var/www/html

# prepare startup script
RUN echo "#!/bin/bash" >> /usr/local/bin/rose-start
RUN echo "service php8.3-fpm start" >> /usr/local/bin/rose-start
RUN echo "apache2ctl -D FOREGROUND" >> /usr/local/bin/rose-start
RUN chmod +x /usr/local/bin/rose-start

EXPOSE 80
CMD ["rose-start"]
