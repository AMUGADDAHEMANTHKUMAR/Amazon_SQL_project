# Amazon Movies and TV Shows Data Analysis using SQL

![Amazon Prime Logo](https://upload.wikimedia.org/wikipedia/commons/f/f1/Prime_Video.png)

## Overview

This project involves a comprehensive analysis of Amazon Prime’s movies and TV shows data using SQL. The goal is to extract valuable insights and answer various business questions based on the dataset. The following README provides a detailed account of the project's objectives, business problems, solutions, findings, and conclusions.

## Objectives

- Analyze the distribution of content types (movies vs TV shows).
- Identify the most common ratings for movies and TV shows.
- List and analyze content based on release years, countries, and durations.
- Explore and categorize content based on specific criteria and keywords.

## Dataset

Include details about the dataset used, such as:
- `amazon_prime_titles.csv` file *(update this with the actual file name if different)*
- Source of the data (e.g., Kaggle or any public repository)

## 📊 Business Problems & SQL Solutions

Below are 15 business questions addressed using SQL on the Amazon Prime Movies and TV Shows dataset.

---

### 1. 📌 Count the number of Movies vs TV Shows

```sql
SELECT 
    type,
    COUNT(*) AS total_content
FROM amazon
GROUP BY type;
```

### 2. 📌 Find the most common rating for movies and TV shows

```sql
SELECT DISTINCT type, rating
FROM (
    SELECT 
        type,
        rating,
        COUNT(*),
        RANK() OVER(PARTITION BY type ORDER BY COUNT(*) DESC) AS ranking
    FROM amazon
    GROUP BY 1, 2
) AS t1
WHERE ranking = 1;
```

3. 📌 List all "Movies" released in 2018

```sql

SELECT * 
FROM amazon 
WHERE type = 'Movie'
  AND release_year = 2018;
```

4. 📌 Top 5 countries with the most content on Amazon

```sql

SELECT 
    UNNEST(STRING_TO_ARRAY(country, ',')) AS new_country,
    COUNT(*) AS total_content 
FROM amazon
GROUP BY country
ORDER BY COUNT(*) DESC
LIMIT 5;
```

5. 📌 Identify the longest movie or TV show duration

```sql

SELECT * 
FROM amazon
WHERE type = 'Movie'
  AND duration = (SELECT MAX(duration) FROM amazon);
```

6. 📌 Find content added in the last 5 years

```sql

SELECT * 
FROM amazon 
WHERE TO_DATE(date_added, 'Month,dd,yyyy') >= CURRENT_DATE - INTERVAL '5 years';
```

7. 📌 Find all the content by director "Mark"

```sql

SELECT * 
FROM amazon 
WHERE director ILIKE '%Mark%';
```

8. 📌 List all TV shows with more than 2 seasons

```sql

SELECT * 
FROM amazon 
WHERE type = 'TV Show' 
  AND SPLIT_PART(duration, ' ', 1)::INT >= 2;
```

9. 📌 Count of content items in each genre

```sql

SELECT 
    UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre,
    COUNT(*)
FROM amazon
GROUP BY 1;
```

10. 📌 Top 5 years with highest average content released by India

```sql

SELECT 
    EXTRACT(YEAR FROM TO_DATE(date_added, 'Month,dd,yyyy')) AS year,
    COUNT(*) AS yearly_content,
    ROUND(
        COUNT(*)::INT / (SELECT COUNT(*) FROM amazon WHERE country = 'India')::INT * 100, 2
    ) AS avg_release_per_year
FROM amazon
WHERE country = 'India'
GROUP BY 1;
```

11. 📌 List two movies that are Documentaries

```sql

SELECT * 
FROM amazon 
WHERE listed_in ILIKE '%Documentary%'
LIMIT 2;
```

12. 📌 Find all content without a director

```sql

SELECT * 
FROM amazon 
WHERE director IS NULL;
```

13. 📌 Movies where Salman Khan appeared in the last 10 years

```sql

SELECT * 
FROM amazon
WHERE casts ILIKE '%Salman%' 
  AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;
```

14. 📌 Top 10 actors in Indian-produced movies

```sql

SELECT 
    UNNEST(STRING_TO_ARRAY(casts, ',')) AS actors,
    COUNT(*) AS total_content
FROM amazon
WHERE casts ILIKE '%ind%'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;
```
15. 📌 Categorize content as "Good" or "Bad" based on keywords

```sql

WITH new_table AS (
    SELECT *,
        CASE
            WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad_Content'
            ELSE 'Good_Content'
        END AS category
    FROM amazon
)
SELECT category, COUNT(*) AS total_content
FROM new_table
GROUP BY 1;
```

## 📌 Findings and Conclusion

<!-- Introduction for fresher-level context -->
As someone who recently started learning SQL and data analysis, I took on the task of exploring Amazon Prime's movie and TV show dataset to apply my skills in a practical way. Here are the key insights I discovered:

<!-- Content distribution summary -->
**Content Distribution**: The platform offers a wide variety of movies and TV shows. This helped me understand how content is distributed across different types and categories.

<!-- Rating pattern insight -->
**Common Ratings**: I found the most frequent content ratings, which gave me an idea about the general audience Amazon Prime targets.

<!-- Geographical trends from the data -->
**Geographical Insights**: By analyzing content by country, especially India, I learned how regional trends impact content availability and production.

<!-- Classification logic using keywords -->
**Content Categorization**: Using keywords like "kill" and "violence," I practiced classifying content into categories like "Good" or "Bad," which helped me understand basic sentiment-style analysis.












