#!/bin/bash

# Check if both parameters are provided
if [ $# -lt 2 ];then
  echo "Usage: $0 x fileinput"
  exit 1
fi

# Read input values
x=$1
fileinput=$2

# Check if x is within the valid range
if [ $x -lt 1 ] || [ $x -gt 99 ];then
  echo "Error: x must be between 1 and 99"
  exit 1
fi

# Calculate the number of lines in the file
num_lines=$(($(wc -l < "$fileinput") - 1 ))

# Calculate the number of lines to sample
num_sample=$((num_lines * x / 100))

# Sample the lines using shuf excluding header
{ head -n 1 "$fileinput"; shuf <(tail -n +2 "$fileinput") | head -n "$num_sample"; }



