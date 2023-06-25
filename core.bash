#! /usr/bin/bash


# a tool for django

# create project


function getEnv {
    cat .env  2> /dev/null | grep "$1" | awk -F '[=]' '{ print $2 }'
}

function create_project () {
    read -p "insert your project name: " name
    django-admin startproject "${name^^}" .
    mkdir Apps
    echo ALGO_DJANGO_TOOL="installed" >> .env
}

function create_app () {
    cd Apps || mkdir Apps && cd Apps || exit
}





# check project installed
if [ "$(getEnv ALGO_DJANGO_TOOL)" != 'installed' ] && [ "$1" != "startproject" ]; then
    read -p "env not set would you want to install project? [Y/n ] " ans
    if [ "$ans" != "n" ];then
        create_project
    fi

fi

# core
case $1 in
    startproject)
        if [  "$(getEnv ALGO_DJANGO_TOOL)" != 'installed'  ]; then
            create_project
        else
            echo "you allredy install the project"
        fi
    ;;
    createapp)
        create_app
    ;;
esac
