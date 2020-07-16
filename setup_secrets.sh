#!/bin/bash

# Setup docker secrets before run docker-compose build

keys=( 
    'nextcloud_admin_user'
    'nextcloud_admin_password'
    'postgres_db'
    'postgres_user'
    'postgres_password'
)

function setup_secrets {

    # setup mount targets
    if [ ! -d nextcloud ]; then
        mkdir nextcloud
    fi
    if [ ! -d database ]; then
        mkdir database
    fi

    echo -e "Setup docker secrets \n"

    template="docker secret create"
    ret=""

    for key in ${keys[@]}; do
        # echo $key
        read -p "Set secert for <${key}>: " value
        # echo -e "\nprintf ${value} | ${template} ${key} -"
        # printf ${value} | ${template} ${key} -
        echo ${value} > "${key}.txt"
        if [ $? -ne 0 ]; then
            echo -e "Failed"
            ret=${key}
            break
        fi
        echo
    done

    # clear sensitive info
    clear

    if [ -z ${ret} ]; then
        echo -e "Docker secrets are ready to use."
        # docker secret ls
        ls -l *.txt
    else
        echo -e "Docker secrets setup failed: ${ret}."
    fi
}

function remove_secrets {
    for key in ${keys[@]}; do
        # echo $key
        echo -e "docker secret rm ${key}"
        # docker secret rm ${key}
        rm -f "${key}.txt"
        if [ $? -ne 0 ]; then
            echo -e "Remove failed"
            ret=${key}
            break
        fi
        echo
    done
}

if [ $# -ne 0 ]; then
    if [ $# -eq 1 ] && [ $1 == 'rm' ]; then
        remove_secrets
    else
        echo -e "Usage:\nSetup secrets  -> $0\nRemove secrets -> $0 rm"
    fi
else
    setup_secrets
fi
