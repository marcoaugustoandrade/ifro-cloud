# Definindo o nome do aluno
read -p 'Informe o nome-sobrenome do aluno: ' USUARIO

# Criando o container
sudo lxc launch ubuntu:18.04 $USUARIO

  # Acessando o container
  #sudo lxc exec $USUARIO -- bash

# Executando script no container
sudo lxc exec $USUARIO -- wget https://raw.githubusercontent.com/marcoaugustoandrade/ifro-cloud/master/script-container.sh
sudo lxc exec $USUARIO -- chmod +x /root/script-container.sh
sudo lxc exec $USUARIO ./script-container $USUARIO



