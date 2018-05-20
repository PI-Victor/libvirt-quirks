#!/usr/bin/env bash

mem=${MEMORY:-1024}
name=$1

fedora_image=$name-ArmetOS.qcow2
fedora_image_path=/var/lib/libvirt/images/$fedora_image
sudo cp /home/k8s-user/projects/cloudflavor/armetos/armetos/qemu/x86_64/soggy-sock/ArmetOS-Soggy-Sock-0.1.0-alpha.3.x86_64.qcow2 $fedora_image_path

sudo genisoimage -o /var/lib/libvirt/images/$name-config.iso -V cidata -r -J cloudinit/meta-data cloudinit/user-data

sudo sudo virt-install --name=$1 \
     --cpu host-passthrough \
     --import \
     --network type=bridge,source=br0,model=virtio \
     --network default \
     --graphics vnc,listen=172.16.15.100 \
     --vcpus 2 \
     --arch x86_64 \
     --memory $mem \
     --disk path=$fedora_image_path,bus=virtio,format=qcow2,cache=none,size=30 \
     --disk /var/lib/libvirt/images/$name-config.iso,device=cdrom \
     --os-type linux \
     --os-variant fedora18 \
     --console pty,target_type=serial
