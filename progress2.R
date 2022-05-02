removeColsAllNa  <- function(x){x[, apply(x, 2, function(y) any(!is.na(y)))]}
Detection <- function (x, k = 0.05 * nrow(x), cutoff = 0.95, Method = "euclidean", 
                       rnames = FALSE, depth = FALSE, dense = F, distance = F, 
                       dispersion =F , statistic=T) 
{
  data = x
  cnumber = dim(x)[2]
  out = outliers::scores(x, type = 'z', prob = 0.95)
  if(statistic == F){
    out<-out
  }
  else{
    o11 <- outliers::scores(x, type = 'mad', prob = 0.95)
    for(i in 1:cnumber){
      o11[,i] <- as.numeric(o11[,i])
    }
    out11 <- as.numeric(row.names(x[which(rowSums(o11)!=0), ]))
    o12 <- outliers::scores(x, type = 'iqr', lim = 1.5)
    for(i in 1:cnumber){
      o12[,i] <- as.numeric(o12[,i])
    }
    out12 <- as.numeric(row.names(x[which(rowSums(o12)!=0),]))
    out <- intersect(intersect(out, out11), intersect(out, out12))
#    out <- intersect(out, out10)
  }
  if (dispersion == FALSE) {
    out = out
  }
  else {
    out2 = OutlierDetection::disp(x, cutoff = 0.95)$"Location of Outlier"
    out = intersect(out2, out)
  }
  if (distance == FALSE) {
    out = out
  }
  else {
    
    out4 = OutlierDetection::nnk(x, k = 0.05 * nrow(x), cutoff = 0.95, 
                                 Method = "euclidean", rnames = F)$"Location of Outlier"
    out = intersect(out4, out)
  }
  if (depth == FALSE) {
    out = out
  }
  else {
    out5 = OutlierDetection::depthout(x)$"Location of Outlier"
    out = intersect(out5, out)
  }
  if (dense == FALSE) {
    out = out
  }
  else {
    out5 = OutlierDetection::dens(x)$"Location of Outlier"
    out = intersect(out5, out)
  }
  if (ncol(x) == 2) {
    d = 1:nrow(data)
    Class = c()
    Class = rep("Normal", length(d))
    for (i in 1:length(out)) {
      Class[d == out[i]] = "Outlier"
    }
    cols <- c(Outlier = "red", Normal = "blue")
    if (rnames == T) {
      s = subset(data, Class == "Outlier")
      gplot = ggplot2::ggplot(data, aes(data[, 1], data[, 
                                                        2])) + geom_point(aes(colour = Class, pch = Class)) + 
        geom_text(data = s, aes(x = s[, 1], y = s[, 2], 
                                label = rownames(s)), colour = "Red", hjust = "inward", 
                  check_overlap = T) + ggtitle("Outlier plot") + 
        xlab("Variable1") + ylab("Variable2") + scale_color_manual(values = cols)
    }
    else {
      dd = cbind(data, 1:nrow(data))
      s = subset(dd, Class == "Outlier")
      gplot = ggplot2::ggplot(data, aes(data[, 1], data[, 
                                                        2])) + geom_point(aes(colour = Class, pch = Class)) + 
        geom_text(data = s, aes(x = s[, 1], y = s[, 2], 
                                label = s[, 3]), colour = "Red", hjust = "inward", 
                  check_overlap = T) + ggtitle("Outlier plot") + 
        xlab("Variable1") + ylab("Variable2") + scale_color_manual(values = cols)
    }
    Out = x[out, ]
    l = list(`Outlier Observations` = Out, `Location of Outlier` = out, 
             `Scatter plot` = gplot)
  }
  else {
    Out = x[out, ]
    l = list(`Outlier Observations` = Out, `Location of Outlier` = out)
  }
  return(l)
}

weatherData <- rbind(weather_train0, weather_train2, weather_train3, 
                     weather_train4, weather_train6, weather_train8, 
                     weather_train9, weather_train10, weather_train12, 
                     weather_train13, weather_train14)
traindata00 <- merge(traindata0, weatherData, by=c('site_id', 'timestamp'))
traindata11 <- merge(traindata1, weatherData, by=c('site_id', 'timestamp'))
traindata22 <- merge(traindata2, weatherData, by=c('site_id', 'timestamp'))
traindata33 <- merge(traindata3, weatherData, by=c('site_id', 'timestamp'))
zero0 <- which(traindata00$meter_reading < 1)
zero1 <- which(traindata11$meter_reading < 1)
zero2 <- which(traindata22$meter_reading < 1)
zero3 <- which(traindata33$meter_reading < 1)
traindata00 <- traindata00[-zero0, ]
traindata11 <- traindata11[-zero1, ]
traindata22 <- traindata22[-zero2, ]
traindata33 <- traindata33[-zero3, ]
z0 <- which(outliers::scores(traindata00$meter_reading, type = 'z', prob = 0.95)==T)
mad0 <- which(outliers::scores(traindata00$meter_reading, type = 'mad', prob=0.95)==T)
iqr0 <- which(outliers::scores(traindata00$meter_reading, type = 'iqr', prob = 0.95)==T)
z1 <- which(outliers::scores(traindata11$meter_reading, type = 'z', prob = 0.95)==T)
mad1 <- which(outliers::scores(traindata11$meter_reading, type = 'mad', prob=0.95)==T)
iqr1 <- which(outliers::scores(traindata11$meter_reading, type = 'iqr', prob = 0.95)==T)
z2 <- which(outliers::scores(traindata22$meter_reading, type = 'z', prob = 0.95)==T)
mad2 <- which(outliers::scores(traindata22$meter_reading, type = 'mad', prob=0.95)==T)
iqr2 <- which(outliers::scores(traindata22$meter_reading, type = 'iqr', prob = 0.95)==T)
z3 <- which(outliers::scores(traindata33$meter_reading, type = 'z', prob = 0.95)==T)
mad3 <- which(outliers::scores(traindata3$meter_reading, type = 'mad', prob=0.95)==T)
iqr3 <- which(outliers::scores(traindata33$meter_reading, type = 'iqr', prob = 0.95)==T)
print(summary(traindata00[z0, ]$meter_reading))
print(summary(traindata00[mad0, ]$meter_reading))
print(summary(traindata11[z1, ]$meter_reading))
print(summary(traindata11[mad1, ]$meter_reading))
print(summary(traindata22[z2, ]$meter_reading))
print(summary(traindata22[mad2, ]$meter_reading))
print(summary(traindata33[z3, ]$meter_reading))
print(summary(traindata33[mad3, ]$meter_reading))
traindata00 <- traindata00[-mad0, ]
traindata11 <- traindata11[-mad1, ]
traindata22 <- traindata22[-mad2, ]
traindata33 <- traindata33[-mad3, ]
traindata00 <- traindata00[-which(traindata00$primary_use == 'Other'), ]
traindata11 <- traindata11[-which(traindata11$primary_use == 'Other'), ]
traindata22 <- traindata22[-which(traindata22$primary_use == 'Other'), ]
traindata33 <- traindata33[-which(traindata33$primary_use == 'Other'), ]
traindata33 <- traindata33[-which(traindata33$primary_use == 'Other'), ]
traindata33 <- traindata33[-which(traindata33$primary_use == 'Other'), ]
