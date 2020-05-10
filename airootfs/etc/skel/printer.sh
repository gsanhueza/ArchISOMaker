#!/bin/bash

print_light()
{
    printf "$1\n"
}

print_trailing()
{
    printf "$1"
}

print_message()
{
    printf "$(tput bold)${1}$(tput sgr0)\n"
}

print_failure()
{
    printf "$(tput bold)$(tput setaf 1)${1}$(tput sgr0)\n"
}

print_success()
{
    printf "$(tput bold)$(tput setaf 2)${1}$(tput sgr0)\n"
}

print_warning()
{
    printf "$(tput bold)$(tput setaf 3)${1}$(tput sgr0)\n"
}
