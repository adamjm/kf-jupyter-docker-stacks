# Distributed under the terms of the Modified BSD License.
ARG REPO=adamjm32
ARG ARCH
ARG BASE_CONTAINER=$REPO/kf-minimal-notebook-${ARCH}
FROM $BASE_CONTAINER

LABEL maintainer="Adam Makarucha"

USER $NB_UID
# Install Python 3 packages
RUN conda install -n base -c conda-forge nodejs=10.13 widgetsnbextension && \
    conda clean --all -f -y && \
    # Activate ipywidgets extension in the environment that runs the notebook server
    jupyter nbextension enable --py widgetsnbextension --sys-prefix && \
    # Also activate ipywidgets extension for JupyterLab
    # Check this URL for most recent compatibilities
    # https://github.com/jupyter-widgets/ipywidgets/tree/master/packages/jupyterlab-manager
    jupyter labextension install @jupyter-widgets/jupyterlab-manager@^2.0.0 --no-build && \
    jupyter labextension install @bokeh/jupyter_bokeh@^2.0.0 --no-build && \
    jupyter labextension install jupyter-matplotlib@^0.7.2 --no-build && \
    jupyter lab build && \
    jupyter lab clean && \
    npm cache clean --force && \
    rm -rf /home/root/.cache/yarn && \
    rm -rf /home/root/.node-gyp && \
    fix-permissions $home && \
    fix-permissions $conda_dir

# Install facets which does not have a pip or conda package at the moment
RUN cd /tmp && \
    git clone https://github.com/PAIR-code/facets.git && \
    cd facets && \
    jupyter nbextension install facets-dist/ --sys-prefix && \
    cd && \
    rm -rf /tmp/facets && \
    fix-permissions $home && \
    fix-permissions $conda_dir

USER $NB_UID
