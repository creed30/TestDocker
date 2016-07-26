FROM java:8-jdk

ARG GRADLE_VERSION=2.13
ARG GRADLE_URL=https://downloads.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip
ARG GRADLE_SHA256=0f665ec6a5a67865faf7ba0d825afb19c26705ea0597cec80dd191b0f2cbb664

RUN apt-get update && apt-get install --yes sudo

# add NodeJS 5.x repo
RUN curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -

RUN apt-get update && apt-get install --yes nodejs

# integrated qlik/gradle
ENV GRADLE_VERSION 2.9

VOLUME /project
ENV GRADLE_HOME /gradle
ENV GRADLE_USER_HOME /project/.gradle

WORKDIR /project
RUN wget -O gradle.zip $GRADLE_URL \
 && echo "$GRADLE_SHA256  gradle.zip" | sha256sum -c - \
 && unzip gradle.zip \
 && rm gradle.zip \
 && mv gradle-${GRADLE_VERSION} $GRADLE_HOME \
 && chmod -R 777 $GRADLE_HOME
  
RUN wget https://cli.run.pivotal.io/stable?release=linux64-binary -O /tmp/cf.tgz --no-check-certificate
RUN tar zxf /tmp/cf.tgz -C /usr/bin && chmod 755 /usr/bin/cf

RUN npm install -g gulp

RUN mkdir /build
WORKDIR /build
