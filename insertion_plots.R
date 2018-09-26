##plotting insertions/reads? vs coordinates
library(tidyverse)
library(dplyr)
getwd()
setwd("C:/Users/corrie/Dropbox/Grad School/Hancock Lab/Experiments/Tn-Seq/Analysis/2018/Transit_vs_Tradis/retnseqpao1results")

##open sequence coordinate file from Travis
seq <- read.table("C:/Users/corrie/Dropbox/Grad School/Hancock Lab/Experiments/Tn-Seq/Analysis/2018/Transit_vs_Tradis/retnseqpao1results/PAO1_NC_0025162_position_base/PAO1_NC_0025162_position_base.txt", header = TRUE)

##open the insertion_site_plot file as a table: Should provide path on your computer where file is located
vs <- read.table("C:/Users/corrie/Dropbox/Grad School/Hancock Lab/Experiments/Tn-Seq/Analysis/2018/20180704/LESB58_PGDB/RF158.out.gz.ref_NC_011770_gi_218888746_pseudocap_154.insert_site_plot/RF158.out.gz.ref_NC_011770_gi_218888746_pseudocap_154.insert_site_plot")

##make the coordinates that are the row names into the first column
vs <- add_rownames(vs,"v0")
##if the above add_rownames won't work, try using rownames_to_columns which is supposed to be the replacement code
#vs <-rownames_to_column(vs, var = "v0")

##create a summ of forward and reverse insertions/reads and name the column
sum <- data.frame(vs$V1 + vs$V2)
names(sum)<- "tot"

##combine the dataframe with the totals column and rename the first column
PAO1_insertion_density <- cbind(vs,sum)
names(PAO1_insertion_density)[1] <- "Positions"

#subset just the base column of the sequence coordinate dataframe and combine it with the insertion density dataframe
Bases <- subset(seq,select = "Base")
PAO1_ID_seq <- cbind(PAO1_insertion_density,Bases)

#optional to filter out the coordinates with no reads
PAO1_ID_seq_filtered <- filter(PAO1_ID_seq, tot>0)
write.csv(PAO1_ID_seq_filtered,file="../PAO1_ID_seq_filtered.csv")

#extract coordinates of bioB to look where reads are
PAO1_ID_seq_bioB <- PAO1_ID_seq[559644:560702,]
write.csv(PAO1_ID_seq_bioB,file="../bioB.csv")

#extract coordinates of PA5238 to look where reads are
PAO1_ID_seq_PA5238 <- PAO1_ID_seq[5898794:5896806,]
write.csv(PAO1_ID_seq_PA5238,file="../PA5238.csv")

#extract coordinates of PA3327 to look where reads are
PAO1_ID_seq_PA3327 <- PAO1_ID_seq[3730557:3737615,]
write.csv(PAO1_ID_seq_PA3327,file="../PA3327.csv")


#to filter for large insertion/reads
#PAO1_filtered_insertion_density <- filter(PAO1_insertions, tot >0)
#write.csv(as.data.frame(PAO1_filtered_insertion_density), file = "../PAO1_highdensity_insertions.csv")

##plot in R
#plot(filtered_insertions$v0, filtered_insertions$tot, main="insertion_plot",
 #    xlab="coordinate", ylab="reads", pch=8)


#export as jpeg
jpeg("../LESB58_filtered_insertion_density_plot.jpg") 
plot(LESB58_filtered_insertion_density$Positions,LESB58_filtered_insertion_density$tot, main="insertion_density_plot", pch=16,cex = 0.5)
dev.off()

