# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.
ARG REPO=adamjm32
ARG VERSION
ARG ARCH
ARG BASE_CONTAINER=$REPO/kf-kubeflow-notebook-${ARCH}:$VERSION
FROM $BASE_CONTAINER

LABEL maintainer="Adam Makarucha"
USER root

ENV APACHE_SPARK_VERSION=2.4.6 \
    HADOOP_VERSION=2.7


# ffmpeg for matplotlib anim & dvipng for latex labels
RUN apt-get update && \
    apt-get install -y --no-install-recommends openjdk-8-jre-headless ca-certificates-java && \
    rm -rf /var/lib/apt/lists/*


# Using the preferred mirror to download the file
RUN cd /tmp && \
    wget -c http://apache.mirror.amaze.com.au/spark/spark-${APACHE_SPARK_VERSION}/spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz -O - | tar -xz -C /usr/local --owner root --group root --no-same-owner
RUN cd /usr/local && ln -s spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION} spark

ENV SPARK_HOME=/usr/local/spark
ENV PYTHONPATH=$SPARK_HOME/python:$SPARK_HOME/python/lib/py4j-0.10.7-src.zip \
               SPARK_OPTS="--driver-java-options=-Xms1024M --driver-java-options=-Xmx4096M --driver-java-options=-Dlog4j.logLevel=info" \
    PATH=$PATH:$SPARK_HOME/bin

USER $NB_UID

ARG IBM_POWERAI_LICENSE_ACCEPT=yes
ENV IBM_POWERAI_LICENSE_ACCEPT=yes

# Install Python 3 packages

RUN export IBM_POWERAI_LICENSE_ACCEPT=$IBM_POWERAI_LICENSE_ACCEPT && \
    eval "$(conda shell.bash hook |sed 's/base/base/g')" && \
    conda install --quiet -y 'pyarrow=0.15.1' && \
    conda clean --all -f -y && \
    fix-permissions $HOME && \
    fix-permissions $CONDA_DIR


USER $NB_UID
