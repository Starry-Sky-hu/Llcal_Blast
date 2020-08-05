makeblastdb -in /public/agis/huangsanwen_group/fengshuangshuang/huyong/sp.genome/GCF_001406875.1_SPENNV200_genomic.fna -input_type fasta -dbtype nucl -out test_db/test_db -parse_seqids -title Test_db

blastn -db /public/agis/huangsanwen_group/fengshuangshuang/huyong/source/LocalBlast/test_db/test_db -query /public/agis/huangsanwen_group/fengshuangshuang/huyong/sp.genome/q.fasta -outfmt '7 saccver qaccver pident length sstart send' -out /public/agis/huangsanwen_group/fengshuangshuang/huyong/source/LocalBlast/blastn_result1.txt

QueryLength=$(wc -c /public/agis/huangsanwen_group/fengshuangshuang/huyong/sp.genome/q.fasta | awk '{print $1}')
QueryLength=$(echo "$QueryLength*0.8" | bc)

right=$(cat /public/agis/huangsanwen_group/fengshuangshuang/huyong/source/LocalBlast/blastn_result1.txt | sed -n '/#/!p' | sed -n '1p' | awk '{print $5}')
let right=right-1500
left=$(cat /public/agis/huangsanwen_group/fengshuangshuang/huyong/source/LocalBlast/blastn_result1.txt | sed -n '/#/!p' | sed -n '1p' | awk '{print $6}')
let left=left+1500
chrom=$(cat /public/agis/huangsanwen_group/fengshuangshuang/huyong/source/LocalBlast/blastn_result1.txt | sed -n '/#/!p' | sed -n '1p' | awk '{print $1}')

seqkit subseq /public/agis/huangsanwen_group/fengshuangshuang/huyong/sp.genome/GCF_001406875.1_SPENNV200_genomic.fna --chr $chrom -r $right:$left -o /public/agis/huangsanwen_group/fengshuangshuang/huyong/source/LocalBlast/Extract.fasta
