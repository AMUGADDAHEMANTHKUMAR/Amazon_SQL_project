-- amazon Prime 
Drop table if exists amazon;
create table amazon 
(
show_id	Varchar(100),
type	Varchar(100),
title	Varchar(300),
director Varchar(250),
casts	Varchar(1000),
country	Varchar(160),
date_added	Varchar(100),
release_year int,
rating	Varchar(100),
duration Varchar(100),
listed_in	Varchar(130),
description Varchar(300)
);


CREATE TABLE amazon (
  show_id VARCHAR(20),
  type VARCHAR(20),
  title TEXT,
  director TEXT,
  casts TEXT,
  country TEXT,
  date_added TEXT,
  release_year INT,
  rating VARCHAR(20),
  duration VARCHAR(30),
  listed_in TEXT,
  description TEXT
);

select * from amazon;


select 
  count(*) as total_content
from amazon;


select 
  distinct type
from amazon;

-- 15 Business Problems & Solutions

-- 1.Count the number of Movies vs TV Shows.

select 
type,
count(*)total_content
from amazon
group by type;

-- 2.Find the most common rating for movies and TV shows

select distinct type,rating
from
(select type,rating,count (*),
rank() over( partition by type order by count(*) desc)as ranking
from amazon
group by 1,2)as t1
where ranking = 1;


-- 3.List all "movies" released in a specific year (e.g., 2020)

select * from amazon 
where 
type = 'Movie'
and
release_year = 2018;


-- 4.Find the top 5 countries with the most content on Netflix.

select unnest(string_to_array(country,','))as new_country,
count(*)as total_content from amazon
group by country
order by count(*) Desc
limit 5 ;

-- 5.Identify the longest movie or TV show duration

select * from amazon
where
  type = 'Movie'
  and 
  duration = (select max(duration) from amazon);


-- 6.Find content added in the last 5 years
select *
from amazon 
where 
to_date(date_added, 'Month,dd,yyyy') >= current_date - interval '5 years';

-- 7.Find all the movies/TV shows by director 'Rajiv Chilaka'

select * 
from amazon 
where director like '%Mark%';


-- 8.list all tv Shows more than five seasons 
select * from amazon 
where type = 'TV Show' 
and 
split_part(duration,' ',1)::int >= 2

-- 9. Count the number of content items in each gener?

select 
unnest (string_to_array(amazon.listed_in,',')) as gener,
count(*)
from amazon
group by 1;

-- 10. Find easier and average number of content released by India on Amazon return top five years With highest average content release !
select 
    extract(Year from to_date(date_added,'Month,dd,yyyy'))as Year,
	count(*) as Yearly_content,
	round(
	count(*) :: int/(select count (*) from amazon where country = 'India') :: int * 100,2)
	as Avg_release_per_year
	from amazon
	where country = 'India'
	group by 1;
	


-- 11. List two movies that are Documentary
select * from amazon where listed_in like '%Documentary%';


-- 12.find all the content with out director
select * from amazon where Director is null;


-- 13. Find how many movies actor Salman Khan appeared in last 10 years
select * from amazon
where casts Ilike '%Salman%' 
and
release_year > extract (Year from current_date) - 10;

-- 14. Find the top 10 actors who are have appeared in the highest number of movies produced in India
select 
   unnest(string_to_array(casts,',')) as actors,
   count (*) as total_content
   from amazon
   where casts ilike '%ind%'
   group by 1
   order by 2 desc
   limit 10;

-- 15. Categorize the content based on the presence of the keywords 'kill' and 'violence' in the description field.
-- Label content containing these keywords as 'Bad' and all other content as 'Good'.
-- Count how many items fall into each category.

with new_table
as
(
select *,
case
when description ilike 'Kill%' 
or
description ilike '%violence%'
then 'Bad_Content'
else 'Good_Content'
end Category
from amazon
)
select Category,count(*)As total_Content
from new_table
group by 1;

commit;







