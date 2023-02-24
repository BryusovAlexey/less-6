#!/bin/bash
#Административные права, на запуск команд
sudo -i

#Включение firewall и проверка, что он работает
systemctl enable firewalld --now
systemctl status firewalld

#добавляем в /etc/fstab строку
echo "192.168.50.10:/srv/share/ /mnt nfs vers=3,proto=udp,noauto,x-systemd.automount 0 0" >> /etc/fstab

#перезагрузка сервисов
systemctl daemon-reload
systemctl restart remote-fs.target

#монтирование Шары
mount -t nfs 192.168.50.10:/srv/share /mnt/     
mount -t nfs
mount -t nfs4

#Перезагрузка ВМ
shutdown -r now