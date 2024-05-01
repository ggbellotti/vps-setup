#!/bin/bash

# Incluir o arquivo com as funções de mensagem
source utils/message.sh

# Verifica se o script está sendo executado como superusuário (root)
if [ "$(id -u)" != "0" ]; then
    print_error "Este script deve ser executado como superusuário (root)."
    exit 1
fi

# Verifica se o usuário está usando o Bash
if [ -z "$BASH_VERSION" ]; then
    print_error "Este script deve ser executado com o Bash."
    exit 1
fi

# Verifica a versão do sistema operacional
print_message "Verificando sistema operacional..."
os_info=$(lsb_release -d)
if [[ ! $os_info =~ (Ubuntu 20\.04|Ubuntu 22\.04) ]]; then
    print_warning "O sistema recomendado é Ubuntu 22.04 ou 20.04. Sistemas diferentes ou versões diferentes podem causar incompatibilidade."
    exit 1
fi