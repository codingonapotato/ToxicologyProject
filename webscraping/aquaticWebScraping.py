import time
import pandas as pd
import selenium.webdriver ## Module with the Selenium Webdriver class needed to interact with the browser
from selenium.webdriver.common.by import By ## Allows for selection by class name, css selector, xpath, etc.
from selenium.common.exceptions import NoSuchElementException ## For error handling

## Loading in data:
data = pd.read_csv(r"ToxicologyProject\data\2017_AVG_EPEST_HIGH_PLUS.csv")
casNum = data["CAS"]

## Website to be interacted with:
url = "https://cfpub.epa.gov/ecotox/search.cfm" 

## To instantiate the Chrome Webdriver and set-up to be headless:
chromeDriver = selenium.webdriver.Chrome()
selenium.webdriver.ChromeOptions().add_argument("headless")

## Automation Script:
# time.sleep is necessary between each step to ensure each subsequent element is loaded properly before 
# the execution of the next line
missingData = [] ## To store CAS nums with missing data for analytical purposes
global i 
i = 0 ## Counter for number of times loop executed for analytical purposes
prev = "" ## Variable to store the previous iterated CAS number to prevent downloading files for duplicate CAS numbers  
for cas in casNum:
    timeBtwnCmd = 1 ## Static variable for control flow
    if prev != cas:
        prev = cas ## Updating prev to show that we have already iterated for this CAS number
        chromeDriver.get(url)
        time.sleep(3) ## Just for the page to load fully
        try: 
            chromeDriver.find_element(By.XPATH, r'//*[@id="searchSidebar"]/div/div[1]/button').click()
            time.sleep(timeBtwnCmd)
            chromeDriver.find_element(By.XPATH, r'//*[@id="txAdvancedChemicalEntries"]').send_keys(str(cas))
            time.sleep(timeBtwnCmd)
            chromeDriver.find_element(By.XPATH, r'//*[@id="searchSidebar"]/div/div[7]/div/button').click()
            time.sleep(timeBtwnCmd)
            chromeDriver.find_element(By.XPATH, r'//*[@id="searchResultsPanel"]/div[1]/div/a').click()
            time.sleep(timeBtwnCmd)
            chromeDriver.find_element(By.XPATH, r'/html/body/div[112]/a[3]').click()
            time.sleep(timeBtwnCmd)
            i+=1
        except NoSuchElementException:
            missingData.append(cas)
            print("The element you are looking for could not be found :(")
    else:
        pass
        
print(f"Task completed! Delimited Data Files for {i} CAS numbers were retrieved")
print(f"{len(missingData)} CAS numbers were unscrapable")
# chromeDriver.save_screenshot("webscraping/testOut/WindowPreview.png") ## For testing purposes (to preview output)
