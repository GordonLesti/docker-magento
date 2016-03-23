FROM debian:8
MAINTAINER Gordon Lesti <info@gordonlesti.com>

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    wget \
    curl \
    git \
    apt-utils \
    sudo \
    apache2 \
    mysql-server \
    php5 \
    php5-cli \
    php5-mysql \
    php5-mcrypt \
    php5-curl \
    php5-gd \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Apache2
COPY 000-default.conf /etc/apache2/sites-available/000-default.conf
RUN a2enmod rewrite \
    && rm -rf /var/www/html \
    && (cd /var/www && ln -s /opt/magento html)

# MySQL
RUN service mysql start \
    && mysqladmin -uroot password magento \
    && mysql -uroot -pmagento -e 'CREATE DATABASE IF NOT EXISTS magento' \
    && service mysql stop

# Magento
RUN wget https://files.magerun.net/n98-magerun.phar \
    && chmod +x ./n98-magerun.phar \
    && service mysql start \
    && ./n98-magerun.phar install \
    --magentoVersionByName="magento-mirror-1.9.2.3" \
    --installationFolder="/opt/magento" \
    --dbHost="localhost" \
    --dbUser="root" \
    --dbPass="magento" \
    --dbName="magento" \
    --dbPort="3306" \
    --installSampleData=yes \
    --useDefaultConfigParams=yes \
    --baseUrl="http://127.0.0.1/" \
    && find /opt/magento -type d -exec chmod 770 {} \; && find /opt/magento -type f -exec chmod 660 {} \; \
    && chown -R :www-data /opt/magento \
    && service mysql stop

# Modman
RUN wget https://raw.githubusercontent.com/colinmollenhour/modman/master/modman \
	&& chmod +x modman \
	&& mv modman /opt/magento \
	&& (cd /opt/magento && ./modman init)


COPY run /opt/run

EXPOSE 80

CMD bash /opt/run
