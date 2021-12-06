### Create the VM
```
VBoxManage createvm --name VMfedora --ostype Fedora_64 --register
```
### Set 2G RAM 16M Video and 2 CPU cores
```
VBoxManage modifyvm VMfedora --memory 2048 --vram 16 --graphicscontroller vboxsvga --cpus 2
```
### Create the hard disk
```
VBoxManage createmedium --filename /Users/nikolayninov/VirtualBox\ VMs/VMfedora/VMfedora --size 20000 --format VDI --variant Standard
```
### Create SATA controller for the HD
```
VBoxManage storagectl VMfedora --name "SATA controller" --add sata --controller IntelAhci --portcount 4 --bootable on
VBoxManage storageattach VMfedora --storagectl "SATA controller" --port 0 --device 0 --type hdd --medium /Users/nikolayninov/VirtualBox\ VMs/VMfedora/VMfedora.vdi
```
### Create IDE controller and attach the Fedora ISO
```
VBoxManage storagectl VMfedora --name "IDE Controller" --add ide
VBoxManage storageattach VMfedora --storagectl "IDE Controller" --port 0  --device 0 --type dvddrive --medium /Users/nikolayninov/Downloads/Fedora-Workstation-Live-x86_64-35-1.2.iso
```
### Enable the VirtualBox Remote Desktop Extension (VRDE) server
```
VBoxManage modifyvm VMfedora --vrde on
VBoxManage startvm VMfedora
```
