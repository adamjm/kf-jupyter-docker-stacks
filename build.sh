#!/bin/bash

REPO=$1
STAGE=$2
REPO_OLD=$7
SUDO=$8
SOURCE_LIST=$3
TRUSTED_SOURCE=$4
PROXY=$6
HADOOP_URL=$5

ARCH=`uname -m`
export DOCKER_CLI_EXPERIMENTAL=enabled
if [ "$ARCH" == "x86_64" ]
then
    ARCH=amd64
fi
DIR_LIST=(base-notebook minimal-notebook extension-notebook kubeflow-notebook scipy-notebook machine-learning-notebook rapids-notebook pyspark-notebook baysian-notebook)

for dir in "${DIR_LIST[@]}"
do
    if [ "$STAGE" == "build" ] 
    then
        if [ "$dir" == "machine-learning-notebook" ]
        then
            echo $ARCH
            $SUDO docker build --rm -f "$dir/Dockerfile-gpu" -t $REPO/kf-$dir-gpu-$ARCH:latest --build-arg REPO=$REPO --build-arg ARCH=$ARCH --build-arg SOURCE_LIST=$SOURCE_LIST --build-arg TRUSTED_SOURCE=$TRUSTED_SOURCE --build-arg HTTP_PROXY=$PROXY --build-arg HTTPS_PROXY=$PROXY --build-arg HADOOP_URL=$HADOOP_URL "$dir"
            $SUDO docker build --rm -f "$dir/Dockerfile-cpu" -t $REPO/kf-$dir-cpu-$ARCH:latest --build-arg REPO=$REPO --build-arg ARCH=$ARCH --build-arg SOURCE_LIST=$SOURCE_LIST --build-arg TRUSTED_SOURCE=$TRUSTED_SOURCE --build-arg HTTP_PROXY=$PROXY --build-arg HTTPS_PROXY=$PROXY --build-arg HADOOP_URL=$HADOOP_URL "$dir"
        elif [ "$dir" == "rapids-notebook" ]
        then
            echo $ARCH
            $SUDO docker build --rm -f "$dir/Dockerfile-$ARCH" -t $REPO/kf-$dir-$ARCH:latest --build-arg REPO=$REPO --build-arg ARCH=$ARCH --build-arg SOURCE_LIST=$SOURCE_LIST --build-arg TRUSTED_SOURCE=$TRUSTED_SOURCE --build-arg HTTP_PROXY=$PROXY --build-arg HTTPS_PROXY=$PROXY --build-arg HADOOP_URL=$HADOOP_URL "$dir"
	else
            echo $ARCH
           $SUDO docker build --rm -f "$dir/Dockerfile" -t $REPO/kf-$dir-$ARCH:latest --build-arg REPO=$REPO --build-arg ARCH=$ARCH --build-arg SOURCE_LIST=$SOURCE_LIST --build-arg TRUSTED_SOURCE=$TRUSTED_SOURCE  --build-arg HTTP_PROXY=$PROXY --build-arg HTTPS_PROXY=$PROXY --build-arg HADOOP_URL=$HADOOP_URL "$dir"
        fi
    elif [ "$STAGE" == "push" ]
    then
        if [ "$dir" == "machine-learning-notebook" ]
        then
            $SUDO docker push $REPO/kf-$dir-gpu-$ARCH:latest
            $SUDO docker push $REPO/kf-$dir-cpu-$ARCH:latest
        else
            $SUDO docker push $REPO/kf-$dir-$ARCH:latest
        fi
    elif [ "$STAGE" == "tag-push" ]
    then
	if [ "$dir"  == "machine-learning-notebook" ]
        then
            $SUDO docker tag $REPO_OLD/kf-$dir-gpu-$ARCH:latest $REPO/kf-$dir-gpu-$ARCH:latest 
            $SUDO docker push $REPO/kf-$dir-gpu-$ARCH:latest 
        else
            $SUDO docker tag $REPO_OLD/kf-$dir-$ARCH:latest $REPO/kf-$dir-$ARCH:latest
            $SUDO docker push $REPO/kf-$dir-$ARCH:latest 
        fi
    elif [ "$STAGE" == "pull" ]
    then
	if [ "$dir"  == "machine-learning-notebook" ]
        then
            if [ "$ARCH" == "x86_64" ]
	    then
            $SUDO docker pull $REPO/kf-$dir-gpu:latest 
            else 
            $SUDO docker pull $REPO/kf-$dir-gpu-$ARCH:latest 
            fi
        else
            if [ "$ARCH" == "x86_64" ]
	    then
            $SUDO docker pull $REPO/kf-$dir:latest 
            else 
            $SUDO docker pull $REPO/kf-$dir-$ARCH:latest 
            fi
        fi
     elif [ "$STAGE" == "manifest" ]
     then
	if [ "$dir"  == "machine-learning-notebook" ]
        then
            $SUDO docker manifest create $REPO/kf-$dir-gpu:latest $REPO/kf-$dir-gpu-amd64:latest $REPO/kf-$dir-gpu-ppc64le:latest --amend
            $SUDO docker manifest annotate $REPO/kf-$dir-gpu:latest $REPO/kf-$dir-gpu-amd64:latest --os linux --arch amd64 
            $SUDO docker manifest annotate $REPO/kf-$dir-gpu:latest $REPO/kf-$dir-gpu-ppc64le:latest --os linux --arch ppc64le
            $SUDO docker manifest push $REPO/kf-$dir-gpu:latest 
            $SUDO docker manifest create $REPO/kf-$dir-cpu:latest $REPO/kf-$dir-cpu-amd64:latest $REPO/kf-$dir-cpu-ppc64le:latest --amend
            $SUDO docker manifest annotate $REPO/kf-$dir-cpu:latest $REPO/kf-$dir-cpu-amd64:latest --os linux --arch amd64 
            $SUDO docker manifest annotate $REPO/kf-$dir-cpu:latest $REPO/kf-$dir-cpu-ppc64le:latest --os linux --arch ppc64le
            $SUDO docker manifest push $REPO/kf-$dir-cpu:latest 

        else
            $SUDO docker manifest create $REPO/kf-$dir:latest $REPO/kf-$dir-amd64:latest $REPO/kf-$dir-ppc64le:latest --amend
            $SUDO docker manifest annotate $REPO/kf-$dir:latest $REPO/kf-$dir-amd64:latest --os linux --arch amd64
            $SUDO docker manifest annotate $REPO/kf-$dir:latest $REPO/kf-$dir-ppc64le:latest --os linux --arch ppc64le 
            $SUDO docker manifest push $REPO/kf-$dir:latest 
        fi
     fi

done


