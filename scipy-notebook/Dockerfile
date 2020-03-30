# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.
ARG BASE_CONTAINER=adamjm32/kf-kubeflow-notebook
FROM $BASE_CONTAINER

LABEL maintainer="Adam Makarucha"

# ffmpeg for matplotlib anim & dvipng for latex labels
RUN apt-get update && \
    apt-get install -y --no-install-recommends ffmpeg dvipng openssh-server && \
    rm -rf /var/lib/apt/lists/*

COPY environment.yml /root/
ARG IBM_POWERAI_LICENSE_ACCEPT=yes
ENV IBM_POWERAI_LICENSE_ACCEPT=yes
# Install Python 3 packages
RUN eval "$(conda shell.bash hook |sed 's/base/wmlce/g')" && \
    export IBM_POWERAI_LICENSE_ACCEPT=$IBM_POWERAI_LICENSE_ACCEPT && \
    conda env update --prefix /opt/anaconda/envs/wmlce --file /root/environment.yml  --prune && \
    conda clean --all -f -y 

# Import matplotlib the first time to build the font cache.
ENV XDG_CACHE_HOME /home/root/.cache/
RUN eval "$(conda shell.bash hook |sed 's/base/wmlce/g')" && MPLBACKEND=Agg python -c "import matplotlib.pyplot" 
