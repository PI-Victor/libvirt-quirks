#!/usr/bin/env bash

name=$1

sudo virsh destroy $name
sudo virsh undefine $name
sudo virsh vol-delete $name.qcow2 --pool default
