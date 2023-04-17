#!/bin/bash

# Check if a filename has been provided as an argument
if [ $# -eq 0 ]; then
  echo "Usage: $0 <filename>"
  exit 1
fi

filename=$1
total_entries=$(( $(wc -l < $filename) - 1 )) # exclude header
split_point=$((total_entries*80/100))

# Check the original separator of the file
separator=$(head -n 1 $filename | tr -dc '\t|,|;|\|' | head -c 1)
if [ -z $separator ]; then
  separator=','
else
  sed -i "s/$separator/,/g" $filename # replace original separator with commas
fi

# Split the file into two disjoint sub-datasets
head -n 1 $filename > header.csv # extract header to a separate file
head -n $((split_point+1)) $filename > sub_dataset1.csv # extract 80% of data and header to sub_dataset1
tail -n +$((split_point+2)) $filename | grep -v '^$' > sub_dataset2.csv # extract remaining data to sub_dataset2
cat header.csv sub_dataset1.csv > tmp_sub_dataset1.csv # concatenate header and sub_dataset1
mv tmp_sub_dataset1.csv a4/train/data.csv # save sub_dataset1 to a4/train/data.csv
cat header.csv sub_dataset2.csv > tmp_sub_dataset2.csv # concatenate header and sub_dataset2
mv tmp_sub_dataset2.csv a4/test/data.csv # save sub_dataset2 to a4/test/data.csv

echo "Dataset split complete."
echo "Number of entries in sub_dataset1: $(wc -l < a4/train/data.csv)"
echo "Number of entries in sub_dataset2: $(wc -l < a4/test/data.csv)"

