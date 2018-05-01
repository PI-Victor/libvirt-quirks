#!/usr/bin/env bash

name=$1
a=${MEMORY:-1024}

genisoimage -o $name+config.iso -V cidata -r -J meta-data user-data
sudo mv -f $name+config.iso /var/lib/libvirt/images/iso/

sudo cp /var/lib/libvirt/images/Fedora-Cloud-Base-27-1.6.x86_64.qcow2 /var/lib/libvirt/images/$name.qcow2

sudo virt-install -n $name -r $MEMORY -w network=default \
--graphics spice,listen=172.16.15.100 \
--os-type=linux --os-variant=fedora18 \
--disk path=/var/lib/libvirt/images/$name.qcow2,format=qcow2,bus=virtio,cache=none \
--disk /var/lib/libvirt/images/iso/$name+config.iso,device=cdrom

sudo arp -n | grep -i 192
