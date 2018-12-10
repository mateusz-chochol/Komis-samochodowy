#!/bin/bash

source $(dirname $0)/carTables.sh

function FillCarsTables
{
    while read -r line; do
        allCars+=("$line")
    done < allCars.txt
    
    while read -r index; do
        index=$(echo $index | tr -dc '0-9')
        availableCars[$index]=${allCars[index]}
    done < availableCars.txt
    
    while read -r index; do
        index=$(echo $index | tr -dc '0-9')
        bookedCars[$index]=${allCars[index]}
    done < bookedCars.txt
    
    while read -r index; do
        index=$(echo $index | tr -dc '0-9')
        ownedCars[$index]=${allCars[index]}
    done < ownedCars.txt
}

function ShowCars
{
    clear
    
    local -n cars=$1
    
    if [ ${#cars[@]} -eq 0 ]; then
        echo "No cars to show"
        return
    fi
    
    echo "Cars list"
    
    IFS=$'\n'
    for car in ${cars[@]}; do
        local index=$(echo $car | cut -d ";" -f ${format["Id"]} | cut -d " " -f 2)
        local brand=$(echo $car | cut -d ";" -f ${format["Brand"]} | cut -d " " -f 2)
        local model=$(echo $car | cut -d ";" -f ${format["Model"]} | cut -d " " -f 2)
        
        echo $(($index+1))"." $brand $model
    done
    unset IFS
}

function PrintCarInfo
{
    local -n cars=$3
    local index=$(($1-1))
    local indices=${!cars[@]}
    local numberOfCars=$(echo $indices | grep -o '[^ ]*$')
    numberOfCars=$(($numberOfCars+1))
    
    if [ $1 -gt $numberOfCars ]; then
        echo "ERROR"
        sleep 2
        return
    fi
    
    local car=${cars[index]}
    
    local brand=$(echo $car | cut -d ";" -f ${format["Brand"]} | cut -d " " -f 2)
    local model=$(echo $car | cut -d ";" -f ${format["Model"]} | cut -d " " -f 2)
    local price=$(echo $car | cut -d ";" -f ${format["Price"]} | cut -d " " -f 2)
    local year=$(echo $car | cut -d ";" -f ${format["Year"]} | cut -d " " -f 2)
    local power=$(echo $car | cut -d ";" -f ${format["Power"]} | cut -d " " -f 2)
    local doors=$(echo $car | cut -d ";" -f ${format["Doors"]} | cut -d " " -f 2)
    local colour=$(echo $car | cut -d ";" -f ${format["Colour"]} | cut -d " " -f 2)
    local gearbox=$(echo $car | cut -d ";" -f ${format["Gearbox"]} | cut -d " " -f 2)
    local gears=$(echo $car | cut -d ";" -f ${format["Gears"]} | cut -d " " -f 2)
    local milleage=$(echo $car | cut -d ";" -f ${format["Milleage"]} | cut -d " " -f 2)
    
    echo $brand $model
    
    if [ "$2" == "terminal" ]; then
        printf "%s\n" "Brand: $brand" "Model: $model" "Price: $price" "Year: $year" "Power: $power" "Doors: $doors" "Colour: $colour" "Gearbox: $gearbox" "Gears: $gears" "Milleage: $milleage"
        elif [ "$2" == "file" ]; then
        printf "%s\n" "Brand: $brand" "Model: $model" "Price: $price" "Year: $year" "Power: $power" "Doors: $doors" "Colour: $colour" "Gearbox: $gearbox" "Gears: $gears" "Milleage: $milleage" > "$brand-$model.txt"
        echo "Car info saved in" "$brand-$model.txt"
    fi
}

function TransferCar
{
    local -n firstTable=$1
    local -n secondTable=$2
    
    local carIndex=$(($3-1))
    
    secondTable[$carIndex]=${firstTable[carIndex]}
    unset firstTable[$carIndex]
    
    sed -i "/$carIndex/d" ./"$1.txt"
    echo $carIndex >> ./"$2.txt"
}

function GetCarsPrice
{
    local index=$(($1-1))
    
    echo ${allCars[index]} | cut -d ";" -f ${format["Price"]} | cut -d " " -f 2
}

function CheckIfCarExists
{
    local -n cars=$1
    local -i carIndex=$(($2-1))
    
    if [ -z "${cars[carIndex]}" ]; then
        echo 0
    else
        echo 1
    fi
}

function FilterByCarBrand
{
    clear
    
    local -a carBrands=();
    local indices=${!availableCars[@]}
    local numberOfCars=$(echo $indices | grep -o '[^ ]*$')
    numberOfCars=$(($numberOfCars+1))
    
    echo "Car brands"
    for (( i=0; i<$numberOfCars; i++ ))
    {
        local carBrand=$(echo ${availableCars[i]} | cut -d ";" -f ${format["Brand"]} | cut -d " " -f 2)
        local carBrandRegex="^.*$carBrand.*$"
        
        if ! [[ "${carBrands[@]}" =~ $carBrandRegex ]]; then
            carBrands+=("$carBrand")
        fi
    }
    
    for (( i=0; i<${#carBrands[@]}; i++))
    {
        echo  "$(($i+1))." ${carBrands[i]}
    }
    
    local -i option
    read -p "Type in desired option number in order to continue (or type in anything else in order to return): " option
    
    if [ "$option" == 0 ]; then return; fi
    
    local selectedBrand=${carBrands[option-1]}
    local selectedBrandRegex="^.*$selectedBrand.*$"
    local -a carModels=()
    
    for (( i=0; i<$numberOfCars; i++ ))
    {
        if [[ "${availableCars[i]}" =~ $selectedBrandRegex ]]; then
            local model=$(echo ${availableCars[i]} | cut -d ";" -f ${format["Model"]} | cut -d " " -f 2)
            carModels+=("$model")
        fi
    }
    
    clear
    
    echo "$selectedBrand models:"
    for (( i=0; i<${#carModels[i]}; i++ ))
    {
        echo "$(($i+1))." ${carModels[i]}
    }
    
    ToContinue
    FilterByCarBrand
}