#!/bin/bash

source $(dirname $0)/balance.sh
source $(dirname $0)/carsInfo.sh
source $(dirname $0)/booking.sh
source $(dirname $0)/buying.sh
source $(dirname $0)/commonFunctions.sh

GetBalance
FillCarsTables

function ShowParticularCar
{
    ShowCars availableCars
    
    local option
    read -p "Type in desired option number in order to continue or type in R in order to return: " option
    
    clear
    
    local optionFormat="^[1-9][0-9]*$"
    
    if [ "$option" == "r" ] || [ "$option" == "R" ]; then return; fi
    if [[ "$option" =~ $optionFormat ]]; then PrintCarInfo $option "terminal" availableCars; fi
    
    ToContinue
    ShowParticularCar
}

function TestDrive
{
    clear
    
    ShowCars availableCars
    echo "Test drive appointment"
    
    local option
    read -p "Type in desired option number in order to continue or type in R in order to return: " option
    
    local optionFormat="^[1-9][0-9]*$"
    
    if [ "$option" == "r" ] || [ "$option" == "R" ]; then return; fi
    if ! [[ "$option" =~ $optionFormat ]]; then TestDrive; return; fi
    
    local date
    read -p "Type in the date of the test drive (dd-mm-yyyy): " date
    
    local dateFormat="^([0-2][0-9]|(3)[0-1])-(((0)[0-9])|((1)[0-2]))-[0-9]{4}$"
    if ! [[ "$date" =~ $dateFormat ]]; then
        echo "Wrong date format"
        TestDrive
        return
    fi
    
    PrintCarInfo $option "terminal" availableCars
    echo "Test drive on $date appointed."
    ToContinue
}

function Menu
{
    clear
    
    echo "Menu | Car dealer | Available money: $balance"
    echo "1. Display all available cars"
    echo "2. Display info about a particular car"
    echo "3. Book / unbook a car"
    echo "4. Buy / sell a car"
    echo "5. Filter by a car brand"
    echo "6. Appoint test drive"
    echo "7. Set total money amount"
    
    local option
    read -n 1 -s -p "Press desired option number in order to continue..." option
    
    case $option in
        1)
            ShowCars availableCars
            ToContinue
        ;;
        2)
            ShowParticularCar
        ;;
        3)
            BookingMenu
        ;;
        4)
            BuyingMenu
        ;;
        5)
            FilterByCarBrand
        ;;
        6)
            TestDrive
        ;;
        7)
            SetTotalMoney
        ;;
    esac
    
    Menu
}

Menu