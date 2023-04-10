# NiteKeeper's Settler

I've customized the original Laravel settler scripts (https://github.com/laravel/settler) for my own use.
You can freely use these scripts to make your own Vagrant Box as well. 

These scripts build Vagrant box for the customized Laravel Homestead development environment, which is lighter than the original one.

## Features

The features will include:
- PHP
    * 7.4
    * 8.0
    * 8.1
    * 8.2 (default)
- MySQL
    * ID: homestead
    * PWD: secret
- Apache (installed but disabled)
- Nginx
- SQlite3
- MailHog
- Redis
- Memcached
- Supervisor
- Postfix
- Composer
    * laravel/envoy
    * laravel/installer
- NodeJS
    * npm
    * gulp-cli
    * bower
    * yarn
    * grunt-cli

If you want the full features of Laravel Homestead, you probably don't want this repo. In that case, follow instructions at https://laravel.com/docs/homestead instead.


## Installation

*STOP*: You can download this from https://app.vagrantup.com. You do not need to create it from scratch.

Even so, if you want to create your own box, follow the instructions below. This scripts are intended to work on Windows 11. You will need to install the followings first.

*NOTE*: Ensure that your Windows 11 is up-to-date. 

### Install one of the following VMs.
- VMWare Workstation Pro: https://www.vmware.com/content/vmware/vmware-published-sites/us/products/workstation-pro.html.html
- VMWare Workstation Player: https://www.vmware.com/products/workstation-player.html
    - I haven't check this version. You can try it.
- VMWare Fusion: https://www.vmware.com/products/fusion.html
- VirtualBox: https://www.virtualbox.org

### Install Vagrant
- https://www.vagrantup.com/

### Create Vagrant Box of Your Choice

If you are using VirtualBox as your choice of VM, replace `vmware-iso.vm` with `virtualbox-iso.vm` in the packer command below.
If you want to customize the packer command, follow the normal [Packer](https://www.packer.io/) practice.

Open your PowerShell as administrator and type the following:
```PowerShell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
git clone https://github.com/nitekeeper/laravel-settler-lite
cd laravel-settler-lite
git clone https://github.com/chef/bento
./bin/link-to-bento.ps1
cd bento
packer build -only="vmware-iso.vm" -var-file="os_pkrvars/ubuntu/ubuntu-22.04-x86_64.pkrvars.hcl" ./packer_templates
```

It will take about 16 ~ 30 minutes to finish, depending on your network speed and your system specification.
You can find the created vagrant box in the `bento > builds` folder.

Rename the box as you wish and copy it to your safe folder.

## How to Use

Let's say:
- you named your custom box as `my-homestead.box`.
- you save your custom box in the following folder `D:\Boxes`.
- your project folder is `D:\Projects\Test`.

*NOTE*: You can change the label `my-custom-box` in the `vagrant box add` command as you like. 

```PowerShell
cd D:\Boxes
vagrant box add my-custom-box my-homestead.box
cd D:\Projects\Test
vagrant init my-custom-box
vagrant up
vagrant ssh
laravel new example-site
cd example-site
ifconfig
```

Get your private ip address from the result of the command `ifconfig`. The proper private IP address should look like 192.168.x.x.
Let's say your private IP address for this box is `192.168.217.156`. Keep it some where safe and enter the following command in your terminal.

```PowerShell
php artisan serve --host=0.0.0.0
```

All done! Now, open your browser and type `192.168.217.156:8000`.

That's it! Happy coding!
