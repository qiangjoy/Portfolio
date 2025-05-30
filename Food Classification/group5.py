import numpy as np
import pandas as pd

group5 = pd.read_csv("group5.csv")

group5.insert(2, "Food Group", "Fat") # added food group column. Set to meat since as default since it's most common.
group5.drop(group5.columns[[0,1]], axis=1, inplace=True) # deleting unused columns

# Classifying chunks of foods
group5.loc[55:134, "Food Group"] = "Grain" 
group5.loc[134:403, "Food Group"] = "Vegetables" 


if __name__ == "__main__":
    # To print all rows to check if they are classified properly
    with pd.option_context('display.max_rows', None, 'display.max_columns', None):
        print(group5[["Food Group", "food"]])
