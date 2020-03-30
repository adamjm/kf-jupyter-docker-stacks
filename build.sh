#!/bin/bash

REPO=$1
STAGE=$2

DIR_LIST=(base-notebook \
          minimal-notebook \
          extension-notebook \
          kubeflow-notebook \ 
          scipy-notebook \ 
          machine-learning-notebook)

for dir in "${DIR_LIST[@]}"
do
    if [ "$STAGE" == "build" ] 
    then
        if [ "$dir" == "machine-learning-notebook" ]
        then
            sudo docker build --rm -f "$dir/Dockerfile-gpu" -t $REPO/kf-$DIR_LIST-gpu:latest --build-arg REPO=$REPO "$DIR_LIST"
        else
            sudo docker build --rm -f "$dir/Dockerfile" -t $REPO/kf-$DIR_LIST:latest --build-arg REPO=$REPO "$DIR_LIST"
        fi
    elif [ "$STAGE" == "push" ]
    then
        if [ "$dir" == "machine-learning-notebook" ]
        then
            sudo docker push $REPO/kf-$DIR_LIST-gpu:latest
        else
            sudo docker push $REPO/kf-$DIR_LIST:latest
        fi
    fi
done


