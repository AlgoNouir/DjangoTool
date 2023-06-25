#! /usr/bin/bash


# a tool for django

# create project

function create_project () {
    read -p "insert your project name: " name
    django-admin startproject "${name^^}" .
    mkdir Apps
}



# core
case $1 in
    startproject)
        create_project
    ;;
esac
