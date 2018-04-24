Centos libvirt setup
---

Enable epel-release first and then install libvirt and kvm-qemu packages.
Also install: genisoimage, virt-install
```
yum install -y epel-release kvm-qemu libvirt
systemctl enable libvirtd
```

Because this is a test machine, we can disable `selinux` so we don't spend time
adding labels or exceptions to get everything to work.

#### Pools
Create the default pool where all the images are going to be stored.
Set the pool to auto-start

```
virsh # pool-define-as default --type dir --target /var/lib/libvirt/images/
Pool default defined

virsh # pool-list --all
 Name                 State      Autostart
-------------------------------------------
 default              inactive   no

virsh # pool-start default
Pool default started

virsh # pool-list
 Name                 State      Autostart
-------------------------------------------
 default              active     yes
```
