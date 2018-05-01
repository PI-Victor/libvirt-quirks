#!/usr/bin/env bash


centos_image="https://cloud.centos.org/centos/7/images/CentOS-7-x86_64-GenericCloud-1802.qcow2"
mem=${MEMORY:-1024}
name=$1
#if [[ ! -f /var/lib/libvirt/images/iso ]]; then
#    wget $centos_image -P /var/lib/libvirt/images
#fi
genisoimage -o cloudinit/$name+config.iso -V cidata -r -J cloudinit/meta-data cloudinit/user-data
sudo mv -f cloudinit/$name+config.iso /var/lib/libvirt/images/iso/


sudo sudo virt-install --name=$1 \
--cpu=host-passthrough \
--network type=bridge,source=br0,model=virtio \
--network=default \
--graphics spice,listen=172.16.15.100 \
--vcpus=2 \
--arch=x86_64 \
--memory=$mem \
--disk path=/var/lib/libvirt/images/$name.qcow2,format=qcow2,bus=virtio,cache=none,size=30 \
--disk /var/lib/libvirt/images/iso/$name+config.iso,device=cdrom \
--os-type=linux --os-variant=fedora18
