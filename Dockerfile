#Stage 1 - Install dependencies and build the app
FROM debian:latest AS build-env

# Install flutter dependencies
RUN apt-get update 
RUN apt-get install -y curl git wget unzip libgconf-2-4 gdb libstdc++6 libglu1-mesa fonts-droid-fallback python3 psmisc
RUN apt-get clean

# Clone the flutter repo
RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter

# Set flutter path
# RUN /usr/local/flutter/bin/flutter doctor -v
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Run flutter doctor
RUN flutter doctor -v
# Enable flutter web
RUN flutter channel master
RUN flutter upgrade
RUN flutter config --enable-web

# Copy files to container and build
RUN mkdir /app/
COPY . /app/
RUN ["chmod", "+x", "/app/NotifierWebApp/server/server.sh"]

# Building server requirement
WORKDIR /app/NotifierServer
RUN dart pub get
EXPOSE 9000

# Building webapp requirement
WORKDIR /app/NotifierWebApp
RUN flutter pub get
RUN flutter build web
EXPOSE 32485



ENTRYPOINT [ "/app/NotifierWebApp/server/server.sh" ]


