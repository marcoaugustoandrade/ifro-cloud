#!/bin/sh

# Definindo o nome do aluno
read -p 'Informe o nome-sobrenome do aluno: ' USUARIO

# Criando o container
sudo lxc launch ubuntu:18.04 $USUARIO
sleep 20

# Adicionando usuário padrão
sudo lxc exec $USUARIO -- useradd -p $(openssl passwd -1 Suporte99) suporte
sudo lxc exec $USUARIO -- usermod -s /bin/bash -d /home/suporte suporte
sudo lxc exec $USUARIO -- mkdir /home/suporte
sudo lxc exec $USUARIO -- chown suporte /home/suporte

# Colocando o usuário padrão no grupo sudors
sudo lxc exec $USUARIO -- usermod -aG sudo suporte

# Habilitando o acesso SSH
sudo lxc exec $USUARIO -- sed -i 's/#Port 22/Port 22/g' /etc/ssh/sshd_config
sudo lxc exec $USUARIO -- sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sudo lxc exec $USUARIO -- systemctl restart sshd

# Instalando o nodejs
sudo lxc exec $USUARIO -- snap install node --channel=10/stable --classic

# Instalando o LocalTunnel
sudo lxc exec $USUARIO -- npm install -g localtunnel

# Colocando o LocalTunnel no crontab
touch run.sh
echo "nohup lt --port 3000 --subdomain $USUARIO &" >> run.sh
echo "nohup lt --port 22 --subdomain $USUARIO-ssh &" >> run.sh
sudo lxc file push run.sh $USUARIO/home/suporte/run.sh
sudo lxc exec $USUARIO -- chmod +x /home/suporte/run.sh
rm run.sh

touch crontab.localtunnel
echo "@reboot root /home/suporte/run.sh" >> crontab.localtunnel
sudo lxc file push crontab.localtunnel $USUARIO/home/suporte/crontab.localtunnel
sudo lxc exec $USUARIO -- crontab /home/suporte/crontab.localtunnel
sudo lxc exec $USUARIO -- rm /home/suporte/crontab.localtunnel

parei aqui
/etc/crontab
#sudo lxc exec $USUARIO -- crontab -l > crontab.localtunnel
rm crontab.localtunnel


# Atualizando os pacotes do container
sudo lxc exec $USUARIO -- apt update
sudo lxc exec $USUARIO -- apt upgrade -y

# Reiniciando o container
sudo lxc stop $USUARIO
sudo lxc start $USUARIO

# Enviando email (instalar no servidor)
echo "Enviando email..."

