#!/usr/bin/env bash


image="https://cloud.centos.org/centos/7/images/CentOS-7-x86_64-GenericCloud-1802.qcow2"

if [[ ! -f /var/lib/libvirt/images/iso ]]; then
    wget $image -P /var/lib/libvirt/images
fi

sudo sudo virt-install --name=$1 \
--cpu=host-passthrough \
--network type=bridge,source=br0,model=virtio \
--graphics spice,listen=172.16.15.100 \
--vcpus=2 \
--arch=x86_64 \
--memory=3000 \
--disk path=/var/lib/libvirt/images/CentOS-7-x86_64-GenericCloud-1802.qcow2,format=qcow2,bus=virtio,cache=none \
--os-variant=fedora18
