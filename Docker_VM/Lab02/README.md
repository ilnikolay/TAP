### This is basic config without networking. Also in order to set the disk size to particular size you need to install plugin:
```
vagrant plugin install vagrant-disksize
```

### Vagrant file
```
Vagrant.configure("2") do |config|
  config.vm.box = "hashicorp/bionic64"
  #config.disksize.size = "20GB" # need plugin 
   config.vm.provider "virtualbox" do |vb|
     vb.memory = "2048"
     vb.cpus = "2"
   end
end
```
