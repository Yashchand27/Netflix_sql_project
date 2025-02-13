	drop table netflix;
	Create table netflix
		(
			show_id        Varchar(6),
			type		   Varchar(10),
			title			Varchar(150),
			director		Varchar(208),
			casts			Varchar(1000),
			country			Varchar(150),
			date_added		Varchar(50),
			release_year	INT,
			rating			Varchar(10),
			duration		Varchar(15),
			listed_in		Varchar(100),
			description		Varchar(250)
		);
		
	select * from netflix;


-- 1. Count the number of movies vs TV shows

	select
		Sum(case when type = 'Movie' then 1 End) as No_of_movie,
		Sum(case when type = 'TV Show' then 1 End) as No_of_Tv_Show
	from
		netflix;
		
	select
		type,
		count(*)
	from
		netflix
	group by
		1;


-- 2. Find the most common rating for movies and TV shows

	select
		rating,
		Sum(case when type = 'Movie' then 1 End) as Movie,
		Sum(case when type = 'TV Show' then 1 End) as TV_Show
	from
		netflix
	group by
		1
	order by
		2 desc
	limit 
		1


-- 3. List all movies released in a specific year (e.g. 2020)

	select
		*
	from
		netflix
	where
		type = 'Movie'
		And
		release_year = 2020
		
	Select
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


-- 4. Find the top 5 countries with the most content on netflix

	select
		trim(Unnest(string_to_array(country, ','))) as new_country,
		count(*)
	from
		netflix
	group by
		1
	order by
		2 desc
	limit 
		5


-- 5. Find the content which added in the last 5 years

	select
		*
	from
		netflix
	where
		TO_DATE(date_added, 'Month DD, YYYY') >= current_date - Interval '5 years'


-- 6. Find all the movie/Tv shows by director 'Rajiv Chilaka'

	select
		type,
		title,
		director
	from 
		netflix
	where
		director Ilike '%Rajiv Chilaka%'


-- 7. List all Tv Shows with more than 5 seasons

	select
		*
	from
		netflix
	where
		type Ilike '%tv Show%'
		And
		split_part(duration, ' ', 1):: numeric > 5


-- 8. Count the number of content items in each genre

	select
		trim(unnest(string_to_array(listed_in, ','))) as genre,
		count(show_id) as content_count
	from 
		netflix
	group by
		1
	order by
		2 desc


-- 9. What is the monthly percentage distribution of movie releases in India on Netflix over the past five years?

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


-- 10. List all movies that are Documentaries

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
	

-- 11. Find how many movies/Tv shows actor 'salman khan' appeared in last 10 years!

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
	group by
		1,2


-- 12. Find the top 10 actors who have appeared in the highest number of movies produced in India.

	select
		trim(unnest(string_to_array(casts, ','))) AS Actors,
		count(show_id) as No_of_movies
	from
		netflix
	where
		country = 'India'
	group by
		1
	order by
		2 Desc
	limit 10