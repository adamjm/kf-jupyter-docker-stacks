ARG REPO=adamjm32
ARG BASE_CONTAINER=$REPO/kf-base-notebook
FROM $BASE_CONTAINER
ARG ARCH=amd64
LABEL maintainer="Adam Makarucha"

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
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install hadoop to enable the connection into HDFS
RUN mkdir /hadoop && wget -c http://apache.mirror.amaze.com.au/hadoop/common/hadoop-2.8.5/hadoop-2.8.5.tar.gz -O - | tar -xz -C /hadoop

# Set the Environment variables needed
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-${ARCH} \
    HADOOP_HOME=/hadoop/ \
    ARROW_LIBHDFS_DIR=${HADOOP_HOME}/lib/native
    


 

