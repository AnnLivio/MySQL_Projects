# Netflix Movies & Shows

### **Dataset** [netflix-movies-and-tv-shows](https://www.kaggle.com/datasets/rahulvyasm/netflix-movies-and-tv-shows/data)

---

This dataset contains comprehensive information about movies and TV shows available on Netflix. The columns in your dataset are as follows:
+ **show_id**: A unique identifier for each title
+ **type**: The category of the title
+ **title**: The name of the movie or TV show
+ **director**: The director(s) of the movie or TV show
+ **cast**: The list of main actors or actresses in the title
+ **country**: The countries where the movie or show was produced
+ **date_added**: The date the title was added to Netflix
+ **release_year**: The year the movie or TV show was released
+ **rating**: The age rating of the title
+ **duration**: The duration of the title
+ **listed_in**: The genres the title falls under
+ **description**: A brief summary of the title

---

## Questions
1. How many movies and TV shows are there in the dataset? Display the count for each type.
2. What percentage of content doesn't have a country associated with it?
3. Find the top 3 directors with the most content on Netflix. Display the director's name, the count of their titles, and the year of their most recent content.
4. For each year from 2015 to 2021, calculate the percentage of movies vs TV shows added to Netflix
5. Calculate the average month-over-month growth rate of content added to Netflix for each genre. What are the top 5 fastest growing genres?

## Data cleanning with DUCKDB
**Check** `netflix_duckdb.sql`
