#!/bin/bash

# Incluir o arquivo com as funções de mensagem
# source utils/message.sh

# # Exemplo de uso das funções de mensagem
# print_title "Título"
# print_subtitle "subtitulo"
# print_success "sucesso"
# print_animated "animado"
# print_message "Mensagem"
# print_error "Mensagem de erro"



figlist | awk '/fonts/ {f=1;next} /control/ {f=0} f {print}' | while read font; do
  echo "=== $font ==="
  echo $font | figlet -f $font
done | less