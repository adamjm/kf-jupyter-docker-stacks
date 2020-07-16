FROM ibmcom/powerai:1.7.0-base-ubuntu18.04-py37
# Copy the Launcher into the environment
#

LABEL maintainer="Adam Makarucha"

ARG NB_USER="jovyan"
ARG NB_UID="1000"
ARG NB_GID="100"

USER root

# Install all OS dependencies for notebook server that starts but lacks all
# features (e.g., download as all possible file formats)
ENV DEBIAN_FRONTEND noninteractive

# Use bash instead of sh
SHELL ["/bin/bash", "-c"]
ARG CUSTOM_SOURCES=false
ARG SOURCE_LIST=false
ARG TRUSTED_SOURCE=false
ARG HTTP_PROXY
ARG HTTPS_PROXY
ENV HTTP_PROXY=${HTTP_PROXY}
ENV HTTPS_PROXY=${HTTPS_PROXY}

#ARG NO_PROXY
COPY config.sh /usr/bin/source-update
RUN /usr/bin/source-update

RUN apt-get update \
 && apt-get install -y \
    wget \
    bzip2 \
    cmake \
    build-essential \
    ca-certificates \
    sudo \
    locales \
    fonts-liberation \
    run-one \
    git \ 
    gnupg \ 
    inetutils-ping \
    netcat \
    traceroute \
    curl \
    wget \
    npm \ 
    node-gyp \ 
    nodejs-dev \
    libssl1.0-dev \
    unzip \
    g++-5 \
    gcc-5 \
    libffi-dev \
     build-essential \
 && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen

# Configure environment
ENV CONDA_DIR=/opt/anaconda \
    SHELL=/bin/bash \
    NB_USER=$NB_USER \
    NB_UID=$NB_UID \
    NB_GID=$NB_GID \
    NB_PREFIX=/ \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    NB_PREFIX=/ \
    LANGUAGE=en_US.UTF-8
ENV PATH=$CONDA_DIR/bin:$PATH  \
    HOME=/home/$NB_USER

# Enable prompt color in the skeleton .bashrc before creating the default NB_USER
RUN sed -i 's/^#force_color_prompt=yes/force_color_prompt=yes/' /etc/skel/.bashrc

COPY fix-permissions.sh /usr/local/bin/fix-permissions
RUN chmod a+rx /usr/local/bin/fix-permissions

RUN git clone https://github.com/krallin/tini.git /tini
#wget https://github.com/krallin/tini/archive/v0.18.0.tar.gz && \
  #  tar zxvf v0.18.0.tar.gz && \
  #  rm -rf v0.18.0.tar.gz
WORKDIR tini/
RUN cmake . && make install
RUN mv ./tini /usr/local/bin/tini  && \
    chmod +x /usr/local/bin/tini

ARG PYTHON_VERSION=default

RUN echo "auth requisite pam_deny.so" >> /etc/pam.d/su && \
    sed -i.bak -e 's/^%admin/#%admin/' /etc/sudoers && \
    sed -i.bak -e 's/^%sudo/%jovyan/' /etc/sudoers && \
    echo "jovyan ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    useradd -m -s /bin/bash -N -u $NB_UID $NB_USER && \
    mkdir -p $CONDA_DIR && \
    chown -R $NB_USER:$NB_GID $CONDA_DIR && \
    chmod g+w /etc/passwd && \
    fix-permissions $HOME && \
    fix-permissions $CONDA_DIR

USER $NB_UID
WORKDIR $HOME
ARG PYTHON_VERSION=default

# Setup work directory for backward-compatibility
RUN mkdir /home/$NB_USER/work && \
    fix-permissions /home/$NB_USER

# Install base python packages
RUN /opt/anaconda/bin/conda config --append channels conda-forge && \
    /opt/anaconda/bin/conda config --prepend channels \
    https://public.dhe.ibm.com/ibmdl/export/pub/software/server/ibm-ai/conda/ && \
    /opt/anaconda/bin/conda config --append channels powerai && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

# Correct permissions
# Do all this in a single RUN command to avoid duplicating all of the
# files across image layers when the permissions change
RUN conda install --quiet --yes -n base \
    'notebook=6.0.3' \
    'jupyterhub=1.1.0' \
    'zeromq>=4.3.2' \
    'jupyterlab=2.0.1' && \
    conda clean --all -f -y && \
    npm cache clean --force && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

RUN conda install --quiet --yes -n base 'ipykernel=5.1.4=py37h39e3cac_0' && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

EXPOSE 8888

  
# Copy local files as late as possible to avoid cache busting
COPY start-notebook.sh /usr/local/bin/
USER jovyan
# Configure container startup
ENTRYPOINT ["tini", "-g", "--"]
CMD ["start-notebook.sh"]
