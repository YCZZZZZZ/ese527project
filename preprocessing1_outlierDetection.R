# a function removing the column with NA
removeColsAllNa  <- function(x){x[, apply(x, 2, function(y) any(!is.na(y)))]}

# detecting some obvious outliers (meter reading is very small)
zero0 <- which(train0$meter_reading < 1)
zero1 <- which(train1$meter_reading < 1)
zero2 <- which(train2$meter_reading < 1)
zero3 <- which(train3$meter_reading < 1)
traindata00 <- train0[-zero0, ]
traindata11 <- train1[-zero1, ]
traindata22 <- train2[-zero2, ]
traindata33 <- train3[-zero3, ]

# using statistic approaches to detect outliers
z0 <- which(outliers::scores(traindata00$meter_reading, type = 'z', prob = 0.95)==T)
mad0 <- which(outliers::scores(traindata00$meter_reading, type = 'mad', prob=0.95)==T)
z1 <- which(outliers::scores(traindata11$meter_reading, type = 'z', prob = 0.95)==T)
mad1 <- which(outliers::scores(traindata11$meter_reading, type = 'mad', prob=0.95)==T)
z2 <- which(outliers::scores(traindata22$meter_reading, type = 'z', prob = 0.95)==T)
mad2 <- which(outliers::scores(traindata22$meter_reading, type = 'mad', prob=0.95)==T)
z3 <- which(outliers::scores(traindata33$meter_reading, type = 'z', prob = 0.95)==T)
mad3 <- which(outliers::scores(traindata33$meter_reading, type = 'mad', prob=0.95)==T)
outliers0 <- intersect(z0, mad0)
outliers1 <- intersect(z1, mad1)
outliers2 <- intersect(z2, mad2)
outliers3 <- intersect(z3, mad3)

# detect and delete columns which has too many NA and NaN 
for(i in 1:dim(traindata00)[2]){
  if(sum(is.na(traindata00[, i])) > 0.1*dim(traindata00)[1]){traindata00 <- traindata00[,-i]}
}
for(i in 1:dim(traindata00)[2]){
  if(sum(is.nan(traindata00[, i])) > 0.1*dim(traindata00)[1]){traindata00 <- traindata00[,-i]}
}
for(i in 1:dim(traindata11)[2]){
  if(sum(is.na(traindata11[, i])) > 0.1*dim(traindata11)[1]){traindata11 <- traindata11[,-i]}
}
for(i in 1:dim(traindata11)[2]){
  if(sum(is.nan(traindata11[, i])) > 0.1*dim(traindata11)[1]){traindata11 <- traindata11[,-i]}
}
for(i in 1:dim(traindata22)[2]){
  if(sum(is.na(traindata22[, i])) > 0.1*dim(traindata22)[1]){traindata22 <- traindata22[,-i]}
}
for(i in 1:dim(traindata22)[2]){
  if(sum(is.nan(traindata22[, i])) > 0.1*dim(traindata22)[1]){traindata22 <- traindata22[,-i]}
}
for(i in 1:dim(traindata33)[2]){
  if(sum(is.na(traindata33[, i])) > 0.1*dim(traindata33)[1]){traindata33 <- traindata33[,-i]}
}
for(i in 1:dim(traindata33)[2]){
  if(sum(is.nan(traindata33[, i])) > 0.1*dim(traindata33)[1]){traindata33 <- traindata33[,-i]}
}

# delete all na and Nan values
traindata00 <- na.omit(traindata00)
traindata11 <- na.omit(traindata11)
traindata22 <- na.omit(traindata22)
traindata33 <- na.omit(traindata33)

# check that there are no na and nan values in our dataset
print(sum(is.na(traindata00)))
print(sum(is.na(traindata11)))
print(sum(is.na(traindata22)))
print(sum(is.na(traindata33)))

# remove outliers we detected before
traindata00 <- traindata00[-outliers0,]
traindata11 <- traindata11[-outliers1,]
traindata22 <- traindata22[-outliers2,]
traindata33 <- traindata33[-outliers3,]

# write dataset
write.csv(traindata00, '~/Desktop/Washu/ESE527/527project/traindata00.csv', row.names=FALSE)
write.csv(traindata11, '~/Desktop/Washu/ESE527/527project/traindata11.csv', row.names=FALSE)
write.csv(traindata22, '~/Desktop/Washu/ESE527/527project/traindata22.csv', row.names=FALSE)
write.csv(traindata33, '~/Desktop/Washu/ESE527/527project/traindata33.csv', row.names=FALSE)
