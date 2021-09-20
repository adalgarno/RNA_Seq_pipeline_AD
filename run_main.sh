#!/bin/bash

#SBATCH --time=1:00:00
#SBATCH --cpus-per-task=1
#SBATCH  --mem=8G
#SBATCH -J RNA_Seq_pipeline_AD_main
#SBATCH -o RNA_Seq_pipeline_AD_main_%J.out
#SBATCH -e RNA_Seq_pipeline_AD_main_%J.err

#RNASeq analysis pipeline
#Audrey Dalgarno
#OG creation Sept 2021
#Updated X 2021

#this pipeline assumes the following:
#1. you have trimmed (if necesary) and fastqc-ed your data
#2. All fastq files are in the directory that will become 'project_path' and are gzipped (first input)
#3. There is a file, sample_names.txt, in the project_path that contains the names of all files without _R1_001...
# IMPORTANT: this file should be in the order that appears when you ls!!!!! otherwise the feature counts table will be incorrect
#4. You have built a STAR idx for your genome of choice, which is in the second input, which will become the genome_path
#5. You have created the conda environment called RNA_Seq_pipeline_AD by running conda create -n RNA_Seq_pipeline_AD --file req.txt

#this pipeline will do the following:
#1. Align with STAR
#2. Count features with HTSeq
#3. Run EdgeR

#sample use:
#arguements, in order are
#path to fastq
#path to genome idx
#paired or singe end (0 = single, 1 = paired)
#strandedness -- options according to htseq documentation (default = yes; no; reverse) https://htseq.readthedocs.io/en/release_0.11.1/count.html
#sbatch run_main path_to_fastq/ path_to_genome_idx/ 0 yes

 
#DEFINE PATHS AND VARIABLES ####################################################

#path for project (should contain sample list in sample_names.txt and fastq files)
project_path=$1
export project_path

#make STAR directory
STAR_output_path=$1/STAR/
mkdir $STAR_output_path
export STAR_output_path

#make HTSeq directory
HTSeq_output_path=$1/HTSeq/
mkdir $HTSeq_output_path
export HTSeq_output_path

#make EdgeR directory
EdgeR_output_path=$1/EdgeR/
mkdir $EdgeR_output_path
export EdgeR_output_path

#genome path
genome_path=$2
export genome_path

#is paired end?
is_paired_end=$3
export is_paired_end

#strandedness
strandedness=$4
export strandedness

#ini job ID 1
jobID_1=0

#RUN PIPELINE###################################################################

echo "Welcome to RNA-Seq pipeline...starting now"

#loop through samples for alignment
cat ${project_path}/sample_names.txt| ( while read line
do
sample=${line}

echo processing ${sample}

#export sample name to be used in other files
export sample

echo Starting with alignment of ${sample}
jobID_1=$(sbatch  run_star.sh | cut -f 4 -d' ')

done

echo $jobID_1

echo all jobs submitted for alignment...feature counting will stop when they are done

#feature counting
jobID_2=$(sbatch --dependency=afterok:$jobID_1 run_HTSeq.sh | cut -f 4 -d' ')

echo feature counting has started, will wait for this to finish to start differential expression analysis with edgeR

#edgeR
jobID_3=$(sbatch --dependency=afterok:$jobID_2 run_edgeR.sh | cut -f 4 -d' ')

echo edgeR has been submitted. pipeline is complete when this is finished. )
