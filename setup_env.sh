#!/bin/bash
# Setup .env file
# keys                                  default values
keys=( )                                ; vals=( )
keys[0]='NEXTCLOUD_ADMIN_USER'          ; vals[0]='admin'
keys[1]='NEXTCLOUD_ADMIN_PASSWORD'      ; vals[1]='password'
keys[2]='POSTGRES_HOST'                 ; vals[2]='postgres'
keys[3]='POSTGRES_USER'                 ; vals[3]='postgres'
keys[4]='POSTGRES_PASSWORD'             ; vals[4]='postgres_password'
keys[5]='POSTGRES_DB'                   ; vals[5]='nextcloud'
keys[6]='TRUSTED_PROXIES'               ; vals[6]='nginx'
keys[7]='NEXTCLOUD_TRUSTED_DOMAINS'     ; vals[7]='127.0.0.1'
keys[8]='OVERWRITEHOST'                 ; vals[8]='10.0.0.1:80'
keys[9]='OVERWRITEPROTOCOL'             ; vals[9]='https'
keys[10]='OVERWRITEWEBROOT'             ; vals[10]='/'
keys[11]='NEXTCLOUD_TRUSTED_DOMAINS'    ; vals[11]=''

env="# .env file"

echo -e ${env}
echo -e "# leave empty to use default"

for i in ${!keys[@]}; do
    # read input
    read -p "# set value for ${keys[i]} (default: ${vals[i]}): " value
    # set default if nothing inputted
    if [ -z "${value}" ]; then
        value=${vals[i]}
    fi
    # edit env text
    env+="\n${keys[i]}=${value}"
done

echo -e ${env} > .env
cat .env
