#!/bin/bash
#--------------------------
#Creates a test image file
#--------------------------
for (( a=0; a<=40; a++ ))
do
  for (( i=0; i<=0XFF; i++ ))
  do
    printf '%x\n' $i >> test.mem
  done
done
