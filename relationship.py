import preProcessing
import numpy as np
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
from sklearn.preprocessing import LabelEncoder

le = LabelEncoder()
data = pd.read_csv('dataset/traindata00.csv', sep=',', index_col=0)
data['primary_use'] = le.fit_transform(data['primary_use'])
cols = data.corr().index
cm = data[cols].corr()
plt.figure(figsize=(20, 12))
sns.heatmap(cm, annot=True, cmap='coolwarm')
plt.show()

# correlation matrix
print(cm.corr())
