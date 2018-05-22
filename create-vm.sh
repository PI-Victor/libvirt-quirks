#!/usr/bin/env bash

set -ef

# debug
#set -v 

pushd /var/lib/libvirt/images/iso

if [ ! -f /var/lib/libvirt/images/iso/CentOS-7-x86_64-GenericCloud.qcow2 ]; then
    sudo wget https://cloud.centos.org/centos/7/images/CentOS-7-x86_64-GenericCloud.qcow2.xz
    sudo unxz CentOS-7-x86_64-GenericCloud.qcow2.xz
fi
popd

create_vm() {
    name=$1
    path=$2
    mem=$3
    
    sudo cp /var/lib/libvirt/images/iso/CentOS-7-x86_64-GenericCloud.qcow2 $path
    
    sed -i "s/instance-id.*/instance-id: $name/" cloudinit/meta-data
    sed -i "s/local-hostname.*/local-hostname: $name/" cloudinit/meta-data
    sudo genisoimage -o /var/lib/libvirt/images/$name-config.iso -V cidata -r -J cloudinit/meta-data cloudinit/user-data

    sudo sudo virt-install --name=$name \
	 --cpu host-passthrough \
	 --import \
	 --network type=bridge,source=br0,model=virtio \
	 --network default \
	 --graphics vnc,listen=172.16.15.100 \
	 --vcpus 2 \
	 --arch x86_64 \
	 --memory $mem \
	 --disk path=$2,bus=virtio,format=qcow2,cache=none,size=30 \
	 --disk /var/lib/libvirt/images/$name-config.iso,device=cdrom \
	 --os-type linux \
	 --os-variant fedora18 \
	 --console pty,target_type=serial
}

node_names=(k8s-master k8s-slave1 k8s-slave2)

if [[ $1 = "create" ]]; then
    for node in "${node_names[@]}"
    do
	echo "Creating VM - $node"
	
	if [[ $node != "k8s-master" ]]; then
	    mem=4048
	else
	    mem=1024
	fi
	
	qcow_image_path=/var/lib/libvirt/images/$node-CentOS7.qcow2
	
	create_vm $node $qcow_image_path $mem
	
	read -p "Continue (y/n)?" choice
	case "$choice" in 
	    y|Y ) echo "yes"
		  continue;;
	    n|N ) echo "no"
		  exit;;
	    * ) echo "invalid"
		exit;;
	esac
    done
else
    domains=$(sudo virsh list --all | grep k8s | awk '{print $2}' | tail -n +1)
    for domain in $domains; do
	sudo virsh undefine $domain || true
	sudo virsh destroy $domain || true
	sudo virsh vol-delete $domain-CentOS7.qcow2 --pool default || true
	sudo virsh vol-delete $domain-config.iso --pool default || true
    done
fi
