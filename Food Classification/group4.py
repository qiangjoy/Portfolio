import numpy as np
import pandas as pd

group4 = pd.read_csv("group4.csv")

group4.insert(2, "Food Group", "Dairy") # added food group column. Set to meat since as default since it's most common.
group4.drop(group4.columns[[0,1]], axis=1, inplace=True) # deleting unused columns


if __name__ == "__main__":
    # To print all rows to check if they are classified properly
    with pd.option_context('display.max_rows', None, 'display.max_columns', None):
        print(group4[["Food Group", "food"]])
