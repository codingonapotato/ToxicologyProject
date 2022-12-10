import requests
import math
import time
import pandas as pd
import webbrowser
from bs4 import BeautifulSoup

## Importing Data:
data = pd.read_csv("ToxicologyProject/data/2017_AVG_EPEST_HIGH.csv")
compounds = data["COMPOUND"]
##
#
## Pipeline to scrape CID's given an 1D array of strings with the commmon chemical name pesticides fed to it
## and to write the results to a csv:
prolog = "https://pubchem.ncbi.nlm.nih.gov/compound/"  
CIDs = []
missingCompounds = []

print("Initializing Script")
for c in compounds:
    print("Finding CID for: " + c)
    url = prolog + c
    page = requests.get(url)
    soup = BeautifulSoup(page.content, "html.parser")
    results = soup.find("meta", {"name":"pubchem_uid_value"})
    if results != None:
        cid = results["content"]
        CIDs.append(cid)
    else:
        missingCompounds.append(c)
        CIDs.append("NA")
        
print("done")
print("Here are the CIDs that could be found: ", CIDs)
print("Here are the compounds that the CIDs could not be automatically scraped: ", missingCompounds)

##  Use this to append results as a new column on the existing dataframe:
# data.insert(2, column= "CID", value = CIDs)
# data.to_csv("ToxicologyProject/data/2017_EPEST_CID.csv")

## Pipeline to retrieve the CSVs for the pesticides with CIDs:
dataWithCIDs = pd.read_csv("ToxicologyProject/data/2017_EPEST_CID.csv")
CIDs = dataWithCIDs["CID"]
for c in CIDs:
    if not math.isnan(c):
        intC = int(c)
        strCID = str(intC)
        print("Retrieving Toxicology Data for CID: " + strCID)
        sdq = "https://pubchem.ncbi.nlm.nih.gov/sdq/sdqagent.cgi?infmt=json&outfmt=csv&query="
        parameter_1 = "{%22download%22:%22*%22,%22collection%22:%22chemidplus%22,%22where%22:{%22ands%22:[{%22cid%22:%22" + strCID + "%22}]}" 
        # for some reason the above is still able to successfully extract from nioh even tho I am accessing through chemidplus interesting! it auto redirects
        parameter_2 = ",%22order%22:[%22relevancescore,desc%22],%22start%22:1,%22limit%22:10000000,%22downloadfilename%22:%22CID_" + strCID + "_niosh%22}"
        completeURL = sdq + parameter_1 + parameter_2
        time.sleep(1)
        webbrowser.open(completeURL)
