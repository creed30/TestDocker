FROM dockerfile/ubuntu

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

ENV GRADLE_HOME /usr/share/gradle

# Define working directory.
WORKDIR /data

# Define default command.
CMD ["bash"]
