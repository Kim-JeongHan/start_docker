#!/bin/bash



cat /etc/apt/sources.list
apt-get autoremove --purge --yes \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /etc/ros/rosdep/sources.list.d/20-default.list
sed -i -e 's+\(^deb http://security.*\)+# \1+g' /etc/apt/sources.list
apt-get clean && apt-get update 


apt-get install -y \
    tmux \
    curl \
    wget \
    vim \
    git \
    sudo \
    libgl1-mesa-glx \
    libgl1-mesa-dri \
    mesa-utils \
    unzip \
    ntp \
    whois \
    sudo \
    net-tools \
    locales \
    ssh


locale-gen en_US.UTF-8


# ROS 설치 과정
# ubuntu version fixed: bionic 
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu bionic main" > /etc/apt/sources.list.d/ros-latest.list'
sudo apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
sudo apt update

## Gazebo simulator dependencies
sudo apt-get install -y \
   protobuf-compiler \
   libeigen3-dev \
   libopencv-dev \
   ros-melodic-rqt*

sudo apt-get install ros-melodic-rqt* -y 

sudo apt-get install ros-melodic-desktop-full -y

sudo apt-get install python3 python3-pip python-rosinstall python-rosdep python-rosinstall-generator -y


rosdep init
rosdep update 
rosdep fix-permissions 

echo HOME=${HOME}


# 빌드 패키지 설치
apt-get -y install \ 
   build-essential \
   sudo \
   python3 \
   python3-pip \
   python-rosinstall \
   python-rosinstall-generator \
   python-wstool

apt-get autoclean


