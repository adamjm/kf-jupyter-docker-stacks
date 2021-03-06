# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.
ARG REPO=adamjm32
ARG ARCH=amd64
ARG BASE_CONTAINER=$REPO/kf-minimal-notebook-$ARCH
FROM $BASE_CONTAINER

LABEL maintainer="Adam Makarucha"
USER root

ENV APACHE_SPARK_VERSION=2.4.5 \
    HADOOP_VERSION=2.7


# ffmpeg for matplotlib anim & dvipng for latex labels
RUN apt-get update && \
    apt-get install -y --no-install-recommends openjdk-8-jre-headless ca-certificates-java unixodbc-dev && \
    rm -rf /var/lib/apt/lists/*

# Using the preferred mirror to download the file
RUN cd /tmp && \
    wget -q $(wget -qO- https://www.apache.org/dyn/closer.lua/spark/spark-${APACHE_SPARK_VERSION}/spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz\?as_json | \
    python -c "import sys, json; content=json.load(sys.stdin); print(content['preferred']+content['path_info'])") && \
    echo "2426a20c548bdfc07df288cd1d18d1da6b3189d0b78dee76fa034c52a4e02895f0ad460720c526f163ba63a17efae4764c46a1cd8f9b04c60f9937a554db85d2 *spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz" | sha512sum -c - && \
    tar xzf spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz -C /usr/local --owner root --group root --no-same-owner && \
    rm spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz
RUN cd /usr/local && ln -s spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION} spark

ENV SPARK_HOME=/usr/local/spark
ENV PYTHONPATH=$SPARK_HOME/python:$SPARK_HOME/python/lib/py4j-0.10.7-src.zip \
               SPARK_OPTS="--driver-java-options=-Xms1024M --driver-java-options=-Xmx4096M --driver-java-options=-Dlog4j.logLevel=info" \
    PATH=$PATH:$SPARK_HOME/bin

USER $NB_UID
ARG POWERAI_LICENSE
# Install Python 3 packages
RUN export IBM_POWERAI_LICENSE_ACCEPT=${POWERAI_LICENSE} && conda install --quiet -y pyarrow \ 
    pyspark \
    imbalanced-learn \
    xgboost \
    lightgbm \ 
    NLopt \
    Hyperopt \
    Optuna \ 
    GPyOpt \
    scikit-optimize \
    bayesian-optimization && \
    conda clean --all -f -y && \
    pip install pyhadoop ga tpot kale && \
    conda clean --all -f -y && \
    fix-permissions $HOME && \
    fix-permissions $CONDA_DIR

RUN pip uninstall -y kale && pip install minio kubeflow-kale


USER $NB_UID
