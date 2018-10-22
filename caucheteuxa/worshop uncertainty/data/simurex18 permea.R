##############################################################################
############################## SIMUREX 2018 ##################################
#######################   Atelier  ###########################################
####### measurement uncertainty assesment for building energy simulation  ####
################  par A. CAUCHETEUX ##########################################
##############################################################################
#  data from :
#  Bailly A., Guyot G. Leprince V., « 6 years of envelope airtightness measurements performed 
#  by french certitifed poperators : analyses of about 65,000 tests », 
#  36th AIVC conference, madrid 2015.

## data loading
fichier = file.choose()    ### load("  permeaData.Rdata   ")
load(fichier)
setwd(dirname(fichier))
wd=getwd()


cat("average Q4Pa coefficient = ", mean(permea[,6]), " \n" )
cat("standard deviation Q4Pa coefficient = ", sd(permea[,6]), " \n" )

## what about the distribution ?
plot(density(permea[,6]), main="density plot", xlab = "airtightness")
qqnorm(permea[,6])
#boxplot(permea[,6])
qqnorm(log(permea[,6]))
abline(a=0, b=1, col=2)



## average by  construction year
by.date=array(dim=c(length(unique(permea[,4])),3))
i=0
for (date in unique(permea[,4]))
{
  i=i+1
  cat("number of sample of ",date, " : ", length(which(permea[,4]==date)) , "\n")
  cat("average for ", date , " = ", mean(permea[which(permea[,4]==date)    , 6]), "\n")
  cat("standard deviation for ", date , " = ", sd(permea[which(permea[,4]==date)    , 6]), "\n \n")
  by.date[i,1]=date
  by.date[i,2]=mean(permea[which(permea[,4]==date)    , 6] )
  by.date[i,3]=sd(permea[which(permea[,4]==date)    , 6])
}
barplot(t(by.date[order(by.date[,1]),2:3]), names.arg=by.date[order(by.date[,1]),1], 
        beside=T, col=c(2,3), main= "airtighness")
legend("topright", legend=c("average ","standard deviation"),
       cex=0.8,        col=c(2,3), bty="n", pch= 15)


## average by material 
by.mat=array(dim=c(length(unique(permea[,5])),2))
rownames(by.mat)=unique(permea[,5])
i=0
for (date in unique(permea[,5]))
{
  i=i+1
  cat("number of sample of ",date, " : ", length(which(permea[,5]==date)) , "\n")
    cat("average for ", date , " = ", mean(permea[which(permea[,5]==date)    , 6]), "\n")
  cat("standard deviation for ", date , " = ", sd(permea[which(permea[,5]==date)    , 6]), "\n \n")
 # by.date[i,1]=date
  by.mat[i,1]=mean(permea[which(permea[,5]==date)    , 6] )
    by.mat[i,2]=sd(permea[which(permea[,5]==date)    , 6])
  
}
barplot(t(by.mat[order(by.mat[,1]),1:2]), names.arg=rownames(by.mat), 
        beside=T, col=c(2,3), main= "airtighness", las=2)
legend("topleft", legend=c("average ","standard deviation"),
       cex=0.8,        col=c(2,3), bty="n", pch= 15)


## average by use
by.use=array(dim=c(length(unique(permea[,3])),2))
rownames(by.use)=unique(permea[,3])
i=0
for (use in unique(permea[,3]))
{
  i=i+1
  by.use[i,1]=mean(permea[which(permea[,3]==use)    , 6] )
  by.use[i,2]=sd(permea[which(permea[,3]==use)    , 6])
}

barplot(t((by.use[,1:2])), names.arg=rownames(by.use), 
        beside=T, col=c(2,3), main= "airtighness", las=2)
legend("topright", legend=c("average ","standard deviation"),
       cex=0.8,        col=c(2,3), bty="n", pch= 15)







## sampling average estimate : random sampling
mean.sam=vector()
n=100
for (i in 1:100)
{
  sam1=sample(permea[,6], size=n)
  mean.sam[i]=mean(sam1)
}
plot(density(mean.sam), ylim=c(0,10))
abline(v=mean(permea[,6]), col=2, lty=2)

n=500
for (i in 1:100)
{
  sam1=sample(permea[,6], size=n)
  mean.sam[i]=mean(sam1)
}
lines(density(mean.sam), col=3)


## sampling average estimate : stratified sampling
## groups by materials
table(permea[,3])
table(permea[,4])
table(permea[,5])

mean.sam=vector()
n=500
N=dim(permea)[1]

for (i in 1:100)
{
  sam1=vector()
  m.sam=vector()
    for (use in unique(permea[,5]))    
      {
      sam1=sample(permea[which(permea[,5]==use),6], size= max(n * length(which(permea[,5]==use))  /N ,1))
      m.sam=c(m.sam, (length(which(permea[,5]==use))/N) * mean(sam1, na.rm=T))
      }
  mean.sam[i]=   sum( m.sam)
}
lines(density(mean.sam), col=4)
abline(v=mean(permea[,6]), col=2, lty=2)
