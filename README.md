# RNA_Seq_pipeline_AD

RNA-Seq analysis pipeline
Audrey Dalgarno
Created Sept 2021

This pipeline does the following:
1. Align fastq.gz files (STAR)
2. Feature counting with HTSeq
3. Differential Expression analysis with edgeR

How to install:
1. Clone the git repository
2. Set up the environment (requires conda) by running conda create -n RNA_Seq_pipeline_AD --file req.txt

How to setup files:
1. The input fastq.gz files should already be fastqc-ed and trimmed. They should be gzipped and placed in one directory (project_path)
2. Create a STAR idx for your genome of choice (genome_path)
3. Create a file, sample_names.txt, in the project_path. The files should be in one column and everything after the sample name itself should
be removed (i.e. no _R1_001...). For example, test_S1_R1_001.fastq.gz should be entered as test_S1. IMPORTANT: The files should appear in the same order as
when you ls!!!!!
4. Create a file (order corresponding to sample_names.txt) called group_names.txt in project_path. This file should be one column and have the groups (for edgeR
analysis) for the samples in sample_names.txt
5. Create a file called contrasts.txt in project_path. This file should also be one column. For any given contrast, for example, test = sample_two - sample_one,
there will be three separate rows. First, test, then sample_two, then sample_one. The names used should correspond to those in the group_names.txt file.
It would be good to have informative names for the contrasts, as these will become their file names.
For this example the file would look like this:
test  
sample_two  
sample_one  

To run the pipeline:
The pipeline runs off of one command:

sbatch run_main.sh project_path genome_path [0/1]

the arguements are 1) path to fastq.gz files/sample_names.txt/group_names.txt/contrasts.txt 2) path to STAR idx 3) 0 or 1, corresponds to if the data is
single-read (0) or paired-end (1)

