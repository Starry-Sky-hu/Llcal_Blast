CDS_path=($(cat /public/agis/huangsanwen_group/fengshuangshuang/huyong/blast_genome/blastResult/CDS_cor.txt))
PP2C_path=($(cat /public/agis/huangsanwen_group/fengshuangshuang/huyong/blast_genome/blastResult/pp2c_cor.txt))
path=/public/agis/huangsanwen_group/fengshuangshuang/huyong/blast_genome/blastResult
max(){
	echo $(cat $1 | \
                sed -n '/#/!p' | \
                awk '{print $10}' | \
                awk 'BEGIN {max=0} {if ($1+0 > max+0) max=$1} END {print max}' -)
}
min(){
	echo $(cat $1 | \
                sed -n '/#/!p' | \
                awk '{print $9}' | \
                awk 'BEGIN {min=999999999999} {if ($1+0 < min+0) min=$1} END {print min}' -)
}
chrom(){
	echo $(cat $1 | \
                sed -n '/#/!p' | \
                sed -n '1p' | \
                awk '{print $2}')
}
length=${#CDS_path[@]}
let length=length-1

for i in $(seq 0 $length)
do
	CDS_end=$(max ${CDS_path[i]})
	CDS_start=$(min ${CDS_path[i]})
	PP2C_start=$(cat ${PP2C_path[i]} | \
                	sed -n '/#/!p' | \
                	sed -n '1p' | \
                	awk '{print $9}')
	PP2C_end=$(cat ${PP2C_path[i]} | \
                	sed -n '/#/!p' | \
                	sed -n '1p' | \
                	awk '{print $10}')
	CDS_chrom=$(chrom ${CDS_path[i]})
	PP2C_chrom=$(chrom ${PP2C_path[i]})
	echo "$CDS_chrom $CDS_start $CDS_end $PP2C_chrom $PP2C_start $PP2C_end" >> ${path}/compare.table

done
sed -i '1i CDS_chrom CDS_start CDS_end PP2C_chrom PP2C_start PP2C_end' ${path}/compare.table
