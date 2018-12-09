#!/bin/bash

source $(dirname $0)/balance.sh
source $(dirname $0)/carsInfo.sh
source $(dirname $0)/commonFunctions.sh
source $(dirname $0)/payments.sh

function BookingMenu
{
    clear
    
    echo "Menu | Booking"
    echo "1. Display available cars"
    echo "2. Display booked cars"
    echo "3. Book a car"
    echo "4. Unbook a car"
    
    local option
    read -n 1 -s -p "Press desired option number in order to continue or press R in order to return..." option
    
    case $option in
        1)
            ShowCars availableCars
            ToContinue
        ;;
        2)
            ShowCars bookedCars
            ToContinue
        ;;
        3)
            BookCar
        ;;
        4)
            UnbookCar
        ;;
        r|R)
            return
        ;;
    esac
    
    BookingMenu
}

function BookCar
{
    ShowCars availableCars
    
    local option
    read -p "Type in desired car number in order to book it or type in R in order to return: " option
    
    local optionFormat="^[1-9][0-9]*$"
    
    clear
    
    if [ "$option" == "r" ] || [ "$option" == "R" ]; then return; fi
    if [[ "$option" =~ $optionFormat ]]; then
        local carState=$(CheckIfCarExists availableCars $option)
        if [ $carState == 0 ]; then BookCar; return; fi
        
        local fullPrice=$(GetCarsPrice $option)
        local paymentInAdvance=$(($fullPrice/10))
        local isPaymentPossible=$(IsPaymentPossible $paymentInAdvance)
        
        if [ $isPaymentPossible -eq 0 ]; then
            echo "You do not have enough money to do the payment in advance (10% of the full price - $paymentInAdvance$)"
        else
            balance=$(($balance-$paymentInAdvance))
            SetBalance $balance
            
            TransferCar availableCars bookedCars $option
            echo "You have payed $paymentInAdvance$ for the booking."
        fi
    fi
    
    ToContinue
    BookCar
}

function UnbookCar
{
    ShowCars bookedCars
    
    local option
    read -p "Type in desired car number in order to unbook it or type in R in order to return: " option
    
    local optionFormat="^[1-9][0-9]*$"
    
    if [ "$option" == "r" ] || [ "$option" == "R" ]; then return; fi
    if [[ "$option" =~ $optionFormat ]]; then
        local carState=$(CheckIfCarExists bookedCars $option)
        if [ $carState == 0 ]; then UnbookCar; return; fi
        
        TransferCar bookedCars availableCars $option
    fi
    
    UnbookCar
}