FROM ubuntu:16.04

USER root

# SSH config.
RUN mkdir -p /root/.ssh
ADD config/ssh /root/.ssh/config
RUN chown root:root /root/.ssh/config && chmod 600 /root/.ssh/config

# Install base.
RUN apt-get update \
  && apt-get -y install \
  bash \
  build-essential \
  curl \
  git-core \
  language-pack-en-base \
  openssl \
  procps \
  software-properties-common \
  wget \
  && locale-gen en_US.UTF-8 \
  && rm -rf /var/lib/apt/lists/*

ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8

RUN add-apt-repository ppa:ondrej/php \
  && apt-get update \
  && apt-get -y install \
  php-cli \
  php-bcmath \
  php-bz2 \
  php-curl \
  php-dev \
  php-gd \
  php-gettext \
  php-gmp \
  php-imagick \
  php-intl \
  php-json \
  php-mbstring \
  php-pear \
  php-pspell \
  php-readline \
  php-recode \
  php-tidy \
  php-xml \
  php-xmlrpc \
  php-zip \
  && rm -rf /var/lib/apt/lists/*

# Add composer.
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
  && php composer-setup.php \
  && php -r "unlink('composer-setup.php');" \
  && mv composer.phar /usr/local/bin/composer \
  && chmod +x /usr/local/bin/composer

# Add composer downloads optimisation.
RUN composer global require hirak/prestissimo

RUN composer global require drush/drush:^8.2.3

# Install rvm, ruby & docman.
RUN apt-get update \
  && apt-get -y install \
  ruby-full \
  && gem install -v 0.0.105 docman \
  && rm -rf /var/lib/apt/lists/*

# Install nodejs & grunt.
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash - \
  && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
  && apt-get update \
  && apt-get install -y nodejs yarn \
  && rm -rf /var/lib/apt/lists/* \
  && npm install -g gulp-cli grunt-cli bower \
  && grunt --version \
  && gulp --version \
  && bower --version \
  && yarn versions

# Install compass.
RUN gem install compass
