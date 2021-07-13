#!/bin/sh
echo "parando nginx"
systemctl stop nginx

echo "garantindo que o serviço esta parado"
NGINX_STOP=$(sudo systemctl | egrep 'nginx')
if [[ -z "$NGINX_STOP" ]]
then
    echo "checando se /opt/funcional existe"
    if [[ -d /opt/funcional ]]
    then
        echo "/opt/funcional existe no sistema."
        DATA_BACKUP=$(date '+%F-%H%M')
        tar -zcvf funcional-backup-$DATA_BACKUP.tar.gz /opt/funcional
        systemctl start nginx
        NGINX_STOP=$(sudo systemctl | egrep 'nginx')
        if [[ -z "$NGINX_STOP" ]]
        then
            echo "NGINX continua parado."
            exit 1        
        else
            echo "NGINX rodando."
            echo
            echo "Script Concluido."
            exit 0
        fi   
    else
        echo "/opt/funcional não existe no sistema."
        exit 1
    fi

else
    echo "NGINX não esta parado."
    exit 1
fi

