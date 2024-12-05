## Architecture
ARCH=$(uname -a)

## Processors
NPROC=$(grep "physical id" /proc/cpuinfo | wc -l)
NVPROC=$(grep "processor" /proc/cpuinfo | wc -l)

## RAM
RAM_USED=$(free -h | grep Mem | awk '{print $3}')
RAM_TOTAL=$(free -h | grep Mem | awk '{print $2}')
RAM_USE_P100=$(free --mega | grep Mem | awk '{printf("%.2f"), $3/$2*100}')

## DISK
DISK_USED=$(df -m | grep "/dev/" | grep -v "/boot" | awk '{disk_u += $3} END {print disk_u}')
DISK_TOTAL=$(df -m | grep "/dev" | grep -v "/boot" | awk '{disk_t += $2} END {printf ("%.1fGb\n"), disk_t/1024}')
DISK_P100=$(df -m | grep "/dev" | grep -v "/boot" | awk '{disk_u += $3} {disk_t += $2} END {printf("%d"), disk_u/disk_t*100}')

## Processes
CPU_LOAD=$(mpstat | grep all | awk '{print $6}')

# Last Boot
DTLREBOOT=$(who -b | grep system | awk '{print $5 " " $4 " " $3}') 

# Lvm Usage
HASLVM=$(if [ $(lsblk | grep "lvm" | wc -l) -gt 0 ]; then echo "LVM"; else echo "NO"; fi)

# Active Connections
ACTIVECON=$(ss -ta | grep ESTAB | wc -l)

#Users Logged On
USERACTIV=$(users | wc -w)

# Machine Ip
IP=$(hostname -I)
MAC=$(ip link | grep "link/ether" | awk '{print $2}')

COMWSUD=$(journalctl _COMM=sudo | grep COMMAND | wc -l)

wall "	Architecture: 	$ARCH
	CPU:		$NPROC
	vCPU:		$NVPROC
	Mem Usage:	$RAM_USED/$RAM_TOTAL ($RAM_USE_P100%)	
	Disk Usage:	$DISK_USED/$DISK_TOTAL ($DISK_P100%)
	CPU Load:	$CPU_LOAD%
	Last Boot:	$DTLREBOOT
	LVM Use:	$HASLVM
	TCP Conn:	$ACTIVECON ESTABLISHED
	Users loggd:	$USERACTIV
	IP/MAC:		$IP / $MAC
	cmd's sudo:	$COMWSUD Commands ran as sudo"
