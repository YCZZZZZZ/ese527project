import os, gc
import datetime
import numpy as np
import pandas as pd
import category_encoders
from sklearn.impute import SimpleImputer
from sklearn.metrics import mean_squared_error
from sklearn.model_selection import KFold
from sklearn.preprocessing import LabelEncoder
from sklearn.preprocessing import PolynomialFeatures
from sklearn.linear_model import Lasso
from sklearn.linear_model import Ridge
from lightgbm import LGBMRegressor
from mlxtend.regressor import StackingRegressor
from pandas.api.types import is_categorical_dtype
from pandas.api.types import is_datetime64_any_dtype as is_datetime
import preProcessing

Train0, Train1, Train2, Train3 = preProcessing.getTrainDate()
#ele_edu = Train0[Train0[:, 4] == 'Education', :]
#target = ele_edu[:, 3]
#features = np.delete(ele_edu, [3, 1, 4], axis=1)

target = Train0[:, 3]
features = np.delete(Train0, [1, 3, 4], axis=1)

lightgbm = LGBMRegressor(objective='regression', learning_rate=0.1, num_leaves=1024,
    feature_fraction=0.6,  bagging_fraction=0.6, bagging_freq=5)
ridge = Ridge(alpha=0.5)
lasso = Lasso(alpha=0.5)
ploy = PolynomialFeatures(1)

kfold = KFold(n_splits=20, shuffle=True, random_state=0)


for idx, (train_idx, val_idx) in enumerate(kfold.split(features)):
    train_feature = features[train_idx]; train_target = target[train_idx]
    val_feature = features[val_idx]; val_target = target[val_idx]

    model = StackingRegressor(regressors=(ridge, lasso),
                              meta_regressor=lightgbm, use_features_in_secondary=True)
    ploy = PolynomialFeatures(2)
    train_feature_ploy = ploy.fit_transform(train_feature)
    val_feature_ploy = ploy.fit_transform(val_feature)
    #model = lasso
    model.fit(np.array(train_feature_ploy), np.array(train_target))
    print(model.predict(np.array(val_feature_ploy)))
    print('RMSE: {:.4f} of fold: {}'.format(
        np.sqrt(mean_squared_error(val_target, model.predict(np.array(val_feature_ploy)))), idx))
