### Install System


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

