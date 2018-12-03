### Docker image to reproduce Bionic+Passenger+Crystal issue ###

# See https://github.com/phusion/baseimage-docker/releases for a list of releases.
FROM phusion/baseimage:0.11

WORKDIR /tmp

# Add passenger repo
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7
RUN echo deb https://oss-binaries.phusionpassenger.com/apt/passenger bionic main > /etc/apt/sources.list.d/passenger.list

# Update packages
RUN apt-get update && apt-get upgrade -y -o Dpkg::Options::="--force-confnew"

# Install passenger
RUN apt-get -y install passenger

# Pick a Crystal version and install the .deb: https://github.com/crystal-lang/crystal/releases
RUN curl -sL https://github.com/crystal-lang/crystal/releases/download/0.27.0/crystal_0.27.0-1_amd64.deb > crystal.deb
# RUN curl -sL https://github.com/crystal-lang/crystal/releases/download/0.26.1/crystal_0.26.1-1_amd64.deb > crystal.deb
RUN apt-get install -y ./crystal.deb

# Startup scripts
RUN mkdir -p /etc/my_init.d
COPY docker/startup/chown.sh /etc/my_init.d/

# Add app user
RUN useradd -m -k /etc/skel app
WORKDIR /home/app/myapp

# Post-build clean up
RUN apt-get clean && rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*

# Run this to start all services (if no command was provided to `docker run`)
CMD ["/sbin/my_init"]
