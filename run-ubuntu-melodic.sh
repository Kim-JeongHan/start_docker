#!/bin/bash
#set -x

# sudo usermod -aG docker $USER
# newgrp docker

USER_UID=$(id -u)
TAG='bionic-melodic-dev'
#IMAGE='ubuntu:18.04'
IMAGE='osrf/ros:melodic-desktop-full-bionic'
TTY='--device=/dev/ttyACM0'

#xhost +$(hostname -I | cut -d' ' -f1)

xhost +local:docker

echo "IMAGE=" $IMAGE
echo "TAG=" $TAG
echo "USER_UID=" $USER_UID
echo "USER=" $USER
echo "IPADDR=" $(hostname -I | cut -d' ' -f1)
echo "TTY=" $TTY


ENV_PARAMS=()
OTHER_PARAMS=()
args=("$@")
for ((a=0; a<"${#args[@]}"; ++a)); do
    case ${args[a]} in
        #-e) ENV_PARAMS+=("${args[a+1]}"); unset args[a+1]; ;;
        -e) ENV_PARAMS+=("${args[a]} ${args[a+1]}"); ((++a)); ;;
        --env=*) ENV_PARAMS+=("${args[a]}"); ;;
        *) OTHER_PARAMS+=("${args[a]}"); ;;
    esac
done


docker run -it \
    --init \
    --ipc=host \
    --shm-size=8G \
    --privileged \
    --net=host \
    -e DISPLAY=unix$DISPLAY \
    -e XDG_RUNTIME_DIR=/run/user/$USER_UID \
    -e QT_GRAPHICSSYSTEM=native \
    -e CONTAINER_NAME=$TAG \
    -e USER=$USER \
    --env=UDEV=1 \
    --env=LIBUSB_DEBUG=1 \
    --env="DISPLAY" \
    --env="QT_X11_NO_MITSHM=1" \
    ${ENV_PARAMS[@]} \
    -v /run/user/$USER_UID:/run/user/$USER_UID \
    -v /dev:/dev \
    -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
    -v /home/$USER/workspace:/workspace \
    --name=$TAG \
    $IMAGE \
    ${OTHER_PARAMS[@]}  \
    /bin/bash  
export containerId=$(docker ps -l -q)



