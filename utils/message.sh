#!/bin/bash

# Função para imprimir títulos
print_title() {
    # Gerar o texto ASCII art com figlet
    local title="$(figlet -f Doom "$1")"
    
    # Obter a largura do terminal
    local COLUMNS=$(tput cols)
    
    # Centralizar o texto
    echo "$title" | awk -v col=${COLUMNS} '{
        line=$0; gsub(/./, " ", line); space=(col-length($0))/2; 
        printf "%*s%s\n", space, "", $0 
    }'
}

# Função para imprimir mensagens de sucesso
print_subtitle() {
    echo -e "\e[38;2;255;215;0m$1\e[0m" | awk '{printf "%*s\n", int(('${COLUMNS:-$(tput cols)}' + length)/2), $0}'
}

# Função para imprimir mensagens normais centralizadas
print_message() {
    echo -e "\e[1;37m$1\e[0m" | awk '{printf "%*s\n", int(('${COLUMNS:-$(tput cols)}' + length)/2), $0}'
}


# Função para imprimir mensagens de aviso
print_warning() {
    echo -e "\e[1;33mAVISO: $1\e[0m" | awk '{printf "%*s\n", int(('${COLUMNS:-$(tput cols)}' + length)/2), $0}'
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
