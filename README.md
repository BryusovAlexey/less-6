# Less-6 

Задание  
Научиться самостоятельно развернуть сервис NFS и подключить к нему клиента.
Vagrant file Содержит 2 скрипта для сервера и клиента.  
Автоматическая настройка NFS, Firewall, права доступа, шара на директорию Upload, монтирование на клиенте директории Upload.  

Серверная часть NFSS  

alex-linux@alexlinux:~/linux-vm/less-6$ vagrant ssh nfss  
- Административные права  
[vagrant@nfss ~]$ sudo -i  

- Переход в каталог созданый ранее скриптом  
[root@nfss ~]# cd /srv/share/upload   
- Создание файла в каталоге  

[root@nfss upload]# touch server_file 
[root@nfss upload]# ls  
server_file  
- Проверка, что созданый файл на клиенте появился на сервере
[root@nfss upload]# ls  
client_file  server_file   

- Проверка статуса сервера NFS  
[root@nfss upload]# systemctl status nfs  
● nfs-server.service - NFS server and services  
   Loaded: loaded (/usr/lib/systemd/system/nfs-server.service; enabled; vendor preset: disabled)  
  Drop-In: /run/systemd/generator/nfs-server.service.d  
           └─order-with-mounts.conf  
   Active: active (exited) since Fri 2023-02-24 21:57:24 UTC; 4min 36s ago  
  Process: 812 ExecStartPost=/bin/sh -c if systemctl -q is-active gssproxy; then systemctl reload gssproxy ; fi (code=exited, status=0/SUCCESS)  
  Process: 789 ExecStart=/usr/sbin/rpc.nfsd $RPCNFSDARGS (code=exited, status=0/SUCCESS)  
  Process: 784 ExecStartPre=/usr/sbin/exportfs -r (code=exited, status=0/SUCCESS)  
 Main PID: 789 (code=exited, status=0/SUCCESS) 
   CGroup: /system.slice/nfs-server.service  

Feb 24 21:57:23 nfss systemd[1]: Starting NFS server and services...  
Feb 24 21:57:24 nfss systemd[1]: Started NFS server and services.  
- Проверка статуса Фаервола
[root@nfss upload]# systemctl status firewalld  
● firewalld.service - firewalld - dynamic firewall daemon  
   Loaded: loaded (/usr/lib/systemd/system/firewalld.service; enabled; vendor preset: enabled)  
   Active: active (running) since Fri 2023-02-24 21:57:19 UTC; 4min 56s ago  
     Docs: man:firewalld(1)  
 Main PID: 403 (firewalld)  
   CGroup: /system.slice/firewalld.service  
           └─403 /usr/bin/python2 -Es /usr/sbin/firewalld --nofork --nopid  

Feb 24 21:57:17 nfss systemd[1]: Starting firewalld - dynamic firewall daemon...  
Feb 24 21:57:19 nfss systemd[1]: Started firewalld - dynamic firewall daemon.  
Feb 24 21:57:19 nfss firewalld[403]: WARNING: AllowZoneDrifting is enabled. This is considered an insecure configuration option. It will be removed in a future release. Please consider disabling it now.  

-Проверка статуса создания каталога и права доступа
[root@nfss upload]# exportfs -s  
/srv/share  192.168.50.11/32(sync,wdelay,hide,no_subtree_check,sec=sys,rw,secure,root_squash,no_all_squash)  
[root@nfss upload]# showmount -a 192.168.50.10  
All mount points on 192.168.50.10: 
192.168.50.11:/srv/share  

Клиентская часть
- Подключение к клиенту  
alex-linux@alexlinux:~/linux-vm/less-6$ vagrant ssh nfsc  

- Переход в каталог, что был создан ранее скриптом и подмонтирован  
[vagrant@nfsc ~]$ cd /mnt/upload  

-Проверка доступа созданого файла на сервере NFSS  
[vagrant@nfsc upload]$ ls  
server_file  

- cоздание файла на клиенте NFSC  
[vagrant@nfsc upload]$ touch client_file  

- проверяем работу RPC  
[vagrant@nfsc upload]$ showmount -a 192.168.50.10  
All mount points on 192.168.50.10:  
192.168.50.11:/srv/share  

- проверяем статус монтирования
[vagrant@nfsc upload]$ mount | grep mnt  
systemd-1 on /mnt type autofs (rw,relatime,fd=21,pgrp=1,timeout=0,minproto=5,maxproto=5,direct,pipe_ino=10958)  
192.168.50.10:/srv/share/ on /mnt type nfs (rw,relatime,vers=3,rsize=32768,wsize=32768,namlen=255,hard,proto=udp,timeo=11,retrans=3,sec=sys,mountaddr=192.168.50.10,mountvers=3,mountport=20048,mountproto=udp,local_lock=none,addr=192.168.50.10)  


# less-6
