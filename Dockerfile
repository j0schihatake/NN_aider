ARG TAG=latest
FROM continuumio/miniconda3:$TAG

RUN apt-get update \
    && DEBIAN_FRONTEND="noninteractive" apt-get install -y --no-install-recommends \
        git \
        locales \
        sudo \
        build-essential \
        dpkg-dev \
        wget \
        openssh-server \
        ca-certificates \
        netbase\
        tzdata \
        nano \
        software-properties-common \
        python3-venv \
        python3-tk \
        pip \
        bash \
        git \
        ncdu \
        net-tools \
        openssh-server \
        libglib2.0-0 \
        libsm6 \
        libgl1 \
        libxrender1 \
        libxext6 \
        ffmpeg \
        wget \
        curl \
        psmisc \
        rsync \
        vim \
        unzip \
        htop \
        pkg-config \
        libcairo2-dev \
        libgoogle-perftools4 libtcmalloc-minimal4  \
    && rm -rf /var/lib/apt/lists/*

# Setting up locales
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8

# Create user:
RUN groupadd --gid 1020 aider-group
RUN useradd -rm -d /home/aider-user -s /bin/bash -G users,sudo,aider-group -u 1000 aider-user

# Update user password:
RUN echo 'aider-user:admin' | chpasswd

RUN mkdir /home/aider-user/aider

RUN cd /home/aider-user/aider

RUN mkdir /home/aider-user/aider/src

# установка:
RUN pip install aider-chat
RUN export OPENAI_API_KEY=your-key-goes-here

# Установка brew(пивоварни):
RUN git clone https://github.com/Homebrew/brew ~/.linuxbrew/Homebrew \
    && mkdir ~/.linuxbrew/bin \
    && ln -s ../Homebrew/bin/brew ~/.linuxbrew/bin \
    && eval $(~/.linuxbrew/bin/brew shellenv) \
    && brew --version

RUN export PATH=$HOME/.linuxbrew/bin:$PATH

# Запуск brew:
RUN brew install universal-ctags

# Preparing for login
ENV HOME home/aider-user/aider/
WORKDIR ${HOME}

CMD aider myapp.py

# Docker:
# docker build -t aider .
# docker run -dit --name aider -p 5111:5111 --gpus all --restart unless-stopped aider:latest

# debug: docker container attach aider
# RUN echo conda info --base