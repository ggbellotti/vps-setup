#!/bin/bash

# Função para imprimir títulos
print_title() {
    echo -e "\e[1;34m$1\e[0m" | awk '{printf "%*s\n", int(('${COLUMNS:-$(tput cols)}' + length)/2), $0}'
}

# Função para imprimir mensagens de sucesso
print_subtitle() {
    echo -e "\e[1;36m$1\e[0m" | awk '{printf "%*s\n", int(('${COLUMNS:-$(tput cols)}' + length)/2), $0}'
}

# Função para imprimir mensagens normais centralizadas
print_message() {
    echo -e "\e[1;37m$1\e[0m" | awk '{printf "%*s\n", int(('${COLUMNS:-$(tput cols)}' + length)/2), $0}'
}


# Função para imprimir mensagens de aviso
print_warning() {
    echo -e "\e[1;33m$1\e[0m" | awk '{printf "%*s\n", int(('${COLUMNS:-$(tput cols)}' + length)/2), $0}'
}

# Função para imprimir mensagens de erro
print_error() {
    echo -e "\e[1;31m$1\e[0m" | awk '{printf "%*s\n", int(('${COLUMNS:-$(tput cols)}' + length)/2), $0}'
    sleep 2  # Dá tempo para o usuário ler a mensagem de erro
}

# Função para imprimir mensagens de sucesso
print_success() {
    echo -e "\e[1;32m$1\e[0m" | awk '{printf "%*s\n", int(('${COLUMNS:-$(tput cols)}' + length)/2), $0}'
}

# Função para animar uma mensagem (simples efeito de digitação)
print_animated() {
    local message="$1"
    local delay="${2:-0.1}"  # Default delay between characters
    for (( i=0; i<${#message}; i++ )); do
        echo -n "${message:$i:1}"
        sleep $delay
    done
    sleep 5
    echo  # Move to the new line after animation
}
