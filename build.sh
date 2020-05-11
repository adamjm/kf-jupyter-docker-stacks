#!/bin/bash

REPO=$1
STAGE=$2
REPO_OLD=$8
version=$3
sudo=$9
SOURCE_LIST=$4
TRUSTED_SOURCE=$5
PROXY=$7
HADOOP_URL=$6

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
            $SUDO docker build --rm -f "$dir/Dockerfile-gpu" -t $REPO/kf-$dir-gpu-$ARCH:$version --build-arg REPO=$REPO --build-arg ARCH=$ARCH --build-arg SOURCE_LIST=$SOURCE_LIST --build-arg TRUSTED_SOURCE=$TRUSTED_SOURCE --build-arg HTTP_PROXY=$PROXY --build-arg HTTPS_PROXY=$PROXY --build-arg HADOOP_URL=$HADOOP_URL --build-arg VERSION=$version "$dir"
            $SUDO docker build --rm -f "$dir/Dockerfile-cpu" -t $REPO/kf-$dir-cpu-$ARCH:$version --build-arg REPO=$REPO --build-arg ARCH=$ARCH --build-arg SOURCE_LIST=$SOURCE_LIST --build-arg TRUSTED_SOURCE=$TRUSTED_SOURCE --build-arg HTTP_PROXY=$PROXY --build-arg HTTPS_PROXY=$PROXY --build-arg HADOOP_URL=$HADOOP_URL --build-arg VERSION=$version "$dir"
        elif [ "$dir" == "rapids-notebook" ]
        then
            echo $ARCH
            $SUDO docker build --rm -f "$dir/Dockerfile-$ARCH" -t $REPO/kf-$dir-$ARCH:$version --build-arg REPO=$REPO --build-arg ARCH=$ARCH --build-arg SOURCE_LIST=$SOURCE_LIST --build-arg TRUSTED_SOURCE=$TRUSTED_SOURCE --build-arg HTTP_PROXY=$PROXY --build-arg HTTPS_PROXY=$PROXY --build-arg HADOOP_URL=$HADOOP_URL --build-arg VERSION=$version "$dir"
	else
            echo $ARCH
           $SUDO docker build --rm -f "$dir/Dockerfile" -t $REPO/kf-$dir-$ARCH:$version --build-arg REPO=$REPO --build-arg ARCH=$ARCH --build-arg SOURCE_LIST=$SOURCE_LIST --build-arg TRUSTED_SOURCE=$TRUSTED_SOURCE  --build-arg HTTP_PROXY=$PROXY --build-arg HTTPS_PROXY=$PROXY --build-arg HADOOP_URL=$HADOOP_URL --build-arg VERSION=$version "$dir"
        fi
    elif [ "$STAGE" == "push" ]
    then
        if [ "$dir" == "machine-learning-notebook" ]
        then
            $SUDO docker push $REPO/kf-$dir-gpu-$ARCH:$version
            $SUDO docker push $REPO/kf-$dir-cpu-$ARCH:$version
        else
            $SUDO docker push $REPO/kf-$dir-$ARCH:$version
        fi
    elif [ "$STAGE" == "tag-push" ]
    then
	if [ "$dir"  == "machine-learning-notebook" ]
        then
            $SUDO docker tag $REPO_OLD/kf-$dir-gpu-$ARCH:$version $REPO/kf-$dir-gpu-$ARCH:$version
            $SUDO docker push $REPO/kf-$dir-gpu-$ARCH:$version
        else
            $SUDO docker tag $REPO_OLD/kf-$dir-$ARCH:$version $REPO/kf-$dir-$ARCH:$version
            $SUDO docker push $REPO/kf-$dir-$ARCH:$version
        fi
    elif [ "$STAGE" == "pull" ]
    then
	if [ "$dir"  == "machine-learning-notebook" ]
        then
            if [ "$ARCH" == "x86_64" ]
	    then
            $SUDO docker pull $REPO/kf-$dir-gpu:$version
            else
            $SUDO docker pull $REPO/kf-$dir-gpu-$ARCH:$version
            fi
        else
            if [ "$ARCH" == "x86_64" ]
	    then
            $SUDO docker pull $REPO/kf-$dir:$version
            else
            $SUDO docker pull $REPO/kf-$dir-$ARCH:$version
            fi
        fi
     elif [ "$STAGE" == "manifest" ]
     then
	if [ "$dir"  == "machine-learning-notebook" ]
        then
            $SUDO docker manifest create $REPO/kf-$dir-gpu:$version $REPO/kf-$dir-gpu-amd64:$version $REPO/kf-$dir-gpu-ppc64le:$version --amend
            $SUDO docker manifest annotate $REPO/kf-$dir-gpu:$version $REPO/kf-$dir-gpu-amd64:$version --os linux --arch amd64
            $SUDO docker manifest annotate $REPO/kf-$dir-gpu:$version $REPO/kf-$dir-gpu-ppc64le:$version --os linux --arch ppc64le
            $SUDO docker manifest push $REPO/kf-$dir-gpu:$version
            $SUDO docker manifest create $REPO/kf-$dir-cpu:$version $REPO/kf-$dir-cpu-amd64:$version $REPO/kf-$dir-cpu-ppc64le:$version --amend
            $SUDO docker manifest annotate $REPO/kf-$dir-cpu:$version $REPO/kf-$dir-cpu-amd64:$version --os linux --arch amd64
            $SUDO docker manifest annotate $REPO/kf-$dir-cpu:$version $REPO/kf-$dir-cpu-ppc64le:$version --os linux --arch ppc64le
            $SUDO docker manifest push $REPO/kf-$dir-cpu:$version

        else
            $SUDO docker manifest create $REPO/kf-$dir:$version $REPO/kf-$dir-amd64:$version $REPO/kf-$dir-ppc64le:$version --amend
            $SUDO docker manifest annotate $REPO/kf-$dir:$version $REPO/kf-$dir-amd64:$version --os linux --arch amd64
            $SUDO docker manifest annotate $REPO/kf-$dir:$version $REPO/kf-$dir-ppc64le:$version --os linux --arch ppc64le
            $SUDO docker manifest push $REPO/kf-$dir:$version
        fi
     fi

done


