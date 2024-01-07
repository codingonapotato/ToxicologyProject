# Toxicology Project

## 🌱 What is the Toxicology Project?
---

The Toxicology Project is part of my contribution to the research at UBC's Wildlife and Conservation Economics Laboratory. The mission at the lab is to quantify the impact of government policies on conservation produce data that informs policy againsts threats to biodiversity and more! My work was to support my supervisor's research on the impact on GMO crop adoption and pesticide usage. My contributions to this research topic include:

<ul>
<li> Web scraping automation </li>
<li> Data visualization </li>
<li> Data cleaning </li>
<li> Data entry </li>
<li> Analyzing research papers </li>
</ul>

<br/>

## 📃 List of Sources used
---
###  PubChem:
> https://pubchem.ncbi.nlm.nih.gov/
### EcoToX:
> https://cfpub.epa.gov/ecotox/

<br/>

## 💻 Technologies
---
### Languages/Frameworks: Python & R

### Libraries: Selenium, BeautifulSoup, Numpy, Tidyverse

### Additional tools: Excel 

<br/>

## 📁 Data Files
---
File | Source | Description 
--- | --- | --- 
2017_AVG_EPEST_HIGH.csv | NA | Raw data
Top_Pesticide_Use_Annual.csv | NA | Raw data  
whoClassifiedData.csv | PubChem | Dataframe using categorizedNoGram.csv as a base. Contains a new column containing the WHO hazard class for each observation
2017_AVG_EPEST_HIGH_PLUS.csv | PubChem | Modified version of the 2017_AVG_EPEST_HIGH.csv base file. This file contains all the observations in the NoGram.csv file except missing ~40 observations from subsetting before unit conversions useful to retain since this dataframe contains the CAS numbers from each compound
NoGram.csv | PubChem | Intermediate dataframe containing observations with g/kg and mg/kg that were unified into mg/kg observations to simplify the dose data column
categorizedNoGram.csv | PubChem | Intermediate dataframe using the NoGram.csv as a base to create a new column categorizing observations as aquatic vs. terresrial
RawAggregatedToxicologyData.csv | PubChem | Unmodified raw dataframe
aggregateAquaticIntermediate.csv | EcoTox | Modified dataframe with observations extracted from EcoTox using CAS numbers from 2017_AVG_EPEST_HIGH_PLUS.csv
mg_per_L_aquaticDataframe.csv | EcoTox | Dataframe with observations subsetted from aggregateAquaticIntermediate.csv that only have units of AI mg/L or mg/L 
---
