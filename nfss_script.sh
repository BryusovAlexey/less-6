#!/bin/bash
#Административные права, на запуск команд
sudo -i

#Установка утилит
yum install nfs-utils -y

#Включение firewall и проверка, что он работает
systemctl enable firewalld --now
systemctl status firewalld

#Разрешение в firewall доступ к сервису NFS и рестарт сервиса
firewall-cmd --add-service="nfs3" \
--add-service="rpc-bind" \
--add-service="mountd" \
--permanent
firewall-cmd --reload

#Включение сервиса NFS
systemctl enable nfs --now

#Включение и настрока прав на директорию, которая будет экспортирована
mkdir -p /srv/share/upload
chown -R nfsnobody:nfsnobody /srv/share
chmod 0777 /srv/share/upload

#создание в файле /etc/exports структуру
cat << EOF > /etc/exports
/srv/share 192.168.50.11/32(rw,sync,root_squash)
EOF

#Экспорт ранее созданой директории
exportfs -r

#Перезагрузка ВМ
shutdown -r now

