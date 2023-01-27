--I started doing some data cleaning on SQL, by eliminating the columns that were not being used in the analysis:

SELECT *
FROM listings

ALTER TABLE listings
  DROP column name, last_review, reviews_per_month, license
  
  
  --Grouping by price per neighbourhood_group:
  SELECT DISTINCT neighbourhood_group_cleansed AS neighbourhood_group, ROUND (AVG (price),2) AS avg_price
  FROM listings
GROUP BY neighbourhood_group_cleansed
  
  
  --Grouping by neighbourhoods and price
  SELECT DISTINCT neighbourhood_cleansed as neighbourhood, neighbourhood_group_cleansed as neighbourhood_group, 
AVG (price) OVER (PARTITION BY neighbourhood_cleansed) AS avg_price
  FROM listings
  ORDER BY avg_price DESC;
  
  
  -- Counting number of airbnb per neighbouhood
  
 SELECT DISTINCT neighbourhood_cleansed as neighbourhood, neighbourhood_group_cleansed as neighbourhood_group, COUNT (id) as number_of_airbnb
FROM listings
GROUP BY neighbourhood_cleansed, neighbourhood_group_cleansed
ORDER BY number_of_airbnb
  
  --Selecting top 10 airbnb with highest price, along-with number of airbnb available (This analysis is taking even cases where very few airbnb are available, and price is therefore high)
  SELECT DISTINCT TOP 10 neighbourhood_cleansed as neighbourhood, neighbourhood_group_cleansed as neigbourhood_group, 
AVG (price) OVER (PARTITION BY neighbourhood_cleansed) AS avg_price, COUNT (id) OVER (PARTITION BY neighbourhood_cleansed) AS number_of_airbnb
  FROM listings
  GROUP BY price, neighbourhood_cleansed, neighbourhood_group_cleansed, id
  ORDER BY avg_price DESC, number_of_airbnb


  -- Selecting top 5 neighbourhood with highest price, along with number of airbnb available where num_of_airbnb>10
SELECT DISTINCT TOP 5 neighbourhood_cleansed as neighbourhood, neighbourhood_group_cleansed as neigbourhood_group, 
AVG (price) OVER (PARTITION BY neighbourhood_cleansed) AS avg_price, COUNT (id) OVER (PARTITION BY neighbourhood_cleansed) AS number_of_airbnb
  FROM listings
  GROUP BY price, neighbourhood_cleansed, neighbourhood_group_cleansed, id
  HAVING neighbourhood_cleansed <> 'Fort Wadsworth'
  AND neighbourhood_cleansed <>'Navy Yard'
  AND neighbourhood_cleansed <>'Prospect Park'
  AND neighbourhood_cleansed <> 'Hollis Hills'
  AND neighbourhood_cleansed <> 'Belle Harbor'
  ORDER BY avg_price DESC, number_of_airbnb


-- Number of Room Types available:

SELECT room_type, COUNT (room_type) AS number_of_airbnb
  FROM listings
  GROUP BY room_type
  ORDER BY room_type DESC
  
  
  -- Average price and number of airbnb available per room type:
  
  SELECT DISTINCT room_type, 
AVG (price) OVER (PARTITION BY room_type) AS avg_price, COUNT (id) OVER (PARTITION BY room_type) AS number_of_airbnb
  FROM listings
  GROUP BY price, room_type, id
  ORDER BY avg_price DESC, number_of_airbnb
  
  
  -- Average price per room type in each neighbourhood group:
  
  SELECT DISTINCT neighbourhood_group_cleansed as neighbourhood_group, room_type, AVG (price) AS avg_price
FROM listings
GROUP BY room_type, neighbourhood_group_cleansed
ORDER BY neighbourhood_group_cleansed, room_type

--Number of reviews and average review ratings
SELECT neighbourhood_group_cleansed, SUM(number_of_reviews) as total_reviews, ROUND (AVG (price),2) as avg_price 
FROM listings
GROUP BY neighbourhood_group_cleansed
ORDER BY total_reviews DESC;


-- Availability throughout the year:

SELECT DISTINCT neighbourhood_group_cleansed as neighbourhood_group, ROUND (AVG (availability_365),0) AS availability
  FROM listings
  GROUP BY neighbourhood_group_cleansed