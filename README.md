# Rocky Linux

Rocky Linux is a community-driven Enterprise Linux distribution— stable enough for the largest enterprise to rely on it,  
and community-driven to ensure it stays accessible to all.  
[About](https://wiki.rockylinux.org)

On this guide i won't delve that much into explaining all the commands, configurations, tools, etc...
This is up to you. As some people will just blindly copy and repeat what is here without really understading it.
The part of prepare and investigate for the defense is on you. Good Luck :P!!!

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

### Disk Partitioning

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

We will be prompted to the DISK ENXRYPTION PASSPHRASE Enter the Encryption passphrase for your disk and on the Passphrase and Again on the Confirm
<p align="center">
  <img src="https://github.com/sumxtx/Born2beRoot/blob/main/assets/2024-11-10_17-33.png" width="600" title="hover text">
</p>

Save Passphrase and Accept Changes  

### KDump
As the subject does not explicitly requires it, we are going to just disable 
<p align="center">
  <img src="https://github.com/sumxtx/Born2beRoot/blob/main/assets/2024-11-10_17-37.png" width="600" title="hover text">
</p>

### Network & Host Name
Next on Network & Host Name you should enter yours, mine gonna be just rocky42
<p align="center">
  <img src="https://github.com/sumxtx/Born2beRoot/blob/main/assets/2024-11-10_17-39.png" width="600" title="hover text">
</p>

_Apply_ and _Done_

### Root Password
Select a Root Password and click on _Done_
<p align="center">
  <img src="https://github.com/sumxtx/Born2beRoot/blob/main/assets/2024-11-10_17-44.png" width="600" title="hover text">
</p>

After that no User Creation is needed to Start the Installation, so we will do that later on, Just click on _Begin Installation_ on th bottom right
<p align="center">
  <img src="https://github.com/sumxtx/Born2beRoot/blob/main/assets/2024-11-10_17-46.png" width="600" title="hover text">
</p>

Wait for  the Installation to Complete and _Reboot System_
<p align="center">
  <img src="https://github.com/sumxtx/Born2beRoot/blob/main/assets/2024-11-10_17-51.png" width="600" title="hover text">
</p>

#### First boot
After Rebooting you will be prompt for the Disk Encryption Passphrase, Enter the one we used on the Installation Process
<p align="center">
  <img src="https://github.com/sumxtx/Born2beRoot/blob/main/assets/2024-11-10_17-53.png" width="600" title="hover text">
</p>

That will finish the boot process and prompt us for the login.
As we didn't create an user yet boot with the root account and the passphrase for the root
<p align="center">
  <img src="https://github.com/sumxtx/Born2beRoot/blob/main/assets/2024-11-10_17-55.png" width="600" title="hover text">
</p>

Update the system
```
dnf update
```
That may ask you to confirm a few times, press <kbd>y</kbd> and <kbd>Enter</kbd>
and Install a few packages 
```
dnf install sudo openssh vim
```
That may be already Installed by default, after that reboot again your system
```
reboot
```
### User Settings
After rebooting and login again with root let's create our user and groups

- Add user
```
useradd -c "Ying Yang" ying42
```
- Change User password
```
passwd ying42
```
- Add user to wheel group
```
usermod -aG wheel ying42
```
- Create user42 group
```
groupadd user42
```
- Add user to user42 group
```
usermod -aG user42 ying42
```
<p align="center">
  <img src="https://github.com/sumxtx/Born2beRoot/blob/main/assets/2024-11-10_18-11.png" width="600" title="hover text">
</p>

- Changing user to ying42
```
su ying42
```
And to double check we can 
```
exit
```
Until the login prompt again and try to login with the ying42 user
Than we can try to run a sudo command with the user tho confirm it can run sudo commands

```
sudo dnf update
```
<p align="center">
  <img src="https://github.com/sumxtx/Born2beRoot/blob/main/assets/2024-11-10_18-15.png" width="600" title="hover text">
</p>

If Everything is correct we can proceed, and disable the root login That's an extra measure
that you block the login with the root account

- Disable root login
```
sudo passwd -l root
```

### SSH

#### Installing SSH

#### SSH Server Hardening

- On the local machine (not server, the one you will ssh from) Generate a ssh key pair in case of not having one, or generate a new one exclusevily for this purpose 

```
cd ~/.ssh
ssh-keygen -C "web server1" -f id-web1 -t rsa -b 4096
```
<p align="center">
  <img src="https://github.com/sumxtx/Born2beRoot/blob/main/assets/2024-11-10_18-24.png" width="600" title="hover text">
</p>

- Copy the ssh key into the server with ssh-copy-id user@the ip of your machine
```
ssh-copy-id -i id-web1 ying42@192.168.345.356
```

<p align="center">
  <img src="https://github.com/sumxtx/Born2beRoot/blob/main/assets/2024-11-10_18-29.png" width="600" title="hover text">
</p>

We are still login with the user password, let's fix that in the next steps:
Back into the server machine
- Adjust semanage for ssh
```
sudo dnf install selinux-policy-targeted
sudo dnf install policycoreutils-python-utils
sudo semanage port -a -t ssh_port_t -p tcp 4242
```

Configure firewalld for ssh
```
sudo dnf install firewalld
sudo systemctl start firewalld
sudo firewall-cmd --permanent --add-port=4242/tcp
sudo firewall-cmd --reload
```

#### Configuring sshd_config file
- Edit /etc/ssh/sshd_config
```
sudo vim /etc/ssh/sshd_config
```
Uncomment and change the following values:
```
    Port 4242
    PermitRootLogin no
    MaxAuthTries 3
    MaxSessions 3
    PubkeyAuthentication yes
    PasswordAuthentication no
```

#### Test Connection
- restart sshd 
```
sudo systemctl restart sshd
```

- Check sshd status
```
sudo systemctl status sshd
```

- try to connect again from your machine but now using the following commands
```
ssh Youruser42@Theserverip -p 4242 -i ~/.ssh/id-web1
```
Now you should see that your are being ask the password of the ssh we generate earlier, that being said if you lost this key or this password youre completely remotely locked out of the server be aware

<p align="center">
  <img src="https://github.com/sumxtx/Born2beRoot/blob/main/assets/2024-11-10_18-45.png" width="600" title="hover text">
</p>

Now we are good to go.  
Nonetheless, try to log with different manners to see if all is correct  
For example, try to log with the root account, without the sshid, from another ports etc


<p align="center">
  <img src="https://github.com/sumxtx/Born2beRoot/blob/main/assets/2024-11-10_18-47.png" width="600" title="hover text">
</p>

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
