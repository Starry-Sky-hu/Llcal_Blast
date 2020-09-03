cor <- read.table("../Compare/compare.table", header = T)
name <- c('BGV006865', 'BGV007931', 'BGV007989', 'Brandywine', 'EA00371', 'EA00990', 'Fla.8924', 
         'Floradade', 'Heinz' ,'LYC1410', 'M82', 'M82_MAS2.0' ,
         'PAS014479' ,'PI169588' ,'PI303721', 'S_lycopersicum', 'Spenn' ,
         'ZY56' ,'ZY57' ,'ZY58', 'ZY59', 'ZY60', 'ZY61', 'ZY62', 'ZY63' ,'ZY65')
distance <- cor$CDS_start-cor$PP2C_start
cor <- cbind(name,cor)
cor <- cbind(cor,distance)
write.table(cor, "../Result/PP2Ctable.table", sep = '\t', quote = F, row.names = F)


