#!/bin/bash

export balance=0

function GetBalance
{
    read -r balance < "balance.txt"
}

function SetBalance
{
    balance=$1
    echo $balance > "balance.txt"
}