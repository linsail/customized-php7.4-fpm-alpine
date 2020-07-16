FROM php:7.4-fpm-alpine
RUN echo -e "http://nl.alpinelinux.org/alpine/v3.12/main\nhttp://nl.alpinelinux.org/alpine/v3.12/community" > /etc/apk/repositories \
    && apk add --update \
          freetype-dev \
          libjpeg-turbo-dev \
          libpng-dev \
          imap-dev \
          krb5-dev \
          openssl-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-configure imap --with-imap --with-imap-ssl \
    && docker-php-ext-install -j8 gd imap mysqli pdo_mysql

RUN export _ARCH_=$(arch) \
    && if [ "${_ARCH_}" = "x86_64" ]; then ARCH="x86-64"; else ARCH=${_ARCH_}; fi \
    && curl -o /tmp/ioncube.tar.gz https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_${ARCH}.tar.gz \
    && cd /tmp \
    && tar -xvf ioncube.tar.gz \
    && mv ioncube/ioncube_loader_lin_7.4.so /usr/local/lib/php/extensions/no-debug-non-zts-20190902/ioncube \
    && chmod 755 /usr/local/lib/php/extensions/no-debug-non-zts-20190902/ioncube \
    && docker-php-ext-enable ioncube
RUN apk del curl wget krb5-dev \
    && rm -rf /tmp/* /var/cache/apk/*
