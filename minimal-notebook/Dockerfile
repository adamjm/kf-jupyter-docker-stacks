ARG REPO=adamjm32
ARG ARCH
ARG BASE_CONTAINER=$REPO/kf-base-notebook-$ARCH
FROM $BASE_CONTAINER
ARG ARCH=amd64
LABEL maintainer="Adam Makarucha"
ARG HADOOP_URL
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

# Install hadoop to enable the connection into HDFS
RUN mkdir /hadoop && wget -c ${HADOOP_URL} -O - | tar -xz -C /hadoop

ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-${ARCH} \
    HADOOP_HOME=/opt/hadoop/ \
    ARROW_LIBHDFS_DIR=${HADOOP_HOME}/lib/native

# Install dependancies to compile hadoop


ARG PATH=$PATH:/opt/maven/bin
ENV PATH=${PATH}

# Install hadoop to enable the connection into HDFS


    
USER $NB_UID

 

