#!/bin/bash
#SBATCH -J run_ft_counts
#SBATCH -o run_ft_counts_%J.out
#SBATCH -e run_ft_counts_%J.err
#SBATCH -n 4
#SBATCH -t 96:00:00
#SBATCH --mem=48G

module load anaconda/2020.02

source /gpfs/runtime/opt/anaconda/2020.02/etc/profile.d/conda.sh

conda activate RNA_Seq_pipeline_AD

htseq-count \
-m union \
-r name \
-a 10 \
-i gene_id \
-f bam ${STAR_output_path}*.bam ${genome_path}*.gtf > ${HTSeq_output_path}ft_counts.txt

#create header
awk '{print $1}' ${project_path}sample_names.txt | paste -s -d '\t' | sed -e '1s/^/\t /' > ${HTSeq_output_path}header.txt

#add header
cat ${HTSeq_output_path}header.txt ${HTSeq_output_path}ft_counts.txt > ${HTSeq_output_path}ft_counts_with_header.txt
