#!/bin/bash

REPO=$1
STAGE=$2
SUDO=$3
ARCH=`uname -m`

DIR_LIST=(base-notebook minimal-notebook extension-notebook kubeflow-notebook scipy-notebook machine-learning-notebook)

for dir in "${DIR_LIST[@]}"
do
    if [ "$STAGE" == "build" ] 
    then
        if [ "$dir" == "machine-learning-notebook" ]
        then
            echo $ARCH
            $SUDO docker build --rm -f "$dir/Dockerfile-gpu" -t $REPO/kf-$dir-gpu:latest --build-arg REPO=$REPO --build-arg ARCH=$ARCH "$dir"
        else
            echo $ARCH
           $SUDO docker build --rm -f "$dir/Dockerfile" -t $REPO/kf-$dir:latest --build-arg REPO=$REPO --build-arg ARCH=$ARCH "$dir"
        fi
    elif [ "$STAGE" == "push" ]
    then
        if [ "$dir" == "machine-learning-notebook" ]
        then
            $SUDO docker push $REPO/kf-$dir-gpu:latest
        else
            $SUDO docker push $REPO/kf-$dir:latest
        fi
    elif [ "$STAGE" == "tag-push" ]
    then
	if [ "$dir"  == "machine-learning-notebook" ]
        then
            $SUDO docker tag $REPO/kf-$dir-gpu:latest $REPO/kf-$dir-gpu-$ARCH:latest 
            $SUDO docker push $REPO/kf-$dir-gpu-$ARCH:latest 
        else
            $SUDO docker tag $REPO/kf-$dir:latest $REPO/kf-$dir-$ARCH:latest
            $SUDO docker push $REPO/kf-$dir-$ARCH:latest 
        fi
    elif [ "$STAGE" == "pull" ]
    then
	if [ "$dir"  == "machine-learning-notebook" ]
        then
            $SUDO docker pull $REPO/kf-$dir-gpu-$ARCH:latest 
        else
            if [ "$ARCH" == "x86_64" ]
	    then
            $SUDO docker pull $REPO/kf-$dir:latest 
            else 
            $SUDO docker pull $REPO/kf-$dir-$ARCH:latest 
            fi
        fi
     fi

done


