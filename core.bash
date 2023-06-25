#! /usr/bin/bash


# a tool for django

# create project
PS3="Enter a number: "

items=(
    'create project'
    'start app'
)

select character in "${items[@]}"
do
    echo "Selected character: $character"
    echo "Selected number: $REPLY"
done
