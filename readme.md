# NiteKeeper's Settler

I've customized the original Laravel settler scripts (https://github.com/laravel/settler) for my own use. You can freely use these scripts to make your own Vagrant Box as well.

These scripts build Vagrant box for the customized Laravel Homestead development environment, which is lighter than the original one.

## Features

The features will include:
- Ubuntu 22.04LTS
- PHP
    * 7.4
    * 8.0
    * 8.1 (default)
    * 8.2
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

*STOP*: You can download this from https://app.vagrantup.com/nitekeeper/boxes/light-weight-homestead-vmware. You do not need to create it from scratch.

Even so, if you want to create your own box, follow the instructions below. These scripts are intended to work on Windows 11. You will need to install the followings first.

*NOTE*: Ensure that your Windows 11 is up-to-date. 

### Install one of the following VMs.
- VMWare Workstation Pro: https://www.vmware.com/content/vmware/vmware-published-sites/us/products/workstation-pro.html.html
- VMWare Workstation Player: https://www.vmware.com/products/workstation-player.html
    - I haven't checked this version, but you can try it.
- VMWare Fusion: https://www.vmware.com/products/fusion.html
- VirtualBox: https://www.virtualbox.org

### Install Vagrant
- https://www.vagrantup.com/

### Create Vagrant Box of Your Choice

If you are using VirtualBox as your choice of VM, replace `vmware-iso.vm` with `virtualbox-iso.vm` in the packer command below.
If you want to customize the packer command, follow the normal [Packer](https://www.packer.io/) practice. Since the original
Laravel Settler utilizes Chef/Bento source code as its base, I recommand you to check its repo as well: https://github.com/chef/bento

Open your PowerShell as `administrator` and type the following:
```PowerShell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
git clone https://github.com/nitekeeper/laravel-settler-lite
cd laravel-settler-lite
git clone https://github.com/chef/bento
./bin/link-to-bento.ps1
cd bento
packer init -upgrade ./packer_templates
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
```

In the box:
```bash
laravel new example-site
cd example-site
ifconfig
```

Get your private ip address from the result of the command `ifconfig`. The proper private IP address should look like 192.168.x.x.
Let's say your private IP address for this box is `192.168.217.156`. Keep it some where safe and enter the following command in your terminal.

```bash
php artisan serve --host=0.0.0.0
```

All done! Now, open your browser and type `192.168.217.156:8000`.

## How To Avoid Symbolic Link Issue on Windows 11

VMWare, installed on Windows 11, has a problem with creating a symbolic link by `npm` on Ubuntu Guest OS. 
In order to avoid this issue, install `npm` on Windows 11 and use it there, instead of using one installed 
on Ubuntu Guest OS.

`composer` sometimes runs `npm` when installing libraries as well. In order to solve this issue, you can also install 
`composer` on Windows 11 and use it there, instead of using one installed on your Ubuntu Guest OS. To install
`composer` on Windows 11, you will need PHP library files stored somewhere on your Windows Host system. 

Please note that you do not need to install PHP. You just need its executable and extension files stored somewhere
on your Windows OS, so that you can bypass the package installation requirements of `composer`. 

You can download PHP library files from https://windows.php.net/download.

- Download the zip file of the `Thread Safe` version, and 
- unzip it to somewhere in your system. When installing `composer`, you will be asked to locate the `php.exe` file. 
- Open `php.ini` and uncomment the followings and save it. The following extensions are frequently used by `composer`.
```
;extension=zip
;extension=fileinfo
```
Just in case that you need other extensions to be enabled, you can simply uncomment them here as well. However, please
note that the PHP extensions on your Windows are not actually used by your PHP application on Ubuntu Guest OS. 
Those are just needed to bypass the `composer`'s package installation requirements.

In addition, you will encounter a problem when you are trying to create symbolic link between Laravel storage and Laravel public folder on Ubuntu Guest server. When you run VMWare on Windows 11, you need to create your symbolic link on your Windows Host system, not on your Ubuntu Guest system. The following instructions will help you to create the symbolic link, which you need. 

- Run `cmd` as administrator.
- Use the command `mklink` in the following format `mklink /D absolute_target_folder absolute_source_folder`. The following is an example for you.

```
mklink /D "D:\your\laravel\project\public\destination\folder" "D:\your\laravel\public\source\folder"
```

## How To Switch Between PHP Versions

To change the PHP version, server type, xdebug setting, type the following commands.
```bash
select-php
```

When you configure `xdebug` with your client, refer to the setting values:
```
xdebug.mode = debug
xdebug.discover_client_host = true
xdebug.client_port = 9003
xdebug.max_nesting_level = 512
opcache.revalidate_freq = 0
```

## Additional Tips

If you want some convenience while using this box, you can add followings to your `.bashrc` file.

```bash
cd ~
nano .bashrc
```

*NOTE*: If your shared directory on your virtual machine is not `/vagrant`, change the vagrant
shared folder address in the following `vagrant` alias setting.
```bash
# Git Branch Beautifier
parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
export PS1="\[\033[31m\]>\[\033[37m\]>\[\033[34m\]>\[\033[00m\] \[\033[32m\]\W\[\033[33m\]\$(parse_git_branch)\[\033[00m\] $ "

# Change the vagrant shared folder address according to your vagrant shared folder setting.
alias vagrant='cd /vagrant && clear && ls'

# Use the followings in your laravel project directory.
alias phpunit='./vendor/bin/phpunit'
alias artisan='php artisan'
alias serve='artisan serve --host=0.0.0.0'
vagrant
```

That's it! Happy coding!
