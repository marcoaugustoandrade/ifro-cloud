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

# Colocando o LocalTunnel na inicialização
touch rc.local
echo "nohup lt --port 3000 --subdomain $USUARIO 2>&1 &" >> rc.local
echo "nohup lt --port 22 --subdomain $USUARIO-ssh 2>&1 &" >> rc.local
sudo lxc file push rc.local $USUARIO/etc/
sudo lxc exec $USUARIO -- chmod +x /etc/rc.local
rm rc.local

# Atualizando os pacotes do container
sudo lxc exec $USUARIO -- apt update
sudo lxc exec $USUARIO -- apt upgrade -y

# Reiniciando o container
sudo lxc stop $USUARIO
sudo lxc start $USUARIO

# Enviando email (instalar no servidor)
echo "Enviando email..."

