# Install packer
```sh
curl -O https://releases.hashicorp.com/packer/1.8.5/packer_1.8.5_linux_amd64.zip
sudo unzip packer_1.8.5_linux_amd64.zip packer -d /usr/local/bin/
```

```sh
./build.sh
(
name=kind
cp output-kind/packer-kind $name.qcow2
guestfish <<EOF
add $name.qcow2
run
mount /dev/debian-vg/root /
write /etc/hostname debian11-$name
EOF
virt-install \
  --disk $name.qcow2 \
  --import \
  --memory 2048 \
  --name debian11-$name \
  --network bridge:virbr0 \
  --os-variant debian11 \
  --vcpus 2 \
  ;
)
```

```sh
(
name=kind
virsh destroy debian11-$name
virsh undefine --remove-all-storage debian11-$name
)
```

```sh
ssh packer@$(sudo virsh net-dhcp-leases default | grep debian11-kind | awk '{print$5}' | cut -d/ -f1)
```
