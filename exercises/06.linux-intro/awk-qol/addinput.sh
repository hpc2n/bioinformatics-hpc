#!/bin/bash
echo "This program adds integers."
echo "What is the first integer? "

read FIRST_INTEGER

echo "What is the second integer? "

read SECOND_INTEGER

SUM=$(expr "$FIRST_INTEGER" + "$SECOND_INTEGER")

echo "The sum is: $SUM"
