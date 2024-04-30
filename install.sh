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
    
    print_subtitle "Successful!"
}

main