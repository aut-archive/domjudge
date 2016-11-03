FROM ubuntu

# Maintainer Pooya Parsa <Pooya Parsa>

RUN apt-get update \
 && apt-get dist-upgrade -y

RUN apt-get install -fy \
    bash supervisor nginx git curl sudo zip unzip xz-utils make

RUN apt-get install -fy \
       php php-apcu php-bz2 php-cache php-cli php-curl php-fpm php-gd php-geoip \
       php-gettext php-gmp php-imagick php-imap php-json php-mcrypt php-mbstring php-zip \
       php-memcached php-mongodb php-mysql php-pear php-redis php-xml php-intl php-soap \
       php-sqlite3 php-dompdf php-fpdf php-guzzlehttp php-guzzlehttp-psr7 php-jwt  php-ssh2 php-bcmath

RUN apt-get install -fy \
        sudo procps gcc g++ build-essential ghc fp-compiler

RUN cd /opt && \
    curl -#L http://mirrors.linuxeye.com/jdk/jdk-8u112-linux-x64.tar.gz | tar -xzf- && \
    mv /opt/jdk* /opt/jdk && \
    ln -fvs /opt/jdk/bin/* /usr/local/bin/

RUN cd /tmp && \
    curl -#L https://www.domjudge.org/releases/domjudge-5.1.2.tar.gz | tar -xzf- && \
    mv domjudge* domjudge

RUN cd /tmp/domjudge && \
    ./configure --disable-submitclient  --with-domjudge-user=root && \
    make install-domserver && \
    ln -sfv /opt/domjudge/domserver/bin/* /usr/local/bin && \
    make install-judgehost && \
    ln -sfv /opt/domjudge/judgehost/bin/* /usr/local/bin

RUN mkdir -p /opt/domjudge/etc && \ 
    cp -nv /opt/domjudge/domserver/etc/* /opt/domjudge/etc/ && \
    rm -r /opt/domjudge/domserver/etc && \
    ln -vs /opt/domjudge/etc /opt/domjudge/domserver/etc  && \
    cp -nv /opt/domjudge/judgehost/etc/* /opt/domjudge/etc/ && \
    rm -r /opt/domjudge/judgehost/etc && \
    ln -vs /opt/domjudge/etc /opt/domjudge/judgehost/etc 

RUN apt-get install mariadb-client -fy

COPY bin /bin

ENTRYPOINT ["entrypoint"]
