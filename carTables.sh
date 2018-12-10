#!/bin/bash

declare -A format=(["Id"]=1 ["Brand"]=2 ["Model"]=3 ["Price"]=4 ["Year"]=5 ["Power"]=6 ["Doors"]=7 ["Colour"]=8 ["Gearbox"]=9 ["Gears"]=10 ["Milleage"]=11)

declare -a allCars=()
declare -a availableCars=()
declare -a bookedCars=()
declare -a ownedCars=()

export format
export allCars
export availableCars
export bookedCars
export ownedCars