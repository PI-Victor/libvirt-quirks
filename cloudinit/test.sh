#!/usr/bin/env bash

genisoimage -o config.iso -V cidata -r -J meta-data user-data
sudo mv -f config.iso /var/lib/libvirt/images/iso/

sudo virsh destroy example
sudo virsh undefine example
sudo virsh vol-delete instance1.qcow2 --pool default
sudo cp /var/lib/libvirt/images/iso/CentOS-7-x86_64-GenericCloud-1802.qcow2 /var/lib/libvirt/images/instance1.qcow2

sudo virt-install -n example -r 512 -w network=default \
--graphics spice,listen=172.16.15.100 \
 --os-type=linux --os-variant=centos7.0 \
--disk path=/var/lib/libvirt/images/instance1.qcow2,format=qcow2,bus=virtio,cache=none \
--disk /var/lib/libvirt/images/iso/config.iso,device=cdrom
