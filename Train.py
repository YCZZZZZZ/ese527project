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
import preProcessing
import time

time_start = time.time()
Train0, Train1, Train2, Train3 = preProcessing.getTrainDate()
target0, features0 = preProcessing.splitData(Train0)
target1, features1 = preProcessing.splitData(Train1)
target2, features2 = preProcessing.splitData(Train2)
target3, features3 = preProcessing.splitData(Train3)

lightgbm = LGBMRegressor(objective='regression', learning_rate=0.1, num_leaves=1024,
    feature_fraction=0.6,  bagging_fraction=0.6, bagging_freq=5)
RandomRegression = RandomForestRegressor(n_estimators=10, max_depth=5, random_state=10)
ridge = Ridge(alpha=2)
lasso = Lasso(alpha=2)
lr = LinearRegression()
knn = KNeighborsRegressor()

kfold = KFold(n_splits=10, shuffle=True, random_state=0)
#
RMLES_mean = []
RMSE_mean = []
for idx, (train_idx, val_idx) in enumerate(kfold.split(features0)):
    train_feature = features0[train_idx]; train_target = target0[train_idx]
    val_feature = features0[val_idx]; val_target = target0[val_idx]

    ploy = PolynomialFeatures(2)
    train_feature = ploy.fit_transform(train_feature)
    val_feature = ploy.fit_transform(val_feature)
    model = lightgbm
    model.fit(np.array(train_feature), np.array(train_target))
    prediction = model.predict(np.array(val_feature))
    prediction1 = (prediction+1).tolist()
    val_target1 = (val_target+1).tolist()
    length = len(val_target)
    for i in range(length):
        if prediction1[i] < 1:
            prediction1[i] = 1
    RMLSE = np.sqrt((1/length)*np.sum(np.square(np.log(prediction1) - np.log(val_target1))))
    RMLES_mean.append(RMLSE)
    RMSE = np.sqrt(mean_squared_error(prediction, val_target))
    RMSE_mean.append(RMSE)
RMLES_mean = np.mean(RMLES_mean)
RMSE_mean = np.mean(RMSE)
print('RMSE is')
print(RMSE_mean)
print('RMLSE is')
print(RMLES_mean)

time_end = time.time()
print('time cost', time_end-time_start, 's')
