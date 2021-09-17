#!/bin/bash
#SBATCH -J run_star
#SBATCH -o run_star_%J.out
#SBATCH -e run_star_%J.err
#SBATCH -n 4
#SBATCH -t 48:00:00
#SBATCH --mem=32G

module load anaconda/2020.02

source /gpfs/runtime/opt/anaconda/2020.02/etc/profile.d/conda.sh

conda activate RNA_Seq_pipeline_AD

echo now aligning ${sample} with STAR

if [ "${is_paired_end}" == 0 ]
then
echo I see your data is single-read...I will process accordingly
STAR --runThreadN 4 \
--genomeDir ${genome_path} \
--readFilesIn <(gunzip -c ${project_path}${sample}_R1_001.fastq.gz) \
--outFileNamePrefix ${STAR_output_path}${sample}_ \
--outSAMtype BAM SortedByCoordinate 
else
echo I see your	data is	paired-end...I will process accordingly
STAR --runThreadN 4 \
--genomeDir ${genome_path} \
--readFilesIn <(gunzip -c ${project_path}${sample}_R1_001.fastq.gz) <(gunzip -c ${project_path}${sample}_R2_001.fastq.gz) \
--outFileNamePrefix ${STAR_output_path}${sample}_ \
--outSAMtype BAM SortedByCoordinate 
fi

echo done aligning ${sample}
