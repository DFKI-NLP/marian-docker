FROM nvidia/cuda:9.2-devel-ubuntu18.04

MAINTAINER Eleftherios Avramidis <eleftherios.avramidis@dfki.de>
LABEL description="Basic Marian nvidia-docker container for Ubuntu 18.04 with included Sentencepiece"

# Install some necessary tools.


RUN apt-get update && apt-get install -y \
                build-essential \
                git-core \
                pkg-config \
                libtool \
                zlib1g-dev \
                libbz2-dev \
                automake \
                python-dev \
                perl \
                libsparsehash-dev \
                libboost-all-dev \
		libprotobuf10 \
		protobuf-compiler \
		libprotobuf-dev \ 
		openssl \ 
		libssl-dev \ 
		libgoogle-perftools-dev \
                #doxygen \
                #graphviz \
                wget \
		apt-transport-https ca-certificates gnupg software-properties-common \
                cmake \
            && rm -rf /var/lib/apt/lists/*

# Install cmake 3.15.2
#RUN wget https://github.com/Kitware/CMake/releases/download/v3.15.2/cmake-3.15.2.tar.gz; tar -zxvf cmake-3.15.2.tar.gz
#ENV CMAKEPATH /cmake-3.15.2
#WORKDIR $CMAKEPATH
#RUN ./bootstrap --parallel=8 && make -j 8 && make install

#RUN add-apt-repository ppa:ubuntu-toolchain-r/test
#RUN wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | tee /etc/apt/trusted.gpg.d/kitware.gpg >/dev/null
#RUN apt-add-repository 'deb https://apt.kitware.com/ubuntu/ bionic main'
#RUN apt-get update && apt-get install -y cmake

# Install intel mkl
#RUN wget -qO- 'https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS-2019.PUB' | apt-key add -
#RUN sh -c 'echo deb https://apt.repos.intel.com/mkl all main > /etc/apt/sources.list.d/intel-mkl.list'
#RUN apt-get update && apt-get install -y  gcc-8 g++-8  cmake 
#RUN apt-get update && apt-get install -y  cmake 
#intel-mkl-64bit-2020.0-088
#RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-8 60 --slave /usr/bin/g++ g++ /usr/bin/g++-8
#ENV CXXFLAGS "$CXXFLAGS -std=c++14"

RUN cmake --version

# Install Marian
RUN git clone https://github.com/marian-nmt/marian
ENV MARIANPATH /marian
WORKDIR $MARIANPATH
RUN mkdir -p build
WORKDIR $MARIANPATH/build
RUN cmake .. -DCMAKE_BUILD_TYPE=Release -DUSE_SENTENCEPIECE=ON && make -j8 

# Install SacreBLEU
RUN git clone https://github.com/marian-nmt/sacreBLEU.git sacreBLEU

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -yq vim nano unzip gzip python-pip php
RUN pip install langid
WORKDIR ~
