#!/bin/bash

base_filename=$1

for i in {1..5}
do
   filename="${base_filename}_${i}.dat"
   echo "Generating $filename"
   echo $i > $filename
done
