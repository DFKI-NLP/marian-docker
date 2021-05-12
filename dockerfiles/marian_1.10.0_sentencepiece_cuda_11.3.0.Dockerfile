FROM nvidia/cuda:11.3.0-devel-ubuntu20.04

MAINTAINER Eleftherios Avramidis <eleftherios.avramidis@dfki.de>
LABEL description="Basic Marian 1.10.0 nvidia-docker container for Ubuntu 20.04 with CUDA 11.3 support"

ENV MARIANPATH /marian
ENV TOOLSDIR /tools

# Install necessary system packages 
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get upgrade -yq && apt-get install -yq \
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
                libprotobuf17 \
		protobuf-compiler \
		libprotobuf-dev \ 
		openssl \ 
		libssl-dev \ 
		libgoogle-perftools-dev \
                wget \
		apt-transport-https ca-certificates gnupg software-properties-common \
                cmake \
                vim nano unzip gzip python3-pip php \
            && rm -rf /var/lib/apt/lists/*

RUN wget -qO- 'https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS-2019.PUB' | apt-key add - && sh -c 'echo deb https://apt.repos.intel.com/mkl all main > /etc/apt/sources.list.d/intel-mkl.list' && apt-get update && apt-get install -yq intel-mkl-64bit-2020.0-088

# Install Marian
RUN git clone --depth 1 --branch 1.10.0 https://github.com/marian-nmt/marian
WORKDIR $MARIANPATH
RUN mkdir -p build
WORKDIR $MARIANPATH/build
RUN cmake .. -DCMAKE_BUILD_TYPE=Release -DUSE_SENTENCEPIECE=ON -DUSE_MPI=ON -DCOMPILE_CPU=on -DCOMPILE_SERVER=on  && make -j8 

# Install tools
RUN pip3 install langid

WORKDIR $MARIANPATH/examples/tools
RUN make 

# Direct the user to the examples directory
WORKDIR $MARIANPATH/examples/
