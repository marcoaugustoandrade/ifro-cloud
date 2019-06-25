# Definindo o nome do aluno
read -p 'Informe o nome-sobrenome do aluno: ' USUARIO
# USUARIO="marco-andrade"

# Criando o container
sudo lxc launch ubuntu:18.04 $USUARIO

# Acessando o container
sudo lxc exec $USUARIO -- bash

# Criando o usuário
echo -e "Suporte99\nSuporte99" | adduser $USUARIO
usermod -s /bin/bash suporte

# Colocando o usuário no grupo sudors
usermod -aG sudo suporte

# Habilitando o acesso SSH
sed -i 's/#Port 22/Port 22/g' /etc/ssh/sshd_config
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
systemctl restart sshd

# Instalando o nodejs
snap install node --channel=10/stable --classic

# Instalando o LocalTunnel
npm install -g localtunnel

# Colocando o LocalTunnel na inicialização
touch /etc/rc.local
echo "lt --port 3000 --subdomain $USUARIO" >> /etc/rc.local
echo "lt --port 22 --subdomain $USUARIO-ssh" >> /etc/rc.local
chmod +x /etc/rc.local

# Atualizando os pacotes do container
apt update
apt upgrade -y


