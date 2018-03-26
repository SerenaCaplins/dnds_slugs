##Goal: to make fasta files of each orthogroup

#load libs
library(micropan)
library(phangorn)


#reading orthofinder orthogroups from here http://arken.nmbu.no/~larssn/teach/bin310/week8.html

resultsDir<-"C:/Users/Serena/Documents/Projects/RNA_Alderia/OrthoFinder/Alderia_ECorn"

grpsTbl<-read.table(file.path(resultsDir, "Results_Jan23/Orthogroups.csv"),
                    header=T, sep="\t", row.names=1, stringsAsFactors = F)

grps<-strsplit(as.matrix(grpsTbl), ",")

dim(grps)<-dim(grpsTbl)

dimnames(grps)<-dimnames(grpsTbl)

grps["OG0000000",]

#check the sizes of the orthogroups

grpSize<-apply(grps, 2, sapply, length)


grpSize["OG0000000",]

#we can plot to see how many genomes are represetned in each orthogroup

plot(table(apply(grpSize>0, 1, sum)), ylab="no. orthogroups", xlab="no. genomes represented")


#how many are 1:1:1

sum(apply(grpSize==1,1,all))

#[1] 4450

##a function to to the alignments

#first make some directories. I dont think I need these

grpFastasDir<-"grpFastas"
dir.create(grpFastasDir)


grpAlignedDir <- "grpAligned"
dir.create(grpAlignedDir)

#define species names

spcs <- sub("\\.fasta","",colnames(grps))

#see which ones are 1:1:0
is1100 <- apply(grpSize==1,1,sum)==2 & apply(grpSize > 1,1,sum)==0
table(apply(grpSize[is1100, ], 1, function(grpSizeRow){
  paste(spc[ grpSizeRow==1 ], collapse="&")
}))

#get the fastas

fastaFiles <- dir(file.path(resultsDir, "grpFastas"), pattern = "*.fasta", full.names = T)
names(fastaFiles) <- basename(fastaFiles)

# read all fasta files
lapply(fastaFiles, function(fastaFile){
  fdta <- readFasta(fastaFile)
  # extract sequence IDs from the header:
  row.names(fdta) <- sub("^([^ ]+).*", "\\1", fdta$Header, perl=T)
  return(fdta)
}) -> allSeqs




#test that we can make one of these fastas
grpID<-"OG0000000"


#problem. This only works if the fasta file names are the same in allSeqs and grps...who knew they could not be the same?


names(allSeqs)<-spcs #this fixed it, but might not be that replicatable

#can pull out those this way:
fastaGrp<-do.call( rbind, lapply(names(allSeqs), function(s){
    allSeqs[[s]][ grps[[grpID,s]],]
    }))

#this writes it to your directory
writeFasta(fastaGrp, "OG0000000.faa")


#problem. only works on 1:1:1 orthogroups. THe above orthogroup has 200 some sequences for AWI and only the first per species are put in the file.
#gives logical statment for those that are 1:1:1 and those that are not
oners<-apply(grpSize==1,1,all)

OneTrue<-grps[oners,,drop=FALSE]

head(OneTrue)

#now we can try with our new groups list

grpID<-"OG0008737"

fastaOneTrue<-do.call( rbind, lapply(names(allSeqs), function(s){
  allSeqs[[s]][ OneTrue[[grpID,s]],]
}))

writeFasta(fastaOneTrue, "OG0008737.faa")


#lets do a for loop to get the others
#test it for the first 10 before I fill my laptop with fasta files

for (i in 1:10){
  
  fastaOneTrue[[i]]<-do.call( rbind, lapply(names(allSeqs), function(s){
    allSeqs[[s]][ OneTrue[[i,s]],]
  }))
  
  writeFasta(fastaOneTrue[[i]], out.file = rownames(OneTrue)[i])
}




str(grps)
str(grpsTbl)
