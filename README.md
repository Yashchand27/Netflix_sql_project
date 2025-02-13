# Netflix Movies and TV Shows Data Analysis using SQL

![Netflix Logo](https://github.com/Yashchand27/Netflix_sql_project/blob/main/logo.png)

## Overview
This project conducts an in-depth analysis of Netflix's movies and TV shows dataset using SQL. The primary objective is to derive meaningful insights and address key business questions based on the data. This README outlines the project's goals, business challenges, proposed solutions, key findings, and conclusions.

## Objectives
- Analyze the distribution of content types (movies vs TV shows).
- Identify the most common ratings for movies and TV shows.
- List and analyze content based on release years, countries, and durations.
- Explore and categorize content based on specific criteria and keywords.

## Dataset
The data for this project is sourced from the Kaggle dataset:

**Dataset Link:** [Movies Dataset](https://www.kaggle.com/datasets)

## Schema
```sql
DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
    show_id      VARCHAR(5),
    type         VARCHAR(10),
    title        VARCHAR(250),
    director     VARCHAR(550),
    casts        VARCHAR(1050),
    country      VARCHAR(550),
    date_added   VARCHAR(55),
    release_year INT,
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(250),
    description  VARCHAR(550)
);
```

## Business Problems and Solutions

### 1. Count the Number of Movies vs TV Shows
```sql
 i)  select
       Sum(case when type = 'Movie' then 1 End) as No_of_movie,
       Sum(case when type = 'TV Show' then 1 End) as No_of_Tv_Show
     from
       netflix;
		
ii)  select
       type,
       count(*)
     from
       netflix
     group by
        1;
```
**Objective:** Determine the distribution of content types on Netflix.

### 2. Find the Most Common Rating for Movies and TV Shows
```sql
select
  rating,
  Sum(case when type = 'Movie' then 1 End) as Movie,
  Sum(case when type = 'TV Show' then 1 End) as TV_Show
from
  netflix
group by 1
order by 2 desc
limit 1 
```
**Objective:** Identify the most frequently occurring rating for each type of content.

### 3. List All Movies Released in a Specific Year (e.g., 2020)
```sql
i) select
      *
   from
      netflix
   where
      type = 'Movie'
      And
      release_year = 2020
		
ii) select
      release_year,
      title,
      Row_number() over(partition by release_year order by release_year desc) as rn
    from
      netflix
    where
      type = 'Movie'
    group by
       1,2
    order by
       release_year desc
```
**Objective:** Retrieve all movies released in a specific year.

### 4. Find the Top 5 Countries with the Most Content on Netflix
```sql
select
  trim(Unnest(string_to_array(country, ','))) as new_country,
  count(*)
from
  netflix
group by 1
order by 2 desc
limit 5
```
**Objective:** Identify the top 5 countries with the highest number of content items.

### 5. Find Content Added in the Last 5 Years
```sql
select
  *
from
  netflix
where
  TO_DATE(date_added, 'Month DD, YYYY') >= current_date - Interval '5 years'
```
**Objective:** Retrieve content added to Netflix in the last 5 years.

### 6. Find All Movies/TV Shows by Director 'Rajiv Chilaka'
```sql
select
  type,
  title,
  director
from 
  netflix
where
  director Ilike '%Rajiv Chilaka%'
```
**Objective:** List all content directed by 'Rajiv Chilaka'.

### 7. List All TV Shows with More Than 5 Seasons
```sql
select
  *
from
  netflix
where
  type Ilike '%tv Show%'
  And
  split_part(duration, ' ', 1):: numeric > 5
```
**Objective:** Identify TV shows with more than 5 seasons.

### 8. Count the Number of Content Items in Each Genre
```sql
select
  trim(unnest(string_to_array(listed_in, ','))) as genre,
  count(show_id) as content_count
from 
  netflix
group by 1
order by 2 desc
```
**Objective:** Count the number of content items in each genre.

### 9. What is the monthly percentage distribution of movie releases in India on Netflix over the past five years?
```sql
select
  Extract(month from To_date(date_added, 'Month DD, YYYY')) as Months,
  TO_CHAR(TO_DATE(date_added, 'Month DD, YYYY'), 'Mon') AS month_name,
  round(100*
  count(show_id)::numeric / (select count(*) from netflix where date_added is not null and country = 'India'
  and TO_DATE(date_added, 'Month DD, YYYY') <= CURRENT_DATE - INTERVAL '5 years')::numeric,2) as percentage
from
  netflix
where
  date_added is not Null
  and country = 'India'
  and TO_DATE(date_added, 'Month DD, YYYY') <= CURRENT_DATE - INTERVAL '5 years'
group by
  1,2
order by
  1
```
**Objective:** Calculate monthly percentage distribution of movie releases in India on Netflix.

### 10. List All Movies that are Documentaries
```sql
with cte as(
select
  show_id,
  type,
  title,
  trim(unnest(string_to_array(listed_in, ','))) as Genre
from
  netflix
where
  type = 'Movie'
)
select
  *
from
  cte
where
  Genre = 'Documentaries' 
```
**Objective:** Retrieve all movies classified as documentaries.

### 11. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years
```sql
select
  type,
  title,
  count(show_id) as No_of_movies
from
  netflix
where
  casts Ilike '%salman khan%'
  and
  release_year > extract(Year from current_date) - 10
group by 1,2
```
**Objective:** Count the number of movies featuring 'Salman Khan' in the last 10 years.

### 12. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India
```sql
select
  trim(unnest(string_to_array(casts, ','))) AS Actors,
  count(show_id) as No_of_movies
from
  netflix
where
  country = 'India'
group by 1
order by 2 Desc
limit 10
```
**Objective:** Identify the top 10 actors with the most appearances in Indian-produced movies.

## Findings and Conclusion
- **Content Distribution:** The dataset includes a wide variety of movies and TV shows, covering different genres and ratings.
- **Common Ratings:** Understanding the most frequently assigned ratings helps identify the target audience for the content.
- **Geographical Insights:** The prominence of content from leading countries, especially India, highlights regional distribution patterns.
- **Content Categorization:**  Organizing content based on key terms provides a clearer picture of the types of content available on Netflix.

This analysis provides a comprehensive view of Netflix's content and can help inform content strategy and decision-making.
