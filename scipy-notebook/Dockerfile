# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.
ARG REPO=adamjm32
ARG ARCH
ARG VERSION
ARG BASE_CONTAINER=$REPO/kf-kubeflow-notebook-${ARCH}:$VERSION
FROM $BASE_CONTAINER
#FROM ibmcom/powerai:1.7.0-all-ubuntu18.04-py37
LABEL maintainer="Adam Makarucha"
USER root

# ffmpeg for matplotlib anim & dvipng for latex labels
RUN apt-get update && \
    apt-get install -y --no-install-recommends ffmpeg dvipng openssh-server && \
    rm -rf /var/lib/apt/lists/*

USER $NB_UID

COPY environment_amd64.yml /tmp/
COPY environment_ppc64le.yml /tmp/
ARG ARCH
ARG IBM_POWERAI_LICENSE_ACCEPT=yes
ENV IBM_POWERAI_LICENSE_ACCEPT=yes
ARG PATH=/opt/anaconda/bin:$PATH
ENV PATH=/opt/anaconda/bin:$PATH

SHELL ["/bin/bash", "-c"]
# Install Python 3 packages
RUN export IBM_POWERAI_LICENSE_ACCEPT=$IBM_POWERAI_LICENSE_ACCEPT && \
    conda env update --file /tmp/environment_${ARCH}.yml  && \
    conda clean --all -f -y && \
    fix-permissions $HOME && \
    fix-permissions $CONDA_DIR


# Import matplotlib the first time to build the font cache.
ENV XDG_CACHE_HOME /home/root/.cache/
RUN MPLBACKEND=Agg python3 -c "import matplotlib.pyplot" && \
    fix-permissions $HOME && \
    fix-permissions $CONDA_DIR

USER $NB_UID
