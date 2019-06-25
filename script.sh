# Criando usuário
useradd suporte
usermod -s /bin/bash suporte

# Definindo a senha padrão
echo -e "Suporte99\nSuporte99" | passwd suporte

# Colocando o usuário no grupo sudors
usermod -aG sudo suporte

# Habilitando o acesso SSH
sed -i 's/#Port 22/Port 22/g' /etc/ssh/sshd_config
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
systemctl restart sshd

# Baixando o ngrok
wget https://github.com/marcoaugustoandrade/ifro-cloud/blob/master/ngrok?raw=true

# Redirecionando o SSH (to 20)
./ngrok http 22 subdomain

# Redirecionando o Web Server (to 3000)
./ngrok http 3000

# Solicitando troca de senha no próximo login
chage -d 0 suporte

# Atualizando os pacotes do container
apt update
apt upgrade -y

# Enviando email
apt install mutt

Título: Acesso ao IFRO-VLH Cloud
Corpo:
Para acessar seu container via SSH utilize:
ssh suporte@nome-sobrenome.ssh@adsvilhena.app -P

A senha padrão é Suporte99, mas será solicitado a troca da senha no primeiro acesso.

Para acessar o webserver utilize:
http://nome-sobrenome.adsvilhena.app


