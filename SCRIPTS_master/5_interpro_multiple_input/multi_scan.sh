#!/bin/bash

#python location
python="/usr/bin/python"
#multi_fasta_protein_file
multi_fasta=$1
#splitting_sequences
seqretsplit --sequence $multi_fasta --outseq seqoutall

echo "control"
cat $multi_fasta | grep ">" | tr '[:upper:]' '[:lower:]' | sed 's/>//g'
cat $multi_fasta | grep ">" | tr '[:upper:]' '[:lower:]' | sed 's/>//g' > list

	while read line <&3; do
		$python ip.py --email jairohcx@gmail.com --sequence "$line".fasta --outformat tsv --outfile "$line"_ipr
		cat *.txt >> final_list
		rm *.txt
	done 3<list


rm list
rm *.fasta
rm *.txt
echo "done"
exit
