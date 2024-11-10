# Rocky Linux

Rocky Linux is a community-driven Enterprise Linux distribution— stable enough for the largest enterprise to rely on it,  
and community-driven to ensure it stays accessible to all.  
[About](https://wiki.rockylinux.org)

## Download  
### OS Installation Prerequisites  

Download the ISO to use for this installation of Rocky Linux.  
> You can download the latest ISO image for the version of Rocky Linux for this installation [here](https://www.rockylinux.org/download/)

To download the ISO directly from the command line on an existing Linux-based system:  

> Chose your closest mirror [here](https://mirrors.rockylinux.org/mirrormanager/mirrors)  

Use the wget command:  
> *wget https://__Your chosen mirror__/9/isos/x86_64/__Rocky-<MAJOR#>.<MINOR#>-<ARCH#>-<VARIANT#>.iso__*

For example I am going to use the __DE__ (Germany, geographically closer to me and tend to have pretty reliable and fast servers)  
version=9.4, architecture=x86_64, variant=minimal:  
```
wget https://de.mirrors.cicku.me/rocky/9/isos/x86_64/Rocky-9.4-x86_64-minimal.iso
```
#### Verifying the Installation ISO File
---
Once the download is complete we are going to check if the ISO file is not corrupted, and is the one we are pretending to install.  
First we need to also download the CHECKSUM file, a SHA-256 hash of the file.  
```
wget https://de.mirrors.cicku.me/rocky/9/isos/x86_64/CHECKSUM
```
And compare it to the SHA-256 hash of the ISO file we have downloaded.  
```
sha256sum -c CHECKSUM --ignore-missing
```
We should get an ok message  
> Rocky-9.4-x86_64-minimal.iso: OK  

### Setting up the Virtualization Engine
That is up to what you are using: Virtualbox,VMWare,Virt-Manager... And how many resources you're allowed to assign to the VM  
For Exampple in my campus, at most 30GB is what our Infra has allowed.  

Doing this at home I will assign the following resources to my machine:  
| Boot       | CPU        | Ram     | Disk      | Network | SATA        |
|------------|------------|---------|-----------|---------|-------------|
| UEFI       | 2 Cores    | 8 GB    | 100 GB    | NAT     | Rocky....iso|

And Boot it up

## Installing the System
After Booting you should get the Select Language page, chose your preferred  
<p align="center">
  <img src="https://github.com/sumxtx/Born2beRoot/blob/main/assets/2024-11-10_15-26.png" width="600" title="hover text">
</p>

After that you will get to the Installation Summary
<p align="center">
  <img src="https://github.com/sumxtx/Born2beRoot/blob/main/assets/2024-11-10_16-41.png" width="600" title="hover text">
</p>

Go to The __System > Installation Destination__ To Start Partitioning.  
Here you should Select :white_check_mark: __Custom__, and :white_check_mark: __Done__.  
<p align="center">
  <img src="https://github.com/sumxtx/Born2beRoot/blob/main/assets/2024-11-10_16-44.png" width="600" title="hover text">
</p>

Next chose Partitioning Scheme :white_check_mark: LVM and :white_check_mark: Encrypt my data  
After that __DON'T hit Done__ go to  > *Click here to create them automatically* instead
<p align="center">
  <img src="https://github.com/sumxtx/Born2beRoot/blob/main/assets/2024-11-10_16-50.png" width="600" title="hover text">
</p>

That will generate some default partitions partitions and random size, we gonna edit them according to our needs  
<p align="center">
  <img src="https://github.com/sumxtx/Born2beRoot/blob/main/assets/2024-11-10_16-57.png" width="600" title="hover text">
</p>

As i have 100Gb available and minding the bonus part as well, that will be my disk layout:  
| /      | /home  | /var   | /srv   | /tmp   | /var/log   | swap   |
|--------|--------|--------|--------|--------|------------|--------|
| 30G    | 15G    | 9G     | 15G    | 9G     | 12G        | 8GB    |

Doing that on an Infra with let's say 30Gb, shoulda something look like this:
| /      | /home  | /var   | /srv   | /tmp   | /var/log   | swap   |
|--------|--------|--------|--------|--------|------------|--------|
| 10G    | 5G     | 3G     | 3G     | 3G     | 4G         | 2GB    |

Click on _/home_ and in __Desired Capacity__ on the right side box, enter your amount  
The Same for _/_ 
<p align="center">
  <img src="https://github.com/sumxtx/Born2beRoot/blob/main/assets/2024-11-10_17-07.png" width="600" title="hover text">
</p>

After that on the + Sign on the bottom left 
<p align="center">
  <img src="https://github.com/sumxtx/Born2beRoot/blob/main/assets/2024-11-10_17-09.png" width="600" title="hover text">
</p>

we are going to enter our __Desired Mount Point__, and the __Desired Capacity__, for example  
for the _/var_ mount point i need 15G, it would look like this:
<p align="center">
  <img src="https://github.com/sumxtx/Born2beRoot/blob/main/assets/2024-11-10_17-10.png" width="600" title="hover text">
</p>

Select __Add Mount Point__ and repeat the same for _/srv_ _/tmp_ _/var/log_ and _swap_  
Notice _swap_ don't have _/_ before the name, as it is not mountable  
Ensure everythin is correct and now we can click on __Done__
<p align="center">
  <img src="https://github.com/sumxtx/Born2beRoot/blob/main/assets/2024-11-10_17-21.png" width="600" title="hover text">
</p>



- Ensure Installed sudo

### User Settings

- Add user
-[root@localhost root]# useradd -c "Ying Yang" ying
- Change User password
[root@localhost root]# passwd ying
- Add user to wheel group
[root@localhost root]# usermod -aG wheel sammy
- Disable root login
> sudo passwd -l root

### SSH

#### Installing SSH
- Ensure Installed openssh

#### SSH Server Hardening

On the local machine (not server, the one you will ssh from)  
Generate a ssh key pair in case of not having one  

```
cd ~/.ssh
ssh-keygen -C "web server1" -f id-web1 -t rsa -b 4096
```

Copy the ssh key into the server with ssh-copy-id
```
ssh-copy-id -i id-web1 user@server.ip.address
```

Adjust semanage for ssh
```
dnf install selinux-policy-targeted
dnf install policycoreutils-python-utils
semanage port -a -t ssh_port_t -p tcp 4242
```

Configure firewalld for ssh
```
dnf install firewalld
systemctl start firewalld
firewall-cmd --permanent --add-port=PORT/tcp
firewall-cmd --reload
```
#### Configuring sshd_config file
- Edit /etc/ssh/sshd_config
    Port 4242
    PermitRootLogin no
    PasswordAuthentication no
    PubkeyAuthentication yes

#### Test Connection
- restart sshd 
- try to connect 
```
ssh user@serverip -p 4242 -i ~/.ssh/id-web1
```

### Configurate sudo policies

#### sudo general config and logs
mkdir /var/log/sudo
edit /etc/sudoers.d/sudo_config
Defaults  passwd_tries=3
Defaults  badpass_message="Mensaje de error personalizado"
Defaults  logfile="/var/log/sudo/sudo_config"
Defaults  log_input, log_output
Defaults  iolog_dir="/var/log/sudo"
Defaults  requiretty
Defaults  secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin"

#### sudo password policies
edit /etc/login.defs
PASS_MAX_DAYS: 30
PASS_MIN_DAYS: 2
PASS_WARN_AGE: 7

#### pampwquality password configuration
edit /etc/pam.d/system-auth
remeber=5
