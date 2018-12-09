#!/bin/bash

source $(dirname $0)/balance.sh

function IsPaymentPossible
{
    local toPay=$1
    
    local leftOver=$(($balance-$toPay))
    
    if [ $leftOver -lt 0 ]; then
        echo 0
    else
        echo 1
    fi
}