import numpy as np
import pandas as pd

group1 = pd.read_csv('group1.csv')

group1.insert(2, "Food Group", "Dairy") #adding food group dairy (most common)
group1.drop(group1.columns[[0,1]], axis=1, inplace=True)

group1.loc[ 42:236, "Food Group"] = "Meat"
group1.loc[ 40:41, "Food Group"] = "Grain"

if __name__ == "__main__":
    # To print all rows to check if they are classified properly
    with pd.option_context('display.max_rows', None, 'display.max_columns', None):
        print(group1[["Food Group", "food"]])
