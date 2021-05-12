# marian-docker
Docker files and instructions for providing a compiled version of the Marian. Marian is "an efficient, free Neural Machine Translation framework written in pure C++ with minimal dependencies." [1] The dockers are based on Ubuntu environments with CUDA support, for running into GPU servers.

# Introduction #

By compiling or simply pulling these docker containers, users can have a fully functioning Marian implementation, without having to go through the complicated and relatively slow process on compiling the toolkit by itself. The latest is based on the instructions of the official website and provides the executables for training, decoding and starting a server, including support for SentencePiece, CPU processing and MPI support. Additional tools such as moses-scripts and sacrebleu are also provided, in order to allow easy reproduction of the example experiments. 

The dockers do not contain any trained models. Additionally the users are recommended to mount a local directory into the docker, so that they can save any produced output. This is a totally unofficial release, with no rlation to the original Marian developers and is provided as is, without any warranty or support. 

# Usage instructions #

## Pulling from dockerhub ##

Compiled dockers are uploaded in docker hub, so they can be pulled with 

``` 
docker pull lefterav/marian-nmt:1.10.0_sentencepiece_cuda-11.3.0
```

## Starting the container ##

After pulling the docker, it can be started with the following command (replace <username> with your linux account username).

``` 
docker run -v /home/<username>:/home/<username> -e HOME=/home/<username> -it lefterav/marian-nmt:1.10.0_sentencepiece_cuda-11.3.0
```

This will provide a commandline which gives you the possibility to run `marian` coomands. Additionally, the `-v` parameter, makes the user folders accessible to the docker, so that the results of the experiments can be saved (otherwise they would be lost when the docker is unloaded). 

In some server installations, the administrators suggest not using the home folder but other designated storage units, so add these in a similar way with the `-v` parameter.

## Running Marian commands

The Marian command is compiled at `/marian/build/marian`. You can test if marian works by running 

```
/marian/build/marian --help
```

By starting the Marian container, the commandline is already directed in the `experiments` directory of Marian. In the subdirectories one can run the bash scripts in order to perform the experiments. It is suggested to msave the data and the models to a mounted folder 

```
cd transformer
mkdir -p ~/myexperiment/model ~/myexperiment/data 
ln -s ~/myexperiment/model .
ln -s ~/myexperiment/data .
bash run-me.sh
```

The above example creates the directories for the data and the models in your home folder and then creates a symbolic link to the experiments directory, so that the data and the models remain even if you exit the container. Then, the bash script will download the required data and train a transformer system. Read the respective Readme file for more infos. 

You can exit the container by hitting Ctrl+D or typing `exit`

# Advanced: compiling the dockerfiles #

We provide different dockerfiles for different versions of Ubuntu and CUDA, and these can be found in the `/dockerfiles` subdirectory. The dockers can be compiled with the following command:

``` 
docker build --tag <username>/marian-nmt:1.10.0_sentencepiece_cuda-11.3.0 - < dockerfiles/marian_1.10.0_sentencepiece_cuda_11.3.0.Dockerfile
```

This gives the possibility to produce one containers with modified setup


[1] https://marian-nmt.github.io/



