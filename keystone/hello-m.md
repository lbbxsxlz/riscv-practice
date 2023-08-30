# keystone hellp package modify

## launch the docker
    mkdir _keystone
    sudo docker run -it --entrypoint /bin/bash --name keystone_test --privileged -v $PWD/_keystone:/opt keystoneenclaveorg/keystone:master

    sudo docker start keystone_test
    sudo docker attach keystone_test

## build

    cd /keystone
    source source.sh
    cd build
    make run-tests



