

# read data csv
building_metadata_raw.df <- read.csv("~/Desktop/ESE 527/Project/ashrae-energy-prediction/building_metadata.csv")
train_raw.df <- read.csv("~/Desktop/ESE 527/Project/ashrae-energy-prediction/train.csv")
weather_train_raw.df <- read.csv("~/Desktop/ESE 527/Project/ashrae-energy-prediction/weather_train.csv")

# split training data set based on meter type
# 0: electricity, 1: chilledwater, 2: steam, 3: hotwater
train_raw0.df = train_raw.df[train_raw.df$meter==0,] 
train_raw1.df = train_raw.df[train_raw.df$meter==1,]
train_raw2.df = train_raw.df[train_raw.df$meter==2,]
train_raw3.df = train_raw.df[train_raw.df$meter==3,]

# change timestamp to date only for training dataset
train_date_raw0.df <- train_raw0.df
train_date_raw0.df$timestamp <- as.Date(as.POSIXct(train_date_raw0.df$timestamp))
train_date_raw1.df <- train_raw1.df
train_date_raw1.df$timestamp <- as.Date(as.POSIXct(train_date_raw1.df$timestamp))
train_date_raw2.df <- train_raw2.df
train_date_raw2.df$timestamp <- as.Date(as.POSIXct(train_date_raw2.df$timestamp))
train_date_raw3.df <- train_raw3.df
train_date_raw3.df$timestamp <- as.Date(as.POSIXct(train_date_raw3.df$timestamp))

# change timestamp to date only for weather dataset
weather_train_date_raw.df <- weather_train_raw.df
weather_train_date_raw.df$timestamp <- as.Date(as.POSIXct(weather_train_date_raw.df$timestamp))

# find average meter_reading group by id and date
train_date_avg_raw0.df <- aggregate(train_date_raw0.df$meter_reading, list(train_date_raw0.df$building_id, train_date_raw0.df$meter, train_date_raw0.df$timestamp), mean, na.rm = TRUE)
colnames(train_date_avg_raw0.df) <- c("building_id", "meter", "timestamp", "meter_reading")
train_date_avg_raw1.df <- aggregate(train_date_raw1.df$meter_reading, list(train_date_raw1.df$building_id, train_date_raw1.df$meter, train_date_raw1.df$timestamp), mean, na.rm = TRUE)
colnames(train_date_avg_raw1.df) <- c("building_id", "meter", "timestamp", "meter_reading")
train_date_avg_raw2.df <- aggregate(train_date_raw2.df$meter_reading, list(train_date_raw2.df$building_id, train_date_raw2.df$meter, train_date_raw2.df$timestamp), mean, na.rm = TRUE)
colnames(train_date_avg_raw2.df) <- c("building_id", "meter", "timestamp", "meter_reading")
train_date_avg_raw3.df <- aggregate(train_date_raw3.df$meter_reading, list(train_date_raw3.df$building_id, train_date_raw3.df$meter, train_date_raw3.df$timestamp), mean, na.rm = TRUE)
colnames(train_date_avg_raw3.df) <- c("building_id", "meter", "timestamp", "meter_reading")

# find average weather data group by site_id and date
weather_train_date_avg_raw.df <- aggregate(weather_train_date_raw.df[,3:9], weather_train_date_raw.df[,1:2], mean, na.rm = TRUE)

# combine train dataset and building dataset and sort based on id and date
train_building_raw0.df <- merge(x=train_date_avg_raw0.df, y=building_metadata_raw.df, by="building_id")
train_building_raw1.df <- merge(x=train_date_avg_raw1.df, y=building_metadata_raw.df, by="building_id")
train_building_raw2.df <- merge(x=train_date_avg_raw2.df, y=building_metadata_raw.df, by="building_id")
train_building_raw3.df <- merge(x=train_date_avg_raw3.df, y=building_metadata_raw.df, by="building_id")

# combine the above dataset with weather data
train_building_weather_raw0.df <- merge(x=train_building_raw0.df, y=weather_train_date_avg_raw.df, by=c("timestamp","site_id"))
train_building_weather_raw1.df <- merge(x=train_building_raw1.df, y=weather_train_date_avg_raw.df, by=c("timestamp","site_id"))
train_building_weather_raw2.df <- merge(x=train_building_raw2.df, y=weather_train_date_avg_raw.df, by=c("timestamp","site_id"))
train_building_weather_raw3.df <- merge(x=train_building_raw3.df, y=weather_train_date_avg_raw.df, by=c("timestamp","site_id"))

# sort based on id and date
#### need to be removed, we have to sort the combination set of 3 datasets, instead of only 2
train_building_weather_sort_raw0.df <- train_building_weather_raw0.df[order(train_building_weather_raw0.df$timestamp, train_building_weather_raw0.df$building_id), ]
train_building_weather_sort_raw1.df <- train_building_weather_raw1.df[order(train_building_weather_raw1.df$timestamp, train_building_weather_raw1.df$building_id), ]
train_building_weather_sort_raw2.df <- train_building_weather_raw2.df[order(train_building_weather_raw2.df$timestamp, train_building_weather_raw2.df$building_id), ]
train_building_weather_sort_raw3.df <- train_building_weather_raw3.df[order(train_building_weather_raw3.df$timestamp, train_building_weather_raw3.df$building_id), ]

# check NaN values in df
# train_date_avg_raw3.df$meter_reading[is.nan(train_date_avg_raw3.df$meter_reading) == TRUE]
