path=/public/agis/huangsanwen_group/fengshuangshuang/huyong/blast_genome

gzip -d ${path}/S_lycopersicum_chromosomes.2.50.fa.gz
blastn -db ${path}/blastdb/S_lycopersicum_chromosomes.2.50.fa.gz_db \
	-query ${path}/PP2C_CDS.fasta \
        -outfmt 7 \
        -out ${path}/blastResult/ref_CDS.txt

max=$(cat ${path}/blastResult/ref_CDS.txt | \
        sed -n '/#/!p' | \
        awk '{print $10}' | \
        awk 'BEGIN {max=0} {if ($1+0 > max+0) max=$1} END {print max}' -)

min=$(cat ${path}/blastResult/ref_CDS.txt | \
	sed -n '/#/!p' | \
	awk '{print $9}' | \
        awk 'BEGIN {min=999999999999} {if ($1+0 < min+0) min=$1} END {print min}' -)

chrom=$(cat ${path}/blastResult/ref_CDS.txt | \
	sed -n '/#/!p' | \
        sed -n '1p' | \
        awk '{print $2}')

seqkit subseq ${path}/S_lycopersicum_chromosomes.2.50.fa \
	--chr $chrom \
	-r $min:$max \
	-o ${path}/blastResult/ref_CDS.fasta
gzip ${path}/S_lycopersicum_chromosomes.2.50.fa

seqkit seq ${path}/blastResult/ref_CDS.fasta -w 0 > ${path}/blastResult/ref_CDS_1.fasta
rm ${path}/blastResult/ref_CDS.fasta

path=($(cat /public/agis/huangsanwen_group/fengshuangshuang/huyong/blast_genome/thisPath.txt))
dbPath=/public/agis/huangsanwen_group/fengshuangshuang/huyong/blast_genome/blastdb

for i in $(seq 1 ${#path[@]})
do
        gzip -d ${path[i]}

        # Search sequence in database
        blastn -db ${dbPath}/${path[i]##*/}_db \
                -query ${dbPath%/*}/blastResult/ref_CDS_1.fasta \
                -outfmt 7 \
                -out ${dbPath%/*}/blastResult/${path[i]##*/}_CDS.txt
	
	max=$(cat ${dbPath%/*}/blastResult/${path[i]##*/}_CDS.txt | \
		sed -n '/#/!p' | \
		awk '{print $10}' | \
		awk 'BEGIN {max=0} {if ($1+0 > max+0) max=$1} END {print max}' -)
	
	min=$(cat ${dbPath%/*}/blastResult/${path[i]##*/}_CDS.txt | \
		sed -n '/#/!p' | \
		awk '{print $9}' | \
		awk 'BEGIN {min=999999999999} {if ($1+0 < min+0) min=$1} END {print min}' -)
	
	chrom=$(cat ${dbPath%/*}/blastResult/${path[i]##*/}_CDS.txt | \
                sed -n '/#/!p' | \
                sed -n '1p' | \
                awk '{print $2}')
	
	seqkit subseq ${path[i]%.*} \
                --chr $chrom \
                -r $min:$max \
                -o ${dbPath%/*}/blastResult/${path[i]##*/}.Extract_CDS.fasta	
	
	seqkit seq ${dbPath%/*}/blastResult/${path[i]##*/}.Extract_CDS.fasta -w 0 >> ${dbPath%/*}/blastResult/${path[i]##*/}.Extract_CDS_1.fasta
	rm ${dbPath%/*}/blastResult/${path[i]##*/}.Extract_CDS.fasta

	gzip ${path[i]%.*}
done
