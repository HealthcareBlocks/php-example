FROM healthcareblocks/debian

ENV build_deps \
    gcc \
    g++ \
    libpcre3-dev \
    make \
    php5-dev \
    pkg-config

RUN apt-get update && apt-get install --no-install-recommends -y \
    $build_deps \
    php-apc \
    php5-cgi \
    php5-curl \
    php5-fpm \
    php5-gd \
    php5-mcrypt \
    php5-mysql \
    && \

    git clone --depth=1 https://github.com/phalcon/cphalcon.git && \
    cd cphalcon/build && \
    ./install && \
    echo "extension=phalcon.so" > /etc/php5/fpm/conf.d/30-phalcon.ini && \
    php5enmod phalcon \
    && \

    apt-get -y purge $build_deps && \
    apt-get autoremove -y && \
    apt-get clean

RUN { \
    echo '[global]'; \
		echo 'daemonize = no'; \
		echo; \
		echo '[www]'; \
		echo 'listen = [::]:9000'; \
  	} | tee /etc/php5/fpm/pool.d/zz-docker.conf

ADD . /app
WORKDIR /app/public

CMD ["php5-fpm"]
