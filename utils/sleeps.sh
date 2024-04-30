#!/bin/bash

# Pausa padrão de 2 segundos
sleep_default() {
    sleep 2
}

# Pausa mais longa de 5 segundos para avisos
sleep_warning() {
    sleep 5
}

# Pausa de 10 segundos para alertas importantes
sleep_alert() {
    sleep 10
}

# Função para verificar o status de um serviço repetidamente
check_service() {
    while true; do
        print_title "Verificando o status do serviço..."
        
        # Executa o comando fornecido para verificar o serviço
        local service_status=$($command_to_check)

        if [ "$service_status" == "$ok_status" ]; then
            print_message "Serviço está rodando normalmente."
            sleep_default
        elif [ "$service_status" == "$warning_status" ]; then
            print_error "Atenção: serviço está mostrando sinais de instabilidade."
            sleep_warning
        else
            print_error "Alerta: serviço não está respondendo!"
            sleep_alert
        fi
    done
}
