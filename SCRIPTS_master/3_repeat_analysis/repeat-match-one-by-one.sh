#!/bin/bash
genome=$1
repeat_filtered_file=$2
genome_length=$(cat $genome | grep -v ">"  | wc | awk '{print$3}')

#obtencion de la average location of repeat
cat $repeat_filtered_file | awk '{print($2+$1)/2,$3}' | sort -n > avg_loc_tmp
i="0 0"
echo "start will be $i"
echo "genome length is $genome_length"
echo "$i" >> final_file
    while read line <&3; do 

    	echo "$line" >> final_file
   		
	done 3<avg_loc_tmp
echo "$genome_length 0" >> final_file

echo -e "Generating plot..."
Rscript plot_generator_freq.R	

echo "done"
rm *tmp