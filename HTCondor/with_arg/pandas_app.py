import numpy as np
import pandas as pd
import datetime

with open('HRDataset.csv') as f:
    df = pd.read_csv(f)
f.close()
df.head()
df.info()
