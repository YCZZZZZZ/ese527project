import numpy as np
import pandas as pd

def getTrainDate():
    Train0 = pd.read_csv('dataset/traindata00.csv', sep=',').to_numpy()
    Train0 = np.array(Train0)
    Train0 = np.delete(Train0, 0, axis=1)

    Train1 = pd.read_csv('dataset/traindata11.csv', sep=',').to_numpy()
    Train1 = np.array(Train1)
    Train1 = np.delete(Train1, 0, axis=1)

    Train2 = pd.read_csv('dataset/traindata22.csv', sep=',').to_numpy()
    Train2 = np.array(Train2)
    Train2 = np.delete(Train2, 0, axis=1)

    Train3 = pd.read_csv('dataset/traindata33.csv', sep=',').to_numpy()
    Train3 = np.array(Train3)
    Train3 = np.delete(Train3, 0, axis=1)

    return Train0, Train1, Train2, Train3
