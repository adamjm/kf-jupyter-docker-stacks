ARG REPO=adamjm32
ARG BASE_CONTAINER=$REPO/kf-base-notebook
FROM $BASE_CONTAINER
ARG ARCH=amd64
LABEL maintainer="Adam Makarucha"

USER root

RUN apt-get update && apt-get install -yq --no-install-recommends \
    build-essential \
    emacs \
    git \
    inkscape \
    jed \
    libsm6 \
    libxext-dev \
    libxrender1 \
    lmodern \
    netcat \
    python-dev \
    texlive-xetex \
    texlive-fonts-recommended \
    texlive-generic-recommended \
    texlive-fonts-extra \
    tzdata \
    nano \
    openjdk-8-jdk \ 
    openjdk-8-jre \
    libprotobuf-dev \
    libprotobuf-java \
    protobuf-compiler \
    libprotoc-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*


ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-${ARCH} \
    HADOOP_HOME=/opt/hadoop/ \
    ARROW_LIBHDFS_DIR=${HADOOP_HOME}/lib/native

# Install dependancies to compile hadoop

RUN mkdir /opt/maven && wget -c https://apache.mirror.digitalpacific.com.au/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz -O - | tar -xz -C /opt/maven

ARG PATH=$PATH:/opt/maven/bin
ENV PATH=${PATH}

# Install hadoop to enable the connection into HDFS


RUN mkdir /opt/hadoop-src && wget -c http://apache.mirror.serversaustralia.com.au/hadoop/common/hadoop-2.7.7/hadoop-2.7.7-src.tar.gz -O - | tar -xz -C /opt/hadoop-src && cd /opt/hadoop-src && mvn package -Pdist,native -DskipTests –Dtar && mkdir /opt/hadoop  && tar -xz hadoop-dist/target/hadoop-2.7.2.tar.gz -C /opt/hadoop

# Set the Environment variables needed

    
USER $NB_UID

 

