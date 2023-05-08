#!/bin/bash

# Compute average values for cancer and healthy data
tail -n +2 77_cancer_proteomes_CPTAC_itraq.csv | cut -d',' -f1-3,4-83 > cancer_data.csv
tail -n +2 77_cancer_proteomes_CPTAC_itraq.csv | cut -d',' -f1-3,84-86 > healthy_data.csv

awk -F ',' '{sum=0; for(i=4;i<=83;i++) sum+=$i; avg_cancer=sum/80; printf "%s,%s,%s,%f\n", $1, $2, $3, avg_cancer}' cancer_data.csv > cancer_protein_avg.csv
awk -F ',' '{sum=0; for(i=2;i<=4;i++) sum+=$i; avg_healthy=sum/3; printf "%s,%s,%s,%f\n", $1,$2, $3, avg_healthy}' healthy_data.csv > healthy_protein_avg.csv

# Find top 10 highly expressed cancer genes
sort -t',' -k4nr cancer_protein_avg.csv | head -n 11 > highly_expressed.csv
echo "Top 10 highly expressed cancer genes:"
tail -n +2 highly_expressed.csv | cut -d',' -f2,4

# Find top 10 lowly expressed cancer genes
sort -t',' -k4n cancer_protein_avg.csv | head -n 11 > lowly_expressed.csv
echo "Top 10 lowly expressed cancer genes:"
tail -n +2 lowly_expressed.csv | cut -d',' -f2,4

# Find genes with no expression in cancer dataset
awk -F ',' '{sum=0; for(i=4;i<=83;i++) sum+=$i; avg_cancer=sum/80; if (avg_cancer == 0) print $2}' cancer_data.csv > no_expression_cancer.csv
echo "Genes with no expression in cancer dataset:"
cat no_expression_cancer.csv

# Find top 10 highly expressed healthy genes
sort -t',' -k4nr healthy_protein_avg.csv | head -n 11 > highly_expressed.csv
echo "Top 10 highly expressed healthy genes:"
tail -n +2 highly_expressed.csv | cut -d',' -f2,4

# Find top 10 lowly expressed healthy genes
sort -t',' -k4n cancer_protein_avg.csv | head -n 11 > lowly_expressed.csv
echo "Top 10 lowly expressed healthy genes:"
tail -n +2 lowly_expressed.csv | cut -d',' -f2,4

# Find genes with no expression in healthy dataset
awk -F ',' '{sum=0; for(i=2;i<=4;i++) sum+=$i; avg_healthy=sum/3; if (avg_healthy == 0) print $2}'  healthy_data.csv > no_expression_healthy.csv
echo "Genes with no expression in healthy dataset:"
cat no_expression_healthy.csv


# Add last column of healthy data to cancer data
paste -d',' cancer_protein_avg.csv <(cut -d',' -f4 healthy_protein_avg.csv) > merged_protein_avg.csv
awk -F ',' 'NR>1 {if (($NF-$(NF-1)) > 2 || ($NF-$(NF-1)) < -2) print $0}' merged_protein_avg.csv > differentially_expressed.csv
echo "The differentially expressed genes and their corresponding data"
cat differentially_expressed.csv


