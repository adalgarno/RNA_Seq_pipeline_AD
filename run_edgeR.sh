#!/bin/bash
#SBATCH -J run_edgeR
#SBATCH -o run_edgeR_%J.out
#SBATCH -e run_edgeR_%J.err
#SBATCH -n 1
#SBATCH -t 24:00:00
#SBATCH --mem=8G

module load anaconda/2020.02

source /gpfs/runtime/opt/anaconda/2020.02/etc/profile.d/conda.sh

conda activate RNA_Seq_pipeline_AD

echo starting EdgeR

Rscript edgeR.R ${HTSeq_output_path}ft_counts_with_header.txt ${project_path}group_names.txt ${project_path}contrasts.txt ${EdgeR_output_path}

echo EdgeR has finished
