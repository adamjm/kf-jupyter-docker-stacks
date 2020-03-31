#!/bin/bash

REPO=$1
STAGE=$2
SUDO=$3

DIR_LIST=(base-notebook minimal-notebook extension-notebook kubeflow-notebook scipy-notebook machine-learning-notebook)

for dir in "${DIR_LIST[@]}"
do
    if [ "$STAGE" == "build" ] 
    then
        if [ "$dir" == "machine-learning-notebook" ]
        then
            $SUDO docker build --rm -f "$dir/Dockerfile-gpu" -t $REPO/kf-$dir-gpu:latest --build-arg REPO=$REPO "$dir"
        else
           $SUDO docker build --rm -f "$dir/Dockerfile" -t $REPO/kf-$dir:latest --build-arg REPO=$REPO "$dir"
        fi
    elif [ "$STAGE" == "push" ]
    then
        if [ "$dir" == "machine-learning-notebook" ]
        then
            $SUDO docker push $REPO/kf-$dir-gpu:latest
        else
            $SUDO docker push $REPO/kf-$dir:latest
        fi
    fi
done


