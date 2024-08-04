/* NOTES: This is a homework assignment for the second course in my Database Design & SQL certificate, using MSSQL and IMDB. My codes all ran properly and I recieved an A on the assignment. */

GO
PRINT 'CIS275, Lab Week 6, Question 1  [3pts possible]:
Display the name and year of birth for all people born after 1980, who have
directed at least one show (i.e. those who appear at least once in the title_directors table).
Limit results to those who have died (who have a value in the deathYear column).' + CHAR(10)

USE IMDB;

SELECT			DISTINCT name_basics.primaryName AS 'Name',
				name_basics.birthYear AS 'Birth Year'
FROM			name_basics
JOIN			title_directors ON name_basics.nconst = title_directors.nconst
WHERE			name_basics.deathYear IS NOT NULL
AND			birthYear > 1980
ORDER BY		name_basics.birthYear DESC;

GO
PRINT 'CIS2275, Lab Week 6, Question 2  [3pts possible]:
Show every genre of television show which has had at least one title with 500 episodes.
i.e. limit results to the titleType ''tvEpisode'' in the title_basics table, and to titles
containing a row in the title_episode table with episodeNumber 500.' + CHAR(10)

GO

SELECT			DISTINCT title_genre.genre AS 'Genre'
FROM			title_genre
JOIN			title_basics ON title_genre.tconst = title_basics.tconst
JOIN			title_episode ON title_genre.tconst= title_episode.tconst
WHERE			title_episode.episodeNumber = 500
AND			title_basics.titleType = 'tvEpisode'
ORDER BY		genre;
GO
PRINT 'CIS2275, Lab Week 6, Question 3  [3pts possible]:
Write a common table expression to identify the WORST shows: join title_basics against title_ratings
and limit your results to those with an averageRating value equal to 1.  Project the title,
type, and startYear from title_basics; and label your CTE as BADSHOWS.
In the main query, show a breakdown of BADSHOWS grouped by type, along with the total number of
rows for each (i.e. GROUP BY titleType)' + CHAR(10)

GO

WITH BADSHOWS AS (
	SELECT		primaryTitle AS 'Title_CTE',
				titleType AS 'titleType_CTE',
				startYear AS 'startYear_CTE'
	FROM		title_basics AS TB
	JOIN		title_ratings AS TR ON TB.tconst = TR.tconst
	WHERE		averageRating = 1
)
SELECT			titleType_CTE AS 'Title Type', COUNT(*) AS '# of Shows'
FROM			BADSHOWS
GROUP BY		titleType_CTE
ORDER BY		COUNT(*) DESC;



GO
PRINT 'CIS2275, Lab Week 6, Question 4  [3pts possible]:
Identify the least popular professions.  Show each profession value from the name_profession table,
along with the total number of matching rows.  Use the HAVING clause to limit
your results to professions with less than 1,000 rows.' + CHAR(10)

SELECT		profession AS Profession,
			COUNT(*) AS '# of People'
FROM		name_profession
GROUP BY	profession
HAVING		COUNT(*) < 1000;

GO


GO
PRINT 'CIS2275, Lab Week 6, Question 5  [3pts possible]:
Use the query from #4 above to display the names of all people belonging to these professions.
Use the previous query as a subquery in the FROM clause here to limit the results.' + CHAR(10)

SELECT			primaryName AS 'Name', profession_table.profession AS 'Profession'
FROM		(SELECT		profession
		FROM		name_profession
		GROUP BY	profession
		HAVING		COUNT(profession) < 1000
		) AS profession_table
JOIN			name_profession ON name_profession.profession = profession_table.profession
JOIN			name_basics ON name_profession.nconst = name_basics.nconst
GROUP BY		profession_table.profession, name_basics.primaryName
ORDER BY		primaryName;
		
GO


GO
PRINT 'CIS2275, Lab Week 6, Question 6  [3pts possible]:
Show the name of every writer, along with the total number of titles they''ve written (i.e. rows in the 
title_writers table).  Limit results to those who have written between 5,000 and 10,000 titles (inclusive).' + CHAR(10)

SELECT			name_basics.primaryName AS 'Name',
				COUNT(*) AS '# of Titles Written'
FROM			name_basics
JOIN			title_writers ON name_basics.nconst = title_writers.nconst
GROUP BY		primaryName
HAVING			COUNT(title_writers.tconst) BETWEEN 5000 AND 10000
ORDER BY		primaryName DESC;
GO


GO
PRINT 'CIS2275, Lab Week 6, Question 7  [3pts possible]:
Show the actor and character names for everyone who has performed the same role in more than one
show with the title ''Battlestar Galactica''.  i.e. identify the combination of (primaryName, characters)
which occurs in the title_principals table more than once for matching titles.' + CHAR(10)

SELECT			name_basics.primaryName AS 'Name',
				title_principals.characters AS 'Character',
				COUNT(*) AS '# Times Played'
FROM			name_basics
JOIN			title_principals ON name_basics.nconst = title_principals.nconst
JOIN			title_basics ON title_principals.tconst = title_basics.tconst
WHERE			primaryTitle = 'Battlestar Galactica'
AND			category LIKE 'act%'
GROUP BY		primaryName, characters
HAVING			COUNT(*) > 1
ORDER BY		primaryName;
GO


GO
PRINT 'CIS2275, Lab Week 6, Question 8  [3pts possible]:
Identify the names of people who have directed more than five highest-rated shows (i.e. title_ratings.averageRating = 10).
For each of these people, display their names and the total number of shows they have written.' + CHAR(10)

SELECT		NB.primaryName AS 'Name',
			COUNT(DISTINCT TW.tconst) AS '# of Titles Written'
FROM		name_basics AS NB
JOIN		title_directors AS TD ON NB.nconst = TD.nconst
JOIN		title_writers AS TW ON NB.nconst = TW.nconst
JOIN		title_basics AS TB ON TD.tconst = TB.tconst
WHERE		TD.tconst IN
		(SELECT		tconst
		FROM		title_ratings
		WHERE		averageRating = 10
		)
GROUP BY	NB.primaryName
HAVING		COUNT(DISTINCT TD.tconst) > 5
ORDER BY	NB.primaryName;
GO


GO
PRINT 'CIS2275, Lab Week 6, Question 9  [3pts possible]:
Display the title and running time for all TV specials ( titleType = ''tvSpecial'' ) from 1982; if the run time is
NULL, substitute zero.' + CHAR(10)

SELECT		primaryTitle AS 'Title',
			ISNULL(runtimeMinutes,0) AS 'Run Time'
FROM		title_basics
WHERE		startYear = 1982
AND		titleType = 'tvSpecial'
ORDER BY	runtimeMinutes DESC;
GO


GO
PRINT 'CIS2275, Lab Week 6, Question 10  [3pts possible]:
Identify every movie from 1913; limit your results to those with a non-NULL value
in the runtimeMinutescolumn.  For each movie, display the primaryTitle and the averageRating value from the title_ratings table.
Use DENSE_RANK() to display the rank based on averageRating (label this RATINGRANK), and also the rank based on runtimeMinutes
(label this LENGTHRANK).  Both of these should be based on an asecending sort order.' + CHAR(10)

SELECT		title_basics.primaryTitle AS 'Title',
			title_ratings.averageRating AS 'Rating',
			DENSE_RANK() OVER (ORDER BY title_ratings.averageRating) AS RATINGRANK,
			DENSE_RANK() OVER (ORDER BY title_basics.runtimeMinutes) AS LENGTHRANK
FROM		title_basics
JOIN		title_ratings ON title_basics.tconst = title_ratings.tconst
WHERE		runtimeMinutes IS NOT NULL
AND			startYear = 1913
AND			titleType = 'movie'
ORDER BY	primaryTitle;
GO



GO
-------------------------------------------------------------------------------------
-- This is an anonymous program block. DO NOT CHANGE OR DELETE.
-------------------------------------------------------------------------------------
BEGIN
    PRINT '|---' + REPLICATE('+----',15) + '|';
    PRINT ' End of CIS275 Lab Week 6' + REPLICATE(' ',50) + CONVERT(CHAR(12),GETDATE(),101);
    PRINT '|---' + REPLICATE('+----',15) + '|';
END;


