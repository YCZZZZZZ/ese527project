'''
This file contains two methods that relates to data pre-processing.
Both of the methods deal with datasets that are processed before, i.e., reject outliers, remove N/A values, etc.
Datasets used here: traindata00.csv, traindata11.csv, traindata22.csv, and traindata33.csv.
'''

import numpy as np
import pandas as pd
from sklearn.preprocessing import LabelEncoder

'''
getTrainData():
For reading dataset for each type of energy:
1. read in processed training data
2. encode features that are string type
3. delete column that is useless for modeling (e.g. id)
4. return the edited dataset
'''
def getTrainData():
    Train0 = pd.read_csv('dataset/traindata00.csv', sep=',')
    bs0 = Train0['primary_use'].astype('category')
    code0 = bs0.cat.codes
    Train0['primary_use'] = code0
    Train0 = Train0.to_numpy()
    Train0 = np.delete(Train0, 0, axis=1)

    Train1 = pd.read_csv('dataset/traindata11.csv', sep=',')
    bs1 = Train1['primary_use'].astype('category')
    code1 = bs1.cat.codes
    Train1['primary_use'] = code1
    Train1 = Train1.to_numpy()
    Train1 = np.delete(Train1, 0, axis=1)

    Train2 = pd.read_csv('dataset/traindata22.csv', sep=',')
    bs2 = Train2['primary_use'].astype('category')
    code2 = bs2.cat.codes
    Train2['primary_use'] = code2
    Train2 = Train2.to_numpy()
    Train2 = np.delete(Train2, 0, axis=1)

    Train3 = pd.read_csv('dataset/traindata33.csv', sep=',')
    bs3 = Train3['primary_use'].astype('category')
    code3 = bs3.cat.codes
    Train3['primary_use'] = code3
    Train3 = Train3.to_numpy()
    Train3 = np.delete(Train3, 0, axis=1)

    return Train0, Train1, Train2, Train3

'''
splitData(TrainData):
1. split data into target and features
2. delete feature columns that are useless for modeling (e.g. id)
3. normalize feature values
'''
def splitData(TrainData):
    target = TrainData[:, 3]
    features = np.delete(TrainData, [0, 1, 2, 3], axis=1)
    features = (features - np.min(features, axis=0))/(np.max(features, axis=0) - np.min(features, axis=0))
    return target, features