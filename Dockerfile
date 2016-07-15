FROM ubuntu:14.04

RUN apt-get update && apt-get install -y \
wget \
maven \
gradle \
git \
nano \
curl \
libxml-xpath-perl \
build-essential \
nodejs \
npm 

# setup proxy variables
ENV QA_PROXY_HOST=str-www-proxy2-qa.homedepot.com
ENV QA_PROXY_PORT=8080

# download certificates
RUN mkdir certificates
RUN wget https://www.entrust.com/root-certificates/entrust_g2_ca.cer -O certificates/entrust_g2_ca.cer --no-check-certificate


ENV GRADLE_HOME /usr/share/gradle


# download and install cf client
RUN wget https://cli.run.pivotal.io/stable?release=linux64-binary -O /tmp/cf.tgz --no-check-certificate
RUN tar zxf /tmp/cf.tgz -C /usr/bin && chmod 755 /usr/bin/cf

# configure git
RUN git config --global http.sslcainfo "$PWD/certificates/entrust_g2_ca.cer"
RUN git config --global http.proxy "$QA_PROXY_HOST:$QA_PROXY_PORT"
RUN git config --global url."https://".insteadOf git://

# install nodejs
#RUN curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash -
#RUN ln -s -f /usr/bin/nodejs /usr/bin/node

# configure npm
RUN npm config set proxy http://$QA_PROXY_HOST:$QA_PROXY_PORT
RUN npm config set https-proxy http://$QA_PROXY_HOST:$QA_PROXY_PORT
RUN npm config set registry https://npm.artifactory.homedepot.com/artifactory/api/npm/npm


ENV http_proxy="http://$QA_PROXY_HOST:$QA_PROXY_PORT"
ENV https_proxy="http://$QA_PROXY_HOST:$QA_PROXY_PORT"


# # Define working directory.
# WORKDIR /data

# Define default command.
CMD ["bash"]
