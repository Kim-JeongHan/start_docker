FROM osrf/ros:melodic-desktop-full-bionic


ARG DEBIAN_FRONTEND=noninteractive
ARG HOST_USER
ARG UNAME=${HOST_USER}
ARG UID=1000
ARG GID=1000
ARG HOME=/home/${UNAME}
ARG WORKSPACE=${HOSTWORKSPACE}
USER root

SHELL ["/bin/bash", "-c"]
RUN apt-get autoremove --purge --yes \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /etc/ros/rosdep/sources.list.d/20-default.list

# setup timezone

# install packages
RUN apt-get update && apt-get install -q -y --no-install-recommends \
    dirmngr \
    gnupg2 \
    && rm -rf /var/lib/apt/lists/*


RUN apt-get update && apt-get install -y \
    terminator \
    curl \
    wget \
    vim \
    git \
    sudo \
    libgl1-mesa-glx \
    libgl1-mesa-dri \
    mesa-utils \
    unzip \
    locales \
    ntp \
    whois \
    net-tools \
    sudo \
    tmux \
		gedit


RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8  


RUN rosdep init
RUN apt-get install ros-melodic-rqt* -y 
RUN apt-get install python3 python3-pip python-rosinstall python-rosdep python-rosinstall-generator -y



RUN mkdir -p /etc/sudoers.d && \
    echo "${UNAME} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${UNAME} && \
    chmod 0440 /etc/sudoers.d/${UNAME} 


USER ${UNAME}
WORKDIR $HOME

RUN rosdep update 
RUN rosdep fix-permissions

RUN mkdir workspace && chmod -R +x ./workspace
COPY ${WORKSPACE}/init-melodic.sh ./workspace/
COPY ${WORKSPACE}/init_tools.sh ./workspace/
CMD ["/bin/bash", "init_tools.sh"]

RUN cd /
