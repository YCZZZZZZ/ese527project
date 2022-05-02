# read data csv
building_metadata_raw <- read.csv("~/Desktop/Washu/ESE527/527project/building_metadata.csv")
train_raw <- read.csv("~/Desktop/Washu/ESE527/527project/train.csv")
weather_train_raw <- read.csv("~/Desktop/Washu/ESE527/527project/weather_train.csv")
test_raw <- read.csv("~/Desktop/Washu/ESE527/527project/test.csv")
weather_test_raw <- read.csv("~/Desktop/Washu/ESE527/527project/weather_test.csv")

# change timestamp to date 
train_raw$timestamp <- as.Date(as.POSIXct(train_raw$timestamp))
weather_train_raw$timestamp<- as.Date(as.POSIXct(weather_train_raw$timestamp))

# split training data set based on meter type
# 0: electricity, 1: chilledwater, 2: steam, 3: hotwater
train_raw0 = train_raw[train_raw$meter==0,] 
train_raw1 = train_raw[train_raw$meter==1,]
train_raw2 = train_raw[train_raw$meter==2,]
train_raw3 = train_raw[train_raw$meter==3,]
test_raw0 = test_raw[test_raw$meter==0,] 
test_raw1 = test_raw[test_raw$meter==1,]
test_raw2 = test_raw[test_raw$meter==2,]
test_raw3 = test_raw[test_raw$meter==3,]

# find average meter_reading group by id and date (training dataset)
train_avg_raw0 <- aggregate(train_raw0$meter_reading, list(train_raw0$building_id, train_raw0$meter, train_raw0$timestamp), mean, na.rm = TRUE)
colnames(train_avg_raw0) <- c("building_id", "meter", "timestamp", "meter_reading")
train_avg_raw1 <- aggregate(train_raw1$meter_reading, list(train_raw1$building_id, train_raw1$meter, train_raw1$timestamp), mean, na.rm = TRUE)
colnames(train_avg_raw1) <- c("building_id", "meter", "timestamp", "meter_reading")
train_avg_raw2 <- aggregate(train_raw2$meter_reading, list(train_raw2$building_id, train_raw2$meter, train_raw2$timestamp), mean, na.rm = TRUE)
colnames(train_avg_raw2) <- c("building_id", "meter", "timestamp", "meter_reading")
train_avg_raw3 <- aggregate(train_raw3$meter_reading, list(train_raw3$building_id, train_raw3$meter, train_raw3$timestamp), mean, na.rm = TRUE)
colnames(train_avg_raw3) <- c("building_id", "meter", "timestamp", "meter_reading")

# find average weather data group by site_id and date
weather_train_avg_raw <- aggregate(weather_train_raw[,3:9], weather_train_raw[,1:2], mean, na.rm = TRUE)

# combine train dataset and building dataset and sort based on id and date
train0 <- merge(x=train_avg_raw0, y=building_metadata_raw, by="building_id")
train1 <- merge(x=train_avg_raw1, y=building_metadata_raw, by="building_id")
train2 <- merge(x=train_avg_raw2, y=building_metadata_raw, by="building_id")
train3 <- merge(x=train_avg_raw3, y=building_metadata_raw, by="building_id")

# combine the above dataset with weather data
train0 <- merge(x=train0, y=weather_train_avg_raw, by=c("timestamp","site_id"))
train1 <- merge(x=train1, y=weather_train_avg_raw, by=c("timestamp","site_id"))
train2 <- merge(x=train2, y=weather_train_avg_raw, by=c("timestamp","site_id"))
train3 <- merge(x=train3, y=weather_train_avg_raw, by=c("timestamp","site_id"))
