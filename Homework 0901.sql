-- Part 2-a
-- Create an index on user_id in the Tweet table 
-- ==========================================================================================================
CREATE INDEX user_id_index ON Tweet(user_id);


-- Part 2-b
-- Create a composite index on (friends_count, screen_name) in the User table 
-- ==========================================================================================================
CREATE INDEX friends_count_and_screen_name_index ON User(friends_count, screen_name);


-- Part 2-c
-- Create a materialized view that answers the query in Part-1-a
-- ==========================================================================================================
CREATE TABLE materialized_view_tweet_id_str AS
  SELECT *
    FROM Tweet 
    WHERE id_str LIKE '%78%' OR
          id_str LIKE '%8%' OR
          id_str LIKE '%8791%';
