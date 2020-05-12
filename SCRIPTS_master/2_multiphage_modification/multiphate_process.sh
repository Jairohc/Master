#! /bin/bash 
# Process protein file
actual_dir=$PWD
genome=$1
threads=$2
evalue=$3

cd $actual_dir
mkdir results 
cd results

echo "blastx pvogs in process..."
#swissprot
blastx -query $genome -evalue $3 -num_threads $threads -db /home/jairohc/4_soft_dis/multiPhATE/Databases/pVOGs/pvogs -outfmt 11 -out pvogs
#formatting blastdb 1
blast_formatter -archive pvogs -outfmt 6 -out 1_pvogs_tabular_results

echo "blastx phantome in process..."
#swissprot
blastx -query $genome -num_threads $threads -db /home/jairohc/4_soft_dis/multiPhATE/Databases/Phantome/phantome -outfmt 11 -out phantome_1
#formatting blastdb 1
blast_formatter -archive phantome_1 -outfmt 6 -out 2_phantome_tabular_results


echo "blastx swissprot in process..."
#swissprot
blastx -query $genome -num_threads $threads -db /home/jairohc/4_soft_dis/multiPhATE/Databases/Swissprot/swissprot -outfmt 11 -out swissprot
#formatting blastdb 1
blast_formatter -archive swissprot -outfmt 6 -out 3_swissprot_tabular_results


echo "blastx refseq protein in process..."
#refseq protein
blastx -query $genome -num_threads $threads -db /home/jairohc/4_soft_dis/multiPhATE/Databases/Refseq/Protein/refseq_protein -outfmt 11 -out refseq_protein
blast_formatter -archive refseq_protein -outfmt 6 -out 4_refseq_protein_tabular_results

#refseqgene
#echo "blastn refseq gene in process..."
#refseqgene
#blastx -query $actual_dir/phanotate/file -num_threads $threads -db /home/jairohc/4_soft_dis/multiPhATE/Databases/Refseq/Gene/refseqgene -outfmt 11 -out refseq_gene
#blast_formatter -archive refseq_gene -outfmt 6 -out 5_refseq_gene_tabular_results

#nr
echo "blastx nr in process..."
blastx -query $genome -num_threads $threads -db /home/jairohc/4_soft_dis/multiPhATE/Databases/NR/nr -outfmt 11 -out nr_results
blast_formatter -archive nr_results -outfmt 6 -out 6_nr_tabular_results

mkdir nonformatted_dbases
mv pvogs phantome_1 swissprot refseq_protein nr_results nonformatted_dbases/



echo "finished"