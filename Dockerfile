FROM ruby:2.5

# ENV DEBIAN_FRONTEND=noninteractive

# RUN apt-get update && \
#     apt-get --assume-yes install libaio1  && \
#     apt-get install -y mysql-server && \
#     gpg --keyserver hkp://pool.sks-keyservers.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB && \
#     apt-get --assume-yes install curl && \
#     curl -sSL https://get.rvm.io | bash -s stable --ruby

RUN apt update

RUN apt-get autoremove --assume-yes && \
    curl -sL https://deb.nodesource.com/setup_4.x | bash - && \
    apt-get --assume-yes install -y nodejs

# Removes Inappropriate ioctl error
# See https://stackoverflow.com/questions/51970378/not-able-to-run-source-command-from-dockerfile
# RUN sed -i ~/.profile -e 's/mesg n || true/tty -s \&\& mesg n/g'

# Need to use new login instace of bash to properly source rvm
# SHELL [ "/bin/bash", "-l", "-c" ]

# ENV MYRUBY_VERSION=2.5.9
# RUN rvm install $MYRUBY_VERSION
# RUN rvm --default use $MYRUBY_VERSION

RUN apt-get install --assume-yes git
RUN apt install --assume-yes mariadb-server

COPY . /wrektranet

WORKDIR /wrektranet

ENV BUNDLER_VERSION=2.2.21
RUN gem install bundler -v $BUNDLER_VERSION

RUN bundle update
RUN bundle install --verbose


# Create database, likely needs tobe different in production
RUN service mysql start && \
    bundle exec rake db:create:all && \
    bundle exec rake db:schema:load && \
    bundle exec rake db:test:prepare && \
    bundle exec rake db:seed && \
    bundle exec rake assets:precompile -B

EXPOSE 3000

CMD [ "rails",  "s" ]