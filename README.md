# Exploratory-Data-Analyses

### 1. NYPD Accident Data - Google BigQuery

This is my first self-paced exploratory data analysis.

This analysis was started by finding the NYPD car accident dataset on Google BigQuery. 
This dataset contained variables describing a single accident report, such as *vehicle 
types involved, timestamp, location*, and more.

Using the **google.cloud** Python library, I was able to import a subsection of this dataset 
using a simple SQL Query that extracted 2000 random rows, each one corresponding to a single 
accident report. I performed data cleaning using the **Pandas** library, and performed data 
visualizations with **matplotlib** and **seaborn**. Some basic web-scraping was performed 
using the **BeautifulSoup** and **Requests** libraries to import New York population data from
Wikipedia. Some basic statistical tools such as Chi-squared tests and simple/multiple linear 
regression were performed using the **statsmodels** library.

**The findings are summarized below :**

To summarize our findings, we determined that:

- The most common contributing factor to car accidents in New York is distracted or inattentive driving
- Accidents do not seem to occur at equal rates throughout the year
- Brooklyn had the most accidents compared to other boroughs, but relative to population, 
Manhattan has the most accidents, likely due to increased population density.
- Since car accidents are so unlikely to be fatal, it is impossible to determine which contributing 
factors or car types produce the most fatal accidents. At least, using this small random sample.
- The number of car accidents was steadily increasing year over year until about 2017-2019. In 
2020, there was a sharp decline in accidents, likely due to reduced driving caused by the COVID-19 
pandemic lockdowns. Since then, car accidents have increased again.

**How to improve this analysis**

This report was completed using a random sample of 2000 accidents from a New York Police Department 
database. Thus, it is difficult to get practical information on the frequency of different factors 
on accidents. Additionally, there are many issues with how some of the data was collected (for 
example, the variety of different values used for contributing vehicle types that mean the same thing)
that makes it difficult to make useful inferences.
