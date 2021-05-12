FROM nvidia/cuda:9.2-devel-ubuntu18.04

MAINTAINER Eleftherios Avramidis <eleftherios.avramidis@dfki.de>
LABEL description="Basic Marian 1.10.0 nvidia-docker container for Ubuntu 18.04 "

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
                libprotobuf10 \
		protobuf-compiler \
		libprotobuf-dev \ 
		openssl \ 
		libssl-dev \ 
		libgoogle-perftools-dev \
                wget \
		apt-transport-https ca-certificates gnupg software-properties-common \
                cmake \
                vim nano unzip gzip python-pip php \
            && rm -rf /var/lib/apt/lists/*

# Install Marian
RUN git clone --depth 1 --branch 1.10.0 https://github.com/marian-nmt/marian
WORKDIR $MARIANPATH
RUN mkdir -p build
WORKDIR $MARIANPATH/build
RUN cmake .. -DCMAKE_BUILD_TYPE=Release -DUSE_SENTENCEPIECE=ON && make -j8 

# Install tools
RUN pip install langid

WORKDIR $MARIANPATH/examples/tools
RUN make 

# Direct the user to the examples directory
WORKDIR $MARIANPATH/examples/
