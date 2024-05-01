#!/bin/bash

# Incluir o arquivo com as funções de mensagem
source utils/message.sh
source utils/sleeps.sh
source utils/version-script.sh


# Função para executar verificações preliminares
perform_checks() {
    source scripts/check.sh
}

# Atualizar e preparar o sistema antes da execução principal
update_and_prepare() {
    sudo apt-get update
    sudo apt-get upgrade -y
    sudo apt-get install figlet -y
}

# Chamada principal do script de instalação
main() {
    # update_and_prepare
    # sleep_default

    print_title "QUASAR $SCRIPT_VERSION"
    sleep_warning

    print_subtitle "Checking OS...."
    perform_checks

    print_subtitle "Iniciando a instalação dos pacotes necessários"
    
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
    
    print_subtitle "Successful!"
}

main