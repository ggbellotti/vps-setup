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

# Carrega a lista de pacotes a partir de um arquivo externo
source scripts/packages.sh

# Função para configurar o Docker
configure_docker() {
    print_message "Instalando chave GPG do Docker..."
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    print_message "Adicionando o repositório do Docker ao sistema..."
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update

    print_message "Instalando o Docker..."
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io

    if docker --version &> /dev/null; then
        print_success "Docker instalado com sucesso!"
    else
        print_error "Falha ao instalar o Docker."
    fi
}

# Verificar e instalar pacotes
for pkg in "${packages[@]}"; do
    if dpkg -s $pkg &> /dev/null; then
        print_success "Pacote $pkg está instalado."
        echo "Versão do pacote $pkg: $(dpkg -s $pkg | grep Version)"
    else
        print_warning "Pacote $pkg NÃO está instalado. Tentando instalar..."
        if [[ "$pkg" == "docker-ce" ]]; then
            configure_docker
        else
            sudo apt-get install -y $pkg
            if [ $? -eq 0 ]; then
                print_success "Pacote $pkg instalado com sucesso."
            else
                print_error "Falha ao instalar o pacote $pkg."
            fi
        fi
    fi
done