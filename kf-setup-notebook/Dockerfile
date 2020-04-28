ARG REPO=adamjm32
ARG ARCH
ARG BASE_CONTAINER=$REPO/kf-kubeflow-notebook-${ARCH}
FROM $BASE_CONTAINER
ARG ARCH=amd64
LABEL maintainer="Adam Makarucha"

# Install Minio on initial deployment of jupyter lab within Kubeflow and on the Jupyter lab namespace 
COPY minio-manifests /root/
# Install PodDefault Manifests for the namespace
COPY poddefaults-manifests /root/
COPY start-notebook.sh /usr/local/bin 
CMD ["start-notebook.sh"]
