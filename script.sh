# Definindo o nome do aluno
read -p 'Informe o nome-sobrenome do aluno: ' USUARIO
# USUARIO="marco-andrade"

# Criando o container
sudo lxc launch ubuntu:18.04 $USUARIO

  # Acessando o container
  #sudo lxc exec $USUARIO -- bash

# Executando script no container
sudo lxc-attach
 wget script-container.sh && ./script-container <<




