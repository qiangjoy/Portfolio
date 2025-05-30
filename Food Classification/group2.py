import numpy as np
import pandas as pd

group2 = pd.read_csv('group2.csv')

group2.insert(2, "Food Group", "Grain")
group2.drop(group2.columns[[0,1]], axis=1, inplace=True) # deleting unused columns

group2.loc[72:79, "Food Group"] = "Dairy" 

if __name__ == "__main__":
    # To print all rows to check if they are classified properly
    with pd.option_context('display.max_rows', None, 'display.max_columns', None):
        print(group2[["Food Group", "food"]])
