import numpy as np
import pandas as pd
from sklearn.preprocessing import LabelEncoder

def getTrainDate():

    le = LabelEncoder()

    Train0 = pd.read_csv('dataset/traindata00.csv', sep=',').to_numpy()
    Train0[:, 5] = le.fit_transform(Train0[:, 5])
    Train0 = np.array(Train0)
    Train0 = np.delete(Train0, 0, axis=1)

    Train1 = pd.read_csv('dataset/traindata11.csv', sep=',').to_numpy()
    Train1[:, 5] = le.fit_transform(Train1[:, 5])
    Train1 = np.array(Train1)
    Train1 = np.delete(Train1, 0, axis=1)

    Train2 = pd.read_csv('dataset/traindata22.csv', sep=',').to_numpy()
    Train2[:, 5] = le.fit_transform(Train2[:, 5])
    Train2 = np.array(Train2)
    Train2 = np.delete(Train2, 0, axis=1)

    Train3 = pd.read_csv('dataset/traindata33.csv', sep=',').to_numpy()
    Train3[:, 5] = le.fit_transform(Train3[:, 5])
    Train3 = np.array(Train3)
    Train3 = np.delete(Train3, 0, axis=1)

    return Train0, Train1, Train2, Train3

def splitData(TrainData):
    target = TrainData[:, 3]
    features = np.delete(TrainData, [1, 3], axis=1)
    return target, features

Trian0, _, _, _ = getTrainDate()
print(np.mean(Trian0[:, 3]))