ARG REPO=adamjm32
ARG ARCH
ARG VERSION
ARG BASE_CONTAINER=$REPO/kf-minimal-notebook-${ARCH}:$VERSION
FROM $BASE_CONTAINER
ARG ARCH=amd64
LABEL maintainer="Adam Makarucha"
USER root
# Install kubernetes based cli's
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.15.11/bin/linux/$ARCH/kubectl && \ 
     chmod +x ./kubectl && mv ./kubectl /usr/local/bin/kubectl && \
     wget -c https://get.helm.sh/helm-v3.1.2-linux-$ARCH.tar.gz -O - | tar -xz -C /usr/local/bin/
RUN git clone https://github.com/kubeflow-kale/kale.git /kale && chown -R $NB_UID:$NB_UID /kale
USER $NB_UID
# Install KF python libs  (using pip as these are not in the conda repos)
RUN conda install -n base "jupyterlab<2.0.0" && \
    conda install -n base -c conda-forge nodejs=10.13 widgetsnbextension && \
    jupyter nbextension enable --py widgetsnbextension --sys-prefix && \
    pip install kubeflow-kale && \
    jupyter labextension install kubeflow-kale-labextension && \
    fix-permissions $HOME && \
    fix-permissions $CONDA_DIR

   

#cd /kale/labextension && jlpm install && jlpm run build && jlpm labextension install . && \
#    cd /kale/backend/ && pip install -e . && \
#    conda clean --all -f -y && \
#    npm cache clean --force && \
#    fix-permissions $HOME && \
#    fix-permissions $CONDA_DIR


#RUN eval "$(conda shell.bash hook |sed 's/base/kale/g')" && \
    #cd /kale/backend && \
    #pip install . && \
    #pip install kfp \
    #kubeflow-fairing && \
    #fix-permissions $HOME && \
    #fix-permissions $CONDA_DIR



