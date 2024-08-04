/* NOTES: This is a homework assignment for the second course in my Database Design & SQL certificate, using MSSQL and SalesDB. My codes all ran properly and I recieved an A on the assignment. */


GO
PRINT 'CIS 275, Lab Week 3, Question 1  [3pts possible]:
What is on TV?
---------------
This is an exact repeat of Question 7 from Lab Week 2. However, instead of using the all_data 
view, instead JOIN the CHANNEL, SHOW, and SCHEDULE tables together. Consult the ERD (if needed)
to determine which columns to match in the ON parts of the JOINs.

Show the first 100 TV shows that start on 9/10/2017 at 8:00PM (StartTime is 20:00:00).' + CHAR(10)

GO

USE TV;

SELECT		TOP 100 CONVERT(CHAR(10),DisplayName) AS 'Channel Name',
			ChannelNumber AS 'Channel Number',
			CONVERT(VARCHAR(8), StartTime ,108) AS 'Start Time',
			CONVERT(VARCHAR(8), EndTime ,108) AS 'End Time',
			CONVERT(CHAR(30),Title) AS 'Title'
FROM		CHANNEL
JOIN		SCHEDULE ON ChannelID = FK_ChannelID
JOIN		SHOW ON ShowID = FK_ShowID
WHERE		StartTime = '9-10-2017 20:00:00'
ORDER BY	ChannelNumber;


GO
PRINT 'CIS 275, Lab Week 3, Question 2  [3pts possible]:
HD Channels
-----------
Find channels in the CHANNEL table where there is a matching HD channel. For this problem,
only retrieve channels where the DisplayName of the standard definition channel matches the
DisplayName of the HD channel with an HD added to the end (ignore the case where, for example,
SYFYP matches SYFYHDP).' + CHAR(10)

GO

SELECT		C1.ChannelNumber AS 'Standard Channel',
			CONVERT(CHAR(10),C1.DisplayName) AS 'Standard Name',
			C2.ChannelNumber AS 'HD Channel',
			CONVERT(CHAR(10),C2.DisplayName) AS 'HD Name'
FROM		CHANNEL AS C1
JOIN		CHANNEL AS C2 ON C1.ChannelNumber <> C2.ChannelNumber
WHERE		C2.DisplayName LIKE C1.DisplayName + 'HD'
ORDER BY	'Standard Name';

GO
PRINT 'CIS 275, Lab Week 3, Question 3  [3pts possible]:
HD Channels Part 2
------------------
Repeat the previous query, except this time use a CROSS JOIN. Add a WHERE
clause that matches display names that end in P with display names that end in
HDP.' + CHAR(10)

GO

SELECT		C1.ChannelNumber AS 'Standard Channel',
			CONVERT(CHAR(10),C1.DisplayName) AS 'Standard Name',
			C2.ChannelNumber AS 'HD Channel',
			CONVERT(CHAR(10),C2.DisplayName) AS 'HD Name'
FROM		CHANNEL AS C1
CROSS JOIN	CHANNEL AS C2
WHERE		RIGHT(C1.DisplayName,1) = 'P'
			AND RIGHT(C2.DisplayName,3) = 'HDP'
			AND LEFT(C1.DisplayName, LEN(C1.DisplayName) - 1) = LEFT(C2.DisplayName, LEN(C2.DisplayName) - 3)
ORDER BY	'Standard Name';


GO
PRINT 'CIS 275, Lab Week 3, Question 4  [3pts possible]:
HD Channels Part 3
------------------
Use UNION to merge the results from Question 2 and Question 3 into a single set of results. Be
sure that your final results are ordered by display name.' + CHAR(10)

GO

SELECT		C1.ChannelNumber AS 'Standard Channel',
			CONVERT(CHAR(10),C1.DisplayName) AS 'Standard Name',
			C2.ChannelNumber AS 'HD Channel',
			CONVERT(CHAR(10),C2.DisplayName) AS 'HD Name'
FROM		CHANNEL AS C1
JOIN		CHANNEL AS C2 ON C1.ChannelNumber <> C2.ChannelNumber
WHERE		C2.DisplayName LIKE C1.DisplayName + 'HD'
UNION
SELECT		C1.ChannelNumber AS 'Standard Channel',
			CONVERT(CHAR(10),C1.DisplayName) AS 'Standard Name',
			C2.ChannelNumber AS 'HD Channel',
			CONVERT(CHAR(10),C2.DisplayName) AS 'HD Name'
FROM		CHANNEL AS C1
CROSS JOIN	CHANNEL AS C2
WHERE		RIGHT(C1.DisplayName,1) = 'P'
			AND RIGHT(C2.DisplayName,3) = 'HDP'
			AND LEFT(C1.DisplayName, LEN(C1.DisplayName) - 1) = LEFT(C2.DisplayName, LEN(C2.DisplayName) - 3)
ORDER BY	'Standard Name';


GO


GO
PRINT 'CIS 275, Lab Week 3, Question 5  [3pts possible]:
Too late!
---------
Find TV episodes in the SHOW table that aren''t currently scheduled. Include only results that have
an episode name and a description. Use DISTINCT.' + CHAR(10)

GO

SELECT		DISTINCT CONVERT(CHAR(20),Title) AS 'Title',
			CONVERT(CHAR(20),EpisodeName) AS 'Episode',
			CONVERT(CHAR(50),Description) AS 'Description'
FROM		SHOW
LEFT OUTER JOIN SCHEDULE ON ShowID = FK_ShowID
WHERE		ScheduleID IS NULL
AND 		EpisodeName IS NOT NULL
AND 		Description IS NOT NULL
ORDER BY	Title;


GO


GO
PRINT 'CIS 275, Lab Week 3, Question 6  [3pts possible]:
Eraserhead
----------
Switch to IMDB database.
Show all principals listed for the movie "Eraserhead." For each principal, show the name of the movie,
the category, and the name of the principal. Also include the characters that actors and actresses
played (display N/A for NULL values). Format all columns to 20 characters wide.' + CHAR(10)

GO

USE IMDB

SELECT		CONVERT(CHAR(20),primaryTitle) AS 'Title',
			CONVERT(CHAR(20),category) AS 'Category',
			CONVERT(CHAR(20),primaryName) AS 'Name',
			CONVERT(CHAR(20),ISNULL(characters, 'N/A')) AS 'Characters'
FROM		title_principals
JOIN 		title_basics ON title_principals.tconst = title_basics.tconst
JOIN		 name_basics ON title_principals.nconst = name_basics.nconst
WHERE		primaryTitle = 'Eraserhead'
AND 		titleType = 'movie'
ORDER BY	primaryName;


GO


GO
PRINT 'CIS 275, Lab Week 3, Question 7  [3pts possible]:
Quentin Tarantino
-----------------
What genres has Quentin Tarantino directed? Produce the title, type, year and genre
for shows where Quentin Tarantino was the director. Format Title as 30 characters wide
and genre as 20 characters wide. Order by Year.' + CHAR(10)

GO

SELECT		CONVERT(CHAR(30),primaryTitle) AS 'Title',
			titleType AS 'Type',
			startYear AS 'Year',
			CONVERT(CHAR(20),genre) AS 'Genre'
FROM		title_basics
JOIN 		title_directors ON title_basics.tconst = title_directors.tconst
JOIN 		title_genre ON title_basics.tconst = title_genre.tconst
JOIN 		name_basics ON title_directors.nconst = name_basics.nconst
WHERE		primaryName = 'Quentin Tarantino'
ORDER BY	startYear;
GO


GO
PRINT 'CIS 275, Lab Week 3, Question 8  [3pts possible]:
Quentin Tarantino''s popular movies
-----------------------------------
Produce a list of all of Quentin Tarantino''s movies in descending order by rating. Format title as 30 characters
wide. Your results should appear as below (I escaped the apostrophe in the last result).' + CHAR(10)

GO

SELECT		CONVERT(CHAR(30),primaryTitle) AS 'Title',
			titleType AS 'Type',
			startYear AS 'Year',
			averageRating AS 'Rating'
FROM		title_basics
JOIN 		title_directors ON title_basics.tconst = title_directors.tconst
JOIN 		name_basics ON title_directors.nconst = name_basics.nconst
JOIN 		title_ratings ON title_basics.tconst = title_ratings.tconst
WHERE		primaryName = 'Quentin Tarantino'
AND 		titleType = 'movie'
ORDER BY	averageRating DESC;
GO


GO
PRINT 'CIS 275, Lab Week 3, Question 9  [3pts possible]:
Top 10 SF Series
----------------
Find the 10 most highly rated SF TV series. Include only series with 10000 or more votes.
Format Title using 30 characters.' + CHAR(10)

GO

SELECT		TOP 10 CONVERT(CHAR(30),primaryTitle) AS 'Title',
			averageRating AS 'Rating',
			numVotes AS '# of Votes'	
FROM		title_basics
JOIN 		title_genre ON title_basics.tconst = title_genre.tconst
JOIN 		title_ratings ON title_basics.tconst = title_ratings.tconst
WHERE		genre = 'Sci-Fi'
AND		titleType = 'tvSeries'
AND		numVotes >= 10000
ORDER BY	averageRating DESC;

GO


GO
PRINT 'CIS 275, Lab Week 3, Question 10  [3pts possible]:
David Lynch/Angelo Badalamenti
------------------------------
Use INTERSECT and the title_principals table to find all movies where David Lynch and
Angelo Badalamenti worked together. Include ID and Title, format Title as 20 characters wide, and 
order alphabetically by Title.' + CHAR(10)

GO

SELECT		title_principals.tconst AS 'ID',
			primaryTitle AS 'Title'
FROM		title_basics
JOIN 		title_principals ON title_basics.tconst = title_principals.tconst
JOIN 		name_basics ON title_principals.nconst = name_basics.nconst
WHERE		primaryName = 'David Lynch'
AND 		titleType = 'movie'
INTERSECT
SELECT		title_principals.tconst AS 'ID',
			primaryTitle AS 'Title'
FROM		title_basics
JOIN 		title_principals ON title_basics.tconst = title_principals.tconst
JOIN		name_basics ON title_principals.nconst = name_basics.nconst
WHERE		primaryName = 'Angelo Badalamenti'
AND 		titleType = 'movie'
ORDER BY	primaryTitle;
GO



GO
-------------------------------------------------------------------------------------
-- This is an anonymous program block. DO NOT CHANGE OR DELETE.
-------------------------------------------------------------------------------------
BEGIN
    PRINT '|---' + REPLICATE('+----',15) + '|';
    PRINT ' End of CIS275 Lab Week 3' + REPLICATE(' ',50) + CONVERT(CHAR(12),GETDATE(),101);
    PRINT '|---' + REPLICATE('+----',15) + '|';
END;


