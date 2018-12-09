#!/bin/bash

source $(dirname $0)/balance.sh

function ToContinue
{
    read -n 1 -s -p "Press any key in order to return..."
    echo ""
}

function SetTotalMoney
{
    clear
    
    local money
    read -p "Type in how much money do you have: " money
    
    local moneyFormat="^[0-9]+$"
    
    if [[ "$money" =~ $moneyFormat ]]; then
        SetBalance $money
    else
        echo "ERROR."
        sleep 2
    fi
}