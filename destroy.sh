#!/usr/bin/env bash

name=$1-ArmetOS.qcow2
simple_name=$1

sudo virsh destroy $simple_name
sudo virsh undefine $simple_name
sudo virsh vol-delete $name --pool default
sudo virsh vol-delete $simple_name-config.iso --pool default
