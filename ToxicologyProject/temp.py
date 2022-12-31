import pandas as pd
data = pd.read_csv(r"ToxicologyProject\data\RawAggregatedToxicologyData.csv")
compounds = data["cmpdname"]

count = 0
prev = ""

for c in compounds:
    if (c == prev):
        pass
    else:
        count+=1
        prev = c
print(f"There are {count} unique compounds in the clean dataframe")