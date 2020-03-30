ARG BASE_CONTAINER=adamjm32/kf-scipy-notebook
FROM $BASE_CONTAINER
ARG ARCH=amd64

LABEL maintainer="Adam Makarucha"

# Install GPU packages
RUN eval "$(conda shell.bash hook |sed 's/base/wmlce/g')" && \
    conda install --yes -n wmlce \
    'cudatoolkit=10.2.89' \
    'cudnn=7.6.5_10.2' && \
    conda clean --all -f -y 
