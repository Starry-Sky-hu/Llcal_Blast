path=($(cat /public/agis/huangsanwen_group/fengshuangshuang/huyong/blast_genome/thisPath.txt))
dbPath=/public/agis/huangsanwen_group/fengshuangshuang/huyong/blast_genome/blastdb

for i in $(seq 1 ${#path[@]})
do	
	gzip -d ${path[i]}
	
	# Contruct database
	makeblastdb -in ${path[i]%.*} \
		-input_type fasta \
		-dbtype nucl \
		-out ${dbPath}/${path[i]##*/}_db \
		-parse_seqids \
		-title ${path[i]##*/}_db
	
	# Search sequence in database
	blastn -db ${dbPath}/${path[i]##*/}_db \
		-query ${dbPath%/*}/PP2C_LA0716.fasta \
		-outfmt 7 \
		-out ${dbPath%/*}/blastResult/${path[i]##*/}.txt

	# Extract length of sequence
	#QueryLength=$(wc -c ${dbPath%/*}/PP2C_LA0716.fasta | awk '{print $1}')
	#QueryLength=$(echo "$QueryLength*0.8" | bc)

	# Extract start point of sequence
	left=$(cat ${dbPath%/*}/blastResult/${path[i]##*/}.txt | \
		sed -n '/#/!p' | \
		sed -n '1p' | \
		awk '{print $9}')

	# Extract end point of sequence
	right=$(cat ${dbPath%/*}/blastResult/${path[i]##*/}.txt | \
		sed -n '/#/!p' | \
		sed -n '1p' | \
		awk '{print $10}')
	
	# Extract chromosome of sequence
	chrom=$(cat ${dbPath%/*}/blastResult/${path[i]##*/}.txt | \
		sed -n '/#/!p' | \
		sed -n '1p' | \
		awk '{print $2}')

	# Extract sequence
	seqkit subseq ${path[i]%.*} \
		--chr $chrom \
		-r $left:$right \
		-o ${dbPath%/*}/blastResult/${path[i]##*/}.Extract_body.fasta

	let left_up=left-1500
	let left=left-1
	seqkit subseq ${path[i]%.*} \
                --chr $chrom \
                -r $left_up:$left \
                -o ${dbPath%/*}/blastResult/${path[i]##*/}.Extract_up.fasta

        let right_down=right+1500
	let right=right+1
	seqkit subseq ${path[i]%.*} \
                --chr $chrom \
                -r $right:$right_down \
                -o ${dbPath%/*}/blastResult/${path[i]##*/}.Extract_down.fasta
		
	cat ${dbPath%/*}/blastResult/${path[i]##*/}.Extract_up.fasta >> ${dbPath%/*}/blastResult/${path[i]##*/}.Extract.fasta
	cat ${dbPath%/*}/blastResult/${path[i]##*/}.Extract_body.fasta >> ${dbPath%/*}/blastResult/${path[i]##*/}.Extract.fasta
	cat ${dbPath%/*}/blastResult/${path[i]##*/}.Extract_down.fasta >> ${dbPath%/*}/blastResult/${path[i]##*/}.Extract.fasta
	
	rm ${dbPath%/*}/blastResult/${path[i]##*/}.Extract_up.fasta
	rm ${dbPath%/*}/blastResult/${path[i]##*/}.Extract_body.fasta
	rm ${dbPath%/*}/blastResult/${path[i]##*/}.Extract_down.fasta
	
	gzip ${path[i]%.*}
done
