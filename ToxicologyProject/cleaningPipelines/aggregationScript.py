import pandas as pd
import os

## Path to the folder storing files
path = "/Users/Heaton/Downloads/aquatic_data"

## List all files in the directory
files = os.listdir(path)
# print(files)

## Initialize empty dataframe to store result
dfList = []
for file in files:
    fullPath = os.path.join(path, file)
    if os.path.isfile(fullPath): # Personally think  this is redundant but better safe than sorry
        dfList.append(pd.read_csv(fullPath, sep="|"))
    
completeDataframe = pd.concat(dfList)
completeDataframe.to_csv(f"{path}/aggregatedData.csv", index=False)
