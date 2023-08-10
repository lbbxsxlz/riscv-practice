# Testing Keystone with Qemu

## Start with Docker

    docker pull keystoneenclaveorg/keystone:master
    docker run keystoneenclaveorg/keystone:master

    docker run -it --entrypoint /bin/bash keystoneenclaveorg/keystone:master

    cd /keystone
    source source.sh
    cd build
    make run-tests

