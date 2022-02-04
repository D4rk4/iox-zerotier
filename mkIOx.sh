#!/bin/bash
rm -f zerotier.tar
docker build -t zerotier . && \
docker save -o rootfs.tar zerotier && \
ioxclient package -n zerotier . && \
rm -f rootfs.tar && docker rmi zerotier
