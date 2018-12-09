#!/bin/bash

source $(dirname $0)/balance.sh
source $(dirname $0)/carsInfo.sh
source $(dirname $0)/commonFunctions.sh
source $(dirname $0)/payments.sh

function BuyingMenu
{
    clear
    
    echo "Menu | Buying / Selling"
    echo "1. Display available cars"
    echo "2. Display owned cars"
    echo "3. Buy a car"
    echo "4. Sell a car"
    
    local option
    read -n 1 -s -p "Press desired option number in order to continue or press R in order to return..." option
    
    case $option in
        1)
            ShowCars availableCars
            ToContinue
        ;;
        2)
            ShowCars ownedCars
            ToContinue
        ;;
        3)
            BuyCar
        ;;
        4)
            SellCar
        ;;
        r|R)
            return
        ;;
    esac
    
    BuyingMenu
}

function BuyCar
{
    ShowCars availableCars
    
    local option
    read -p "Type in desired car number in order to buy it or type in R in order to return: " option
    
    local optionFormat="^[1-9][0-9]*$"
    
    clear
    
    if [ "$option" == "r" ] || [ "$option" == "R" ]; then return; fi
    if [[ "$option" =~ $optionFormat ]]; then
        local carState=$(CheckIfCarExists availableCars $option)
        if [ $carState == 0 ]; then BuyCar; return; fi
        
        local fullPrice=$(GetCarsPrice $option)
        local isPaymentPossible=$(IsPaymentPossible $fullPrice)
        
        if [ $isPaymentPossible -eq 0 ]; then
            echo "You do not have enough money to buy this car ($fullPrice$)"
        else
            ChoosePaymentType $fullPrice
            if [ $? == 1 ]; then BuyCar; return; fi
            
            balance=$(($balance-$fullPrice))
            SetBalance $balance
            
            TransferCar availableCars ownedCars $option
            echo "You have bought this car for $fullPrice$"
        fi
    fi
    
    PrintCarInfo $option "file" ownedCars
    ToContinue
    BuyCar
}

function SellCar
{
    ShowCars ownedCars
    
    local option
    read -p "Type in desired car number in order to sell it or type in R in order to return: " option
    
    local optionFormat="^[1-9][0-9]*$"
    
    clear
    
    if [ "$option" == "r" ] || [ "$option" == "R" ]; then return; fi
    if [[ "$option" =~ $optionFormat ]]; then
        local carState=$(CheckIfCarExists ownedCars $option)
        if [ $carState == 0 ]; then SellCar; return; fi
        
        TransferCar ownedCars availableCars $option
    fi
    
    local fullPrice=$(GetCarsPrice $option)
    balance=$(($balance+$fullPrice))
    SetBalance $balance
    
    echo "You have sold this car for $fullPrice$"
    
    ToContinue
    SellCar
}

function ChoosePaymentType
{
    clear
    
    local carPrice=$1
    
    echo "Menu | Payment type"
    echo "1. Credit card"
    echo "2. Cash"
    echo "3. Foreign currency"
    
    local option
    read -n 1 -s -p "Press desired option number in order to continue or press R in order to return..." option
    echo ""
    
    case $option in
        1)
            echo "You have chosen to pay with a credit card"
            return
        ;;
        2)
            echo "You have chosen to pay with cash"
            
            local cash
            read -p "Type in how much cash would you like to withdraw and pay with for that car: " cash
            
            local toReturn=$(($cash-$carPrice))
            
            if [ $cash -gt $balance ]; then
                echo "You do not have that much money to withdraw"
                sleep 2
                return 1
                elif [ $toReturn -lt 0 ]; then
                echo "Thats not enough"
                sleep 2
                return 1
                elif [ $toReturn -gt 0 ]; then
                echo "Car dealer returned to you $toReturn$"
            fi
            
            return
        ;;
        3)
            ForeignCurrenciesMenu $fullPrice
            return
        ;;
        r|R)
            return 1
        ;;
    esac
    
    ChoosePaymentType $1
}

function ForeignCurrenciesMenu
{
    clear
    
    echo "Menu | Foreign currencies"
    echo "1. Euro"
    echo "2. PLN"
    
    local option
    read -n 1 -s -p "Press desired currency number in order to continue or press R in order to return..." option
    echo ""
    
    case $option in
        1)
            printf "It cost you %d" $(($1*87/100))
            echo "EU"
            return
        ;;
        2)
            printf "It cost you %d" $(($1*376/100))
            echo "PLN"
            return
        ;;
        r|R)
            return
        ;;
    esac
    
    ForeignCurrenciesMenu $1
}