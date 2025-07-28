#!/bin/bash

x=200

if [ $x -eq 200 ] 
then
    echo "x is 200"
else
    echo "x is not 200"
fi

if [ ! $x -eq 200 ] 
then
    echo "x is not 200"
else
    echo "x is 200"
fi