FROM ibmcom/powerai:1.7.0-base-ubuntu18.04-py37
# Copy the Launcher into the environment
#

LABEL maintainer="Adam Makarucha"

ARG NB_USER=jovyan

USER root

# Install all OS dependencies for notebook server that starts but lacks all
# features (e.g., download as all possible file formats)
ENV DEBIAN_FRONTEND noninteractive

ENV NB_USER $NB_USER

ENV NB_UID 1000
ENV HOME /home/$NB_USER
ENV NB_PREFIX /
ENV PATH $HOME/.local/bin:$PATH

# Use bash instead of sh
SHELL ["/bin/bash", "-c"]


RUN apt-get update \
 && apt-get install -yq --no-install-recommends \
    wget \
    bzip2 \
    ca-certificates \
    sudo \
    locales \
    fonts-liberation \
    run-one \
    git \ 
    gnupg \ 
    vim \
    npm \ 
    unzip \
    g++ \
     build-essential \
 && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen

# Configure environment
ENV CONDA_DIR=/opt/anaconda \
    SHELL=/bin/bash \
    LC_ALL=en_US.UTF-8 \
    NB_USER=jovyan \
    LANG=en_US.UTF-8 \
    NB_PREFIX=/ \
    LANGUAGE=en_US.UTF-8
ENV PATH=$CONDA_DIR/bin:$PATH 
ADD source dest
# Enable prompt color in the skeleton .bashrc before creating the default NB_USER
RUN sed -i 's/^#force_color_prompt=yes/force_color_prompt=yes/' /etc/skel/.bashrc

ARG PYTHON_VERSION=default

RUN useradd -M -s /bin/bash -N -u $NB_UID $NB_USER && \
    chown -R ${NB_USER}:users /usr/local/bin && \
    mkdir -p $HOME && \
    chown -R ${NB_USER}:users ${HOME}

# Install base python packages
RUN /opt/anaconda/bin/conda config --append channels conda-forge && \
/opt/anaconda/bin/conda config --prepend channels \
https://public.dhe.ibm.com/ibmdl/export/pub/software/server/ibm-ai/conda/ && \
/opt/anaconda/bin/conda config --append channels powerai 

#conda config --set channel_priority strict

# Install Tini
RUN conda install --quiet --yes 'tini=0.18.0' && \
    conda list tini | grep tini | tr -s ' ' | cut -d ' ' -f 1,2 >> $CONDA_DIR/conda-meta/pinned && \
    conda clean --all -f -y 

# Correct permissions
# Do all this in a single RUN command to avoid duplicating all of the
# files across image layers when the permissions change
RUN conda install --quiet --yes -n base \
    'notebook=6.0.3' \
    'jupyterhub=1.1.0' \
    'jupyterlab=2.0.1' && \
    conda clean --all -f -y 
RUN eval "$(conda shell.bash hook |sed 's/base/wmlce/g')" && \
    conda install --quiet --yes -n wmlce 'ipykernel=5.1.4=py37h39e3cac_0' && \
    python -m ipykernel install --user --name wmlce --display-name "Python (wmlce)"
EXPOSE 8888

  
# Copy local files as late as possible to avoid cache busting
COPY start-notebook.sh /usr/local/bin/
USER jovyan
# Configure container startup
ENTRYPOINT ["tini", "-g", "--"]
CMD ["start-notebook.sh"]
