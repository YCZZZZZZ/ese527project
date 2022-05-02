'''
This file contains the model training part, including the cross-validation.
1.  We trained the following models: 
    LGBM Regressor, Random Forest regression, 
    Ridge regression, Lasso regression, and KNN regressor.
2.  We performed the 10-fold validation and computed the mean of RMSE and RMLSE.
3.  We computed the time cost for each model.
'''

import numpy as np
from sklearn.model_selection import KFold
from sklearn.preprocessing import PolynomialFeatures
from sklearn.linear_model import Lasso
from sklearn.linear_model import Ridge
from sklearn.neighbors import KNeighborsRegressor
from sklearn.linear_model import LinearRegression
from sklearn.metrics import mean_squared_error
from sklearn.ensemble import RandomForestRegressor
from lightgbm import LGBMRegressor
import preProcessing2 # use methods implemented in preProcessing2.py
import time

time_start = time.time() # start time

# read in pre-processed training data
# one dataset for one type of meter reading
Train0, Train1, Train2, Train3 = preProcessing.getTrainData()

# split training data into target column and feature columns
target0, features0 = preProcessing.splitData(Train0)
target1, features1 = preProcessing.splitData(Train1)
target2, features2 = preProcessing.splitData(Train2)
target3, features3 = preProcessing.splitData(Train3)

# try several regression models below
# LGBM Regressor, a GBDT (Gradient Boosting Decision Tree) model
lightgbm = LGBMRegressor(objective='regression', learning_rate=0.1, num_leaves=1024,
    feature_fraction=0.6,  bagging_fraction=0.6, bagging_freq=5)

# Random Forest regression
RandomRegression = RandomForestRegressor(n_estimators=10, max_depth=5, random_state=10)

# Ridge regression
ridge = Ridge(alpha=2)

# Lasso regression
lasso = Lasso(alpha=2)

# Linear regression
lr = LinearRegression()

# KNN regressor
knn = KNeighborsRegressor()

# perform 10-fold validation, choose one model each time
kfold = KFold(n_splits=10, shuffle=True, random_state=0)
RMLSE_mean = []
RMSE_mean = []
for idx, (train_idx, val_idx) in enumerate(kfold.split(features0)):
    train_feature = features0[train_idx]; train_target = target0[train_idx]
    val_feature = features0[val_idx]; val_target = target0[val_idx]
    ploy = PolynomialFeatures(2)
    train_feature = ploy.fit_transform(train_feature)
    val_feature = ploy.fit_transform(val_feature)
    model = lightgbm # choose a model each time
    model.fit(np.array(train_feature), np.array(train_target))
    prediction = model.predict(np.array(val_feature))
    prediction1 = (prediction+1).tolist()
    val_target1 = (val_target+1).tolist()
    length = len(val_target)
    for i in range(length):
        if prediction1[i] < 1:
            prediction1[i] = 1
    RMLSE = np.sqrt((1/length)*np.sum(np.square(np.log(prediction1) - np.log(val_target1))))
    RMLSE_mean.append(RMLSE)
    RMSE = np.sqrt(mean_squared_error(prediction, val_target))
    RMSE_mean.append(RMSE)

# compute and output the mean of RMSE
RMSE_mean = np.mean(RMSE) 
print('RMSE is')
print(RMSE_mean)

# compute and output the mean of RMLSE
RMLSE_mean = np.mean(RMLSE_mean) 
print('RMLSE is')
print(RMLSE_mean)

time_end = time.time() # end time

# compute and output time cost for the chosen model
print('time cost', time_end-time_start, 's')