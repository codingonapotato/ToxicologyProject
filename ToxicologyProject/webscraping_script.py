import requests
import math
import time
import pandas as pd
import webbrowser
from bs4 import BeautifulSoup
import selenium.webdriver
from selenium.webdriver.common.action_chains import ActionChains
from selenium.webdriver.chrome.service import Service
from webdriver_manager.chrome import ChromeDriverManager
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.by import By
from selenium.common.exceptions import NoSuchElementException

## Importing Data and Initializing:
PROLOG = "https://pubchem.ncbi.nlm.nih.gov/compound/"  
data = pd.read_csv('ToxicologyProject/data/2017_AVG_EPEST_HIGH.csv')
compounds = data["COMPOUND"]

def retrievePageContent(url):
    page = requests.get(url)
    soup = BeautifulSoup(page.content, "html.parser")
    return soup
##
#
## Pipeline to scrape CID's given an 1D array of strings with the commmon chemical name pesticides fed to it
## and to write the results to a csv:
# CIDs = []
# missingCompounds = []

# print("Initializing Script")
# for c in compounds:
#     print("Finding CID for: " + c)
#     url = PROLOG + c
#     soup = retrievePageContent(url)
#     results = soup.find("meta", {"name":"pubchem_uid_value"})
#     if results != None:
#         cid = results["content"]
#         CIDs.append(cid)
#     else:
#         missingCompounds.append(c)
#         CIDs.append("NA")
        
# print("done")
# print("Here are the CIDs that could be found: ", CIDs)
# print("Here are the compounds that the CIDs could not be automatically scraped: ", missingCompounds)

##  Use this to append results as a new column on the existing dataframe:
# data.insert(2, column= "CID", value = CIDs)
# data.to_csv("ToxicologyProject/data/2017_EPEST_CID.csv")

## Pipeline to retrieve the CSVs for the pesticides with CIDs:
# dataWithCIDs = pd.read_csv("ToxicologyProject/data/2017_EPEST_CID.csv")
# CIDs = dataWithCIDs["CID"]
# for c in CIDs:
#     if not math.isnan(c):
#         intC = int(c)
#         strCID = str(intC)
#         print("Retrieving Toxicology Data for CID: " + strCID)
#         sdq = "https://pubchem.ncbi.nlm.nih.gov/sdq/sdqagent.cgi?infmt=json&outfmt=csv&query="
#         parameter_1 = "{%22download%22:%22*%22,%22collection%22:%22chemidplus%22,%22where%22:{%22ands%22:[{%22cid%22:%22" + strCID + "%22}]}" 
#         # for some reason the above is still able to successfully extract from nioh even tho I am accessing through chemidplus interesting! it auto redirects
#         parameter_2 = ",%22order%22:[%22relevancescore,desc%22],%22start%22:1,%22limit%22:10000000,%22downloadfilename%22:%22CID_" + strCID + "_niosh%22}"
#         completeURL = sdq + parameter_1 + parameter_2
#         time.sleep(1)
#         webbrowser.open(completeURL)

# Pipeline to retrieve the CAS numbers for compounds based on unique PubChem CID:
rawData = pd.read_csv("ToxicologyProject\data\CleanAggregatedToxData.csv")
chromeDriver = selenium.webdriver.Chrome(service=Service(ChromeDriverManager().install()))
cidList = rawData["cid"]
prev = 0
prevCAS = ""
casNums = []
casMissingCID = []

for cid in cidList:
    if (cid == prev): # Checks to see if the currently element has been looped for already
        casNums.append(prevCAS) 
    else:
        prev = cid # Takes current cid as the previous (relative to the next element in array)
        strCID = str(cid)
        url = PROLOG + strCID
        chromeDriver.get(url)
        time.sleep(5)
        try: 
            result = chromeDriver.find_element(By.XPATH, r'//*[@id="CAS"]/div[2]/div[1]')
            readableResult = result.text
            casNums.append(readableResult)
            prevCAS = readableResult # Used to keep all arrays in lockstep in case of duplicate elements
        except NoSuchElementException:
            casNums.append(0) # 0 is dummy variable to indicate error/missing
            prevCAS = 0 # in case next element is also the same cid
            casMissingCID.append(cid) # for convenience
rawData.insert(1, column="CAS", value=casNums)
rawData.to_csv("ToxicologyProject/data/testOut.csv")

print(f"Here are all the CAS numbers that could be found: {casNums}")
print(f"Here are all the CID's where the CAS numbers could not be found: {casMissingCID}")   
