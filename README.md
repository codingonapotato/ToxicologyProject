# **Toxicology Project**
*\*Currently ongoing project*

## What is the Toxicology Project Repository?
---
> The Toxicology Project repository stores files for an ongoing project where I write python & R scripts to automate data collection and cleaning from reputable databases for toxicology data. This data is used for research with the WildLife and Conservation Economics Laboratory at UBC.

<br/>

## List of Sources
---
###  PubChem:
> https://pubchem.ncbi.nlm.nih.gov/
### EcoToX:
> https://cfpub.epa.gov/ecotox/

<br/>

## Technologies
---
### Selenium:
> https://www.selenium.dev/selenium/docs/api/py/api.html#
### BeautifulSoup:
> https://www.crummy.com/software/BeautifulSoup/bs4/doc/

<br/>

## Data Files
---
File | Source | Description 
--- | --- | --- 
2017_AVG_EPEST_HIGH.csv | NA | Base file from before I started my work (I am not the author)
Top_Pesticide_Use_Annual.csv | NA | Base file from before I started my work (I am not the author) 
whoClassifiedData.csv | PubChem | Dataframe using categorizedNoGram.csv as a base. Contains a new column containing the WHO hazard class for each observation
2017_AVG_EPEST_HIGH_PLUS.csv | PubChem | Modified version of the 2017_AVG_EPEST_HIGH.csv base file. This file contains all the observations in the NoGram.csv file except missing ~40 observations from subsetting before unit conversions useful to retain since this dataframe contains the CAS numbers from each compound
NoGram.csv | PubChem | Intermediate dataframe containing observations with g/kg and mg/kg that were unified into mg/kg observations to simplify the dose data column
categorizedNoGram.csv | PubChem | Intermediate dataframe using the NoGram.csv as a base to create a new column categorizing observations as aquatic vs. terresrial
RawAggregatedToxicologyData.csv | PubChem | Unmodified raw dataframe
aggregateAquaticIntermediate.csv | EcoTox | Modified dataframe with observations extracted from EcoTox using CAS numbers from 2017_AVG_EPEST_HIGH_PLUS.csv
mg_per_L_aquaticDataframe.csv | EcoTox | Dataframe with observations subsetted from aggregateAquaticIntermediate.csv that only have units of AI mg/L or mg/L 
