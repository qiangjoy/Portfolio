import numpy as np
import pandas as pd

group3 = pd.read_csv("group3.csv")

group3.insert(2, "Food Group", "Meat") # added food group column. Set to meat since as default since it's most common.
group3.drop(group3.columns[[0,1]], axis=1, inplace=True) # deleting unused columns

# Classifying chunks of foods
group3.loc[ 0:136, "Food Group"] = "Fruit" 
group3.loc[ 137:202, "Food Group"] = "Vegetables"


if __name__ == "__main__":
    # To print all rows to check if they are classified properly
    with pd.option_context('display.max_rows', None, 'display.max_columns', None):
        print(group3[["Food Group", "food"]])
