path=($(cat /public/agis/huangsanwen_group/fengshuangshuang/huyong/blast_genome/blastResult/blastResultIntegration.txt))

max=${#path[@]}
let max=max-1
for i in $(seq 0 ${max})
do
	title=($(cat ${path[i]} | sed -n '/>/p'))
	echo ${title[0]}\(up_1500\) ${title[2]##*_}\(PP2C_Promoter\) ${title[4]##*_}\(down_1500\) >> PP2C_up_down_1500.fasta
	seqkit seq ${path[i]} -s -w 0 >> PP2C_up_down_1500.fasta
	echo $i
done
