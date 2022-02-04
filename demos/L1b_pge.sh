#!/bin/bash

filename=$1
filename2=${filename//L1a/L1b}

echo "Generating $filename2"
cp $filename $filename2
