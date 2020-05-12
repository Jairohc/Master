#!/bin/bash

genome_order=$1
min_repeat_length=$2
max_repeat_length=$3
minimum_distance=$4
maximum_distance=$5
cut_off=$6
actual_dir=$PWD
echo maximum distance defined as "$maximum_distance"
echo minimal distance defined as "$minimum_distance"
    while read line <&3; do 
    	cat "$line" > tmp
    	echo "$line"
    	repeat-match tmp -n "$min_repeat_length" | grep -v "Matches:" | grep -v "Length" | grep -v "Exact" | grep -v "Start2" | grep -v "Long" | grep -v "Start1"  > "$line"_rep

	done 3<genome_order

find *rep > repeat_order


    while read line <&3; do 
    	cat "$line" | grep "r" | tr --delete "r" > reversed_tmp
    	cat "$line" | grep -v "r" > forward_tmp
    	cat forward_tmp | awk '{print $1,$2,$3,$2-$1}' | awk -v min_awk="$minimum_distance" -v max_awk="$maximum_distance" -v max_rp_len="$max_repeat_length" '{if ($4 > min_awk && $4 < max_awk && $3 < max_rp_len) print$1,$2,$3,$4}' | wc -l >> repeats_per_genome_for_tmp
    	cat forward_tmp | awk '{print $1,$2,$3,$2-$1}' | awk -v min_awk="$minimum_distance" -v max_awk="$maximum_distance" -v max_rp_len="$max_repeat_length" '{if ($4 > min_awk && $4 < max_awk && $3 < max_rp_len) print$1,$2,$3,$4}' > filtered_forward_tmp
		cat reversed_tmp | awk '{print $1,$2,$3,$2-$1}' | awk -v min_awk="$minimum_distance" -v max_awk="$maximum_distance" -v max_rp_len="$max_repeat_length" '{if ($4 > min_awk && $4 < max_awk && $3 < max_rp_len) print$1,$2,$3,$4}' | wc -l >> repeats_per_genome_rev_tmp
		cat reversed_tmp | awk '{print $1,$2,$3,$2-$1}' | awk -v min_awk="$minimum_distance" -v max_awk="$maximum_distance" -v max_rp_len="$max_repeat_length" '{if ($4 > min_awk && $4 < max_awk && $3 < max_rp_len) print$1,$2,$3,$4}' > filtered_reverse_tmp
		cat filtered_reverse_tmp filtered_forward_tmp > "$line"_filtered
		total=$(cat filtered_reverse_tmp filtered_forward_tmp | awk '{print$3}' | paste -s -d+ | bc )
		number=$(cat filtered_reverse_tmp filtered_forward_tmp | awk '{print$3}' | wc -l)
		echo "scale=2 ; $total / $number" | bc >> arl_tmp



	done 3<repeat_order


    while read line <&3; do 
   		cat "$line" | grep -v ">" | wc | awk '{print$3}' >> genome_length_tmp
	done 3<genome_order

paste genome_order genome_length_tmp repeats_per_genome_for_tmp repeats_per_genome_rev_tmp arl_tmp | awk '{print $1,$2,$3,$4,($3+$4),(($3+$4)/$2*100000),$5}' |  sort -n -k6 > sorted_results_tmp
			awk -v cut_off_awk="$cut_off" '{
			if ($6 >=cut_off_awk)
				print $8"Pass";
			else
				print $8"Fail";
			}' sorted_results_tmp > last_column_tmp

paste sorted_results_tmp last_column_tmp | tr "\t" " " > sorted_results

mkdir repeat-finder-original-files
mkdir repeat-finder-filtered-files
mv *rep repeat-finder-original-files
mv *filtered repeat-finder-filtered-files
rm *tmp
rm repeat_order
echo "Results were generated succesfully"
echo -e "Generating plot..."
Rscript plot_generator.R 
echo "done"
