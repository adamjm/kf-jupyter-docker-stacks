ARG REPO=adamjm32
ARG ARCH
ARG VERSION
ARG BASE_CONTAINER=$REPO/kf-extension-notebook-${ARCH}:$VERSION
FROM $BASE_CONTAINER
ARG ARCH=amd64
LABEL maintainer="Adam Makarucha"
USER root
# Install kubernetes based cli's
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.15.11/bin/linux/$ARCH/kubectl && \ 
     chmod +x ./kubectl && mv ./kubectl /usr/local/bin/kubectl && \
     wget -c https://get.helm.sh/helm-v3.1.2-linux-$ARCH.tar.gz -O - | tar -xz -C /usr/local/bin/
#RUN git clone https://github.com/kubeflow-kale/kale.git /kale
USER $NB_UID
# Install KF python libs  (using pip as these are not in the conda repos)
RUN conda install -c conda-forge yarn && pip install kubeflow-fairing && jupyter lab build && \
    git clone https://github.com/adamjm/elyra.git /tmp/elyra && \ 
    git clone https://github.com/adamjm/kfp-notebook.git /tmp/kfp-notebook && \
    cd /tmp/kfp-notebook && pip install . && \
    cd /tmp/elyra && make install #&& \
#    fix-permissions $HOME && \
#    fix-permissions $CONDA_DIR

#RUN git clone https://github.com/kubeflow-kale/jupyterlab-kubeflow-kale.git /jupyterlab-kubeflow-kale && \
#    cd /jupyterlab-kubeflow-kale && \
#    jlpm install && \
#    jlpm build && \
#    jupyter labextension install .




