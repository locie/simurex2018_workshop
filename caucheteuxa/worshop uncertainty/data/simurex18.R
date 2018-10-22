##############################################################################
############################## SIMUREX 2018 ##################################
#######################   Atelier  ###########################################
####### measurement uncertainty assesment for building energy simulation  ####
################  par A. CAUCHETEUX ##########################################
##############################################################################

## Data loading
#bureaux <- read.delim("recap bat cecp.txt",  stringsAsFactors=FALSE)
#reunion <- read.delim("recap temp cecp.txt",  stringsAsFactors=FALSE)
#bur105 <- read.delim("recap temp b105.txt",  stringsAsFactors=FALSE)
#save(list=c("bur105","bureaux", "reunion" ), file="mesures.Rdata" )

## data loading
fichier = file.choose()    ### load("  mesures.Rdata   ")
load(fichier)
setwd(dirname(fichier))
wd=getwd()

#setwd("~/Documents/30 - enseignement/Simurex/TD")
#wd=getwd()
#load( "mesures.Rdata" )

# configuration couleurs pour graphique
palette(rainbow(15))




## time serie Data Plot
plot(ts(bur105[,2], frequency=12*24), 
     ylim=c(floor(min(bur105[,2:dim(bur105)[2]], na.rm=T)), 
            floor(max(bur105[,2:dim(bur105)[2]], na.rm=T))+1) , main="Room 105", ylab="temperature"  )

for (i in 3:(dim(bur105)[2])) lines(ts(bur105[,i], frequency=12*24), col=i)


plot(ts(reunion[,2], frequency=12*24), 
     #ylim=c(floor(min(reunion[,2:dim(reunion)[2]], na.rm=T)), floor(max(reunion[,2:dim(reunion)[2]], na.rm=T))+1) ,
     ylim=c(10,30),
     main= "Meeting room", ylab="temperature" )

for (i in 3:(dim(reunion)[2])) lines(ts(reunion[,i], frequency=12*24), col=i)


plot(ts(bureaux[,2], frequency=12*24), 
     ylim=c(floor(min(bureaux[,2:dim(bureaux)[2]], na.rm=T)), 
            floor(max(bureaux[,2:dim(bureaux)[2]], na.rm=T))+1), main="Building by room " , ylab="temperature"  )

for (i in 3:(dim(bureaux)[2])) lines(ts(bureaux[,i], frequency=12*24), col=i)



## density plot
plot(density((bur105[which(!is.na(bur105[,2])),2] ))  ,  
     xlim=c(floor(min(bur105[,2:dim(bur105)[2]], na.rm=T)), 
                 floor(max(bur105[,2:dim(bur105)[2]], na.rm=T))+1),
     main="Room 105" , xlab="Temperature")
for (i in 3:(dim(bur105)[2]))    lines(density(bur105[which(!is.na(bur105[,i])),i] ), col=i    ) 


plot(density((reunion[which(!is.na(reunion[,2])),2] ))  ,  
    # xlim=c(floor(min(reunion[,2:dim(reunion)[2]], na.rm=T)), floor(max(reunion[,2:dim(reunion)[2]], na.rm=T))+1),
     xlim=c(16, 27),
     main="Meeting room" , xlab="Temperature")
for (i in 3:(dim(reunion)[2]))    lines(density(reunion[which(!is.na(reunion[,i])),i] ), col=i    ) 


plot(density((bureaux[which(!is.na(bureaux[,2])),2] ))  ,  
      xlim=c(floor(min(bureaux[,2:dim(bureaux)[2]], na.rm=T)), floor(max(bureaux[,2:dim(bureaux)[2]], na.rm=T))+1),
     #xlim=c(16, 27),
     main="Building by room" , xlab="Temperature")
for (i in 3:(dim(bureaux)[2]))    lines(density(bureaux[which(!is.na(bureaux[,i])),i] ), col=i    ) 


## Box plot
boxplot(bur105[,2:dim(bur105)[2]] , las=3  , cex.axis=0.8 , col=c(2:dim(bur105)[2]) ,
        main="Room 105 ", ylab="temperature")

boxplot(reunion[,2:dim(reunion)[2]] , las=3  , cex.axis=0.8 , col=c(2:dim(reunion)[2]) ,
        main=" Meeting room ", ylab="temperature",
        ylim=c(16,27)  )

boxplot(bureaux[,2:dim(bureaux)[2]] , las=3  , cex.axis=0.8 , col=c(2:dim(bureaux)[2]) ,
        main="Building by Room ", ylab="temperature")



### average temperature by place in the room
hl.105=array(dim=c(25,2))
colnames(hl.105)=c("h", "l")
rownames(hl.105)=colnames(bur105[2:26])
hl.105[,1]=c(200,120,260,120,35,260,200,120,35,260,200,120,35,200,120, 120, 200,200,200,200,200, 260, 200, 120, 35)
hl.105[,2]=c(200, 200, 200, 350, 350, rep(400, each=4), rep(350, each=5), 200, 50, 50, 130, 220, 305, 380, rep(200, each=4))
tmp=bur105[,2:dim(bur105)[2]]
mu=apply(tmp,  2 , function(x) mean(x, na.rm=T))
plot(hl.105[,2], mu, col= round(hl.105[,1]/100)+1, xlab="distance from exterior wall (cm)",
     main="30 days average temperature \n office 105", ylab = "temperature (°C)")
legend("topright", legend=c("h=35cm ","h=120cm", "h=200cm", "h=260cm"),
       cex=0.8,        col=c(1:4), bty="n", pch=1)
plot(hl.105[,1], mu,  xlab="height (cm)",
     main="30 days average temperature \n office 105", ylab = "temperature (°C)")



hl.reu=array(dim=c(28,2))
colnames(hl.reu)=c("h", "l")
rownames(hl.reu)=colnames(reunion[2:29])
hl.reu[,1]=c(230, 160, 230, 160, 90, 230, 160, 160, 160, 90, 20, 20, 160, 160, 230, 90, 230, 160, 90, 20, 230, 160, 90, 20, 230, 160, 90, 20) 
hl.reu[,2]=c(250, 500, 250, 250,50, 250   , 50, 250, 500, 250, 250, 50, 500, 250, 50, 250, 500, 500, 500, 500,
             rep(500,each=8) )
tmp=reunion[,2:dim(reunion)[2]]
mu=apply(tmp,  2 , function(x) mean(x, na.rm=T))
plot(hl.reu[,2], mu, col= round((hl.reu[,1]+25)/100)+1, xlab="distance from exterior wall (cm)",
     main="30 days average temperature \n meeting room", ylab = "temperature (°C)")
legend("topleft", legend=c("h=20cm ","h=90cm", "h=160cm", "h=230cm"),
       cex=0.8,        col=c(1:4), bty="n", pch=1)
plot(hl.reu[,1], mu,  xlab="height (cm)",
     main="30 days average temperature \n meeting room", ylab = "temperature (°C)")







########### standard deviation computing 

tmp=bur105[,2:dim(bur105)[2]]
plot( ts(apply(tmp,  1 , function(x) sd(x, na.rm=T)), frequency=24*12),
              ylim=c(0,2), ylab="temperature standard deviation" ,
      main="Room 105")

cat("room 105 - mean of sd (trueness + precision)  = ", mean(apply(tmp,  1 , function(x) sd(x, na.rm=T))), " \n ")
cat("room 105 - sd of mean (trueness) = ", sd(apply(tmp,  2 , function(x) mean(x, na.rm=T))), " \n ")
cat("room 105 - precision = ", sqrt(mean(apply(tmp,  1 , function(x) sd(x, na.rm=T)))^2 
                                    - sd(apply(tmp,  2 , function(x) mean(x, na.rm=T)))^2 ), "\n")

tmp=reunion[,2:dim(reunion)[2]]
plot( ts(apply(tmp,  1 , function(x) sd(x, na.rm=T)), frequency=24*12),
      ylim=c(0,2), ylab="temperature standard deviation",
      main="Meeting room")
cat("meeting room - mean of sd (trueness + precision) = ", mean(apply(tmp,  1 , function(x) sd(x, na.rm=T))), " \n ")
cat("meeting room - sd of mean (trueness) = ", sd(apply(tmp,  2 , function(x) mean(x, na.rm=T))), " \n ")
cat("meeting room - precision = ", sqrt(mean(apply(tmp,  1 , function(x) sd(x, na.rm=T)))^2 
                                    - sd(apply(tmp,  2 , function(x) mean(x, na.rm=T)))^2 ), "\n")
mu=apply(tmp,  2 , function(x) mean(x, na.rm=T))
barplot(mu - mean(mu), main="Sensors average error \n Meeting room", , beside=T , las=2 )


tmp=bureaux[,2:dim(bureaux)[2]]
plot( ts(apply(tmp,  1 , function(x) sd(x, na.rm=T)), frequency=24*12),
      ylim=c(0,2), ylab="temperature standard deviation",
      main="Building by room")
#weekdays(  as.POSIXct( bureaux[(24*3*12)+12*5,1] , tz="GMT" , format="%d/%m/%Y %H:%M"    ) )
#abline(v=c(5, 12, 19, 26), col=3, lty=2)
#abline(v=c(3, 10, 17, 24), col=3, lty=2)

mu=apply(tmp,  2 , function(x) mean(x, na.rm=T))
barplot(mu - mean(mu), main="sensors average error \n building", , beside=T , las=2 )

#  cat ("average temperature by sensor : \n  ")
#  print(apply(tmp,  2 , function(x) mean(x, na.rm=T)))

cat("building - mean of sd (trueness + precision) = ", mean(apply(tmp,  1 , function(x) sd(x, na.rm=T))), " \n ")
cat("building - sd of mean (trueness)  = ", sd(apply(tmp,  2 , function(x) mean(x, na.rm=T))), " \n ")
cat("building - precision = ", sqrt(mean(apply(tmp,  1 , function(x) sd(x, na.rm=T)))^2 
     - sd(apply(tmp,  2 , function(x) mean(x, na.rm=T)))^2 ), "\n")


#shapiro.test(rnorm(1000, 0,1))
#shapiro.test(runif(1000, 0, 1))
### normality test : is the sample representive of a normal distribution population
##@ at each time step
### 95% true if   pvalue > 0.05 (pvalue mean risk of error when considering a normal distribution)

st.pv=vector()
k=0
for (i in sample( c(1:dim(reunion)[1]), size=100 ) )
{
  k=k+1
  st=shapiro.test(as.numeric(reunion[i,2:28]) )
  st.pv[k] = st$p.value
}
plot(density(st.pv), main= "normality test results  \n meeting room")
abline(v=0.05, col=2)


st.pv=vector()
k=0
for (i in sample( c(1:dim(bur105)[1]), size=100 ) )
{
  k=k+1
  st=shapiro.test(as.numeric(bur105[i,c(2, 4:26)]) )
  st.pv[k] = st$p.value
}
plot(density(st.pv), main= "normality test results  \n Room 105")
abline(v=0.05, col=2)


st.pv=vector()
k=0
for (i in sample( c(1:dim(bureaux)[1]), size=100 ) )
{
  k=k+1
  st=shapiro.test(as.numeric(bureaux[i,2:13]) )
  st.pv[k] = st$p.value
}
plot(density(st.pv), main= "normality test results  \n building")
abline(v=0.05, col=2)


### Uncertainty assessment








