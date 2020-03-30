#!/bin/bash
#eval "$(conda shell.bash hook |sed 's/base/wmlce/g')"
#Check if Minio deployed
kubectl get deployment minio 
# Install minio deployment using helm
gateways="kubeflow/kubeflow-gateway"
hosts="*"
ak=`head /dev/urandom | tr -dc A-Za-z0-9 | head -c 13 ; echo ''`
sk=`head /dev/urandom | tr -dc A-Za-z0-9 | head -c 13 ; echo ''`
helm install local-minio --set accessKey=$ak,secretKey=$sk,persistence.size=250Gi,persistence.accessMode=ReadWriteMany /root/minio
helm install local-minio-gateway --set gateways=$gateways,allowedHosts=$hosts

# Install PodDefault Configs
SHELL=bash
env PATH=$PATH PYTHONPATH=$PYTHONPATH LD_LIBRARY_PATH=$LD_LIBRARY_PATH jupyter lab --notebook-dir=/home/jovyan --ip=0.0.0.0 --no-browser --allow-root --port=8888 --NotebookApp.token='' --NotebookApp.password='' --NotebookApp.allow_origin='*' --NotebookApp.base_url=${NB_PREFIX}
