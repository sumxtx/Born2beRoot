# dnf
dnf is the next generation of the yum package manager for .rpm-based linux distros it can be used exactly as yum to search, install or remove packages

## Cheat Sheet

### Common
```
dnf search packageName
```

```
dnf info packageName
```

```
dnf install packageName
```

```
dnf remove packageName
```

```
dnf autoremove
```

Check for Updates but do not install them
```
dnf check-update
```
Reverts previous state of a package
```
dnf downgrade
```


### Upgrading 
```
dnf upgrade
```
Exclude a package from the transaction
```
dnf upgrade --exclude=packageName
```
vim /etc/dnf/dnf.conf
```
excludepkgs=packageName
```
