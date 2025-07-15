create database netflix

--View Data
select * from netflix1

--checking duplicates in show_id
select show_id,count(*) as duplicate_count
from netflix1
group by show_id
having count(*) > 1

-- Observation: No duplicates found in show_id. It contains all unique values.

--Checking missing values
select * from netflix1
where show_id is null
or
type is null
or
title is null
or
director is null
or
country is null
or
date_added is null
or
release_year is null
or
rating is null
or
duration is null
or
listed_in is null

--There are no missing values in the data.

--QUESTIONS

--Q1. What is the proportion of Movies vs TV Shows?
select type,count(*) as content_count
from netflix1
group by type 

--Q2. How has the number of releases changed over the years?

select release_year, count(*) as total_count
from netflix1
group by release_year
order by release_year

--Q3. Which countries produce the most content on netflix?

select top 10 country,count(*) as total_count
from netflix1
group by country
order by total_count desc

--Q4. What are the most popular genres?
select top 10 listed_in,count(*) as total_count
from netflix1
group by listed_in
order by total_count desc

--Q5. What’s the average duration of Movies vs TV Shows?
select type, avg(cast(left(duration, charindex(' ',duration) - 1) as int)) as avg_duration,
case 
 when type = 'Movie' then 'minutes'
 when type = 'TV Show' then 'season'
 end as unit
from netflix1
where duration like '%min%' or duration like '%Season%' or duration like '%Seasons%'
group by type

--Q6. How many titles are in each rating category?
select rating, count(title) as title_count
from netflix1
group by rating
order by title_count desc

--Q7. Who are the most frequently featured directors?
with cleaned_netflix as
(
  select * from netflix1
  where director is not null and director != 'Not Given'
)
select top 10 director,count(*) as featured_count
from cleaned_netflix
group by director
order by featured_count desc

-- CTE created to filter out not_given(missing values) values and avoid changes in raw data.

--Q8. What months have the highest content additions?
select month(date_added) as month_num, count(*) as content_added
from netflix1
group by month(date_added)
order by content_added desc

--Q9. What genres are most commonly combined?
select listed_in as genres_combinations, count(*) as frequency
from netflix1
where listed_in is not null
group by listed_in
order by frequency desc

--Q10.  What type of content is most commonly produced in India for kids?
select type,count(*) as total_count
from netflix1
where country = 'India' and listed_in like '%children%' or listed_in like '%kids%'
group by type

