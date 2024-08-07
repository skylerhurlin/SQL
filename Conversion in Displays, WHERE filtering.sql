/* NOTES: This is a homework assignment for the second course in my Database Design & SQL certificate, using MSSQL and TVDB. My codes all ran properly and I recieved an A on the assignment.*/

GO
	
USE TV;

GO
PRINT 'CIS 275, Lab Week 2, Question 1  [3pts possible]:
What channels are SYFY? Filter by channel numbers.' + CHAR(10)

GO

SELECT	ChannelNumber,
		DisplayName + CHAR(10)
FROM	CHANNEL
WHERE	ChannelNumber = 59
OR		ChannelNumber = 1411;

GO
PRINT 'CIS 275, Lab Week 2, Question 2  [3pts possible]:
What channels are OPB? Filter by display name.' + CHAR(10)

GO

SELECT	ChannelNumber,
		CONVERT(CHAR(10),DisplayName) AS ChannelName
FROM	CHANNEL
WHERE	DisplayName LIKE '%OPB%'
ORDER BY ChannelNumber;


GO
PRINT 'CIS 275, Lab Week 2, Question 3  [3pts possible]:
What are the genres in the database?' + CHAR(10)

GO

SELECT DISTINCT CONVERT(CHAR(20),Genre) AS Genre
FROM	SHOW
ORDER BY Genre;

GO
PRINT 'CIS 275, Lab Week 2, Question 4  [3pts possible]:
Find the top rated family safe sci fi shows in the SHOW table. Include all shows where the Genre is sci fi, the 
StarRating is 8 or over, and the Classification is either G, PG, or PG-13. Use IN with a set of values to match
the Classification.' + CHAR(10)

GO

SELECT	CONVERT(CHAR(20),Title) AS Title, 
		CONVERT(CHAR(50),Description) AS Description, 
		StarRating, 
		CONVERT(CHAR(5),Classification) AS Classification
FROM	SHOW
WHERE	Genre = 'Science fiction'
AND		StarRating >= 8
AND		Classification IN ('G','PG','PG-13')
ORDER BY StarRating DESC, Title;

GO
PRINT 'CIS 275, Lab Week 2, Question 5  [3pts possible]:
HD Stations
-----------
Select the DisplayName and SortOrder from the CHANNEL table for all TV channels where the SortOrder is
between 700 and 799 inclusive. Use the BETWEEN ... AND ... operator. Exclude all rows where the ExternalID
is NULL.' + CHAR(10)

GO

SELECT DisplayName AS 'Channel Name',
		SortOrder AS 'Sort Order'
FROM	CHANNEL
WHERE	SortOrder BETWEEN 700 AND 799
AND 	ExternalID IS NOT NULL
ORDER BY SortOrder;

GO
PRINT 'CIS 275, Lab Week 2, Question 6  [3pts possible]:
Daily Listing for SYFYHDP
-------------------------
Using the all_data view in the TV database, find all listings for shows on SYFYHDP that were
on any time on 9/12/2017. Do NOT include shows that end at 00:00:00 on 9/12/2017, or begin
at 00:00:00 on 9/13/2017. DO include shows that start before midnight on 9/12 but end after
midnight, or start before midnight on 9/12 and end after midnight on 9/13 (see results below
if that isn''t clear).

Include the following columns:
Time - formatted exactly as HH:MM:SS - HH:MM:SS for start time - end time.
Title - Limit to 20 characters wide.
Length - formatted exactly as HH:MM:SS.
Description - Limit to 50 characters wide.

Display results in order by start time.' + CHAR(10)

GO

SELECT	CONVERT(VARCHAR(8), StartTime ,108) + ' - ' + CONVERT(VARCHAR(8), EndTime ,108) AS Time,
		CONVERT (VARCHAR(20), Title) AS 'Title',
		CONVERT(VARCHAR(8),EndTime - StartTime,108) AS 'Length',
		CONVERT (VARCHAR(50), Description) AS 'Description'
FROM	all_data
WHERE	ChannelNumber = 1411 AND (StartTime BETWEEN '2017-09-12 00:00:00' 
		AND '2017-09-12 23:59:59'
		OR EndTime BETWEEN '2017-09-12 00:00:01' 
		AND '2017-09-12 23:59:59')
ORDER BY StartTime;

GO
PRINT 'CIS 275, Lab Week 2, Question 7  [3pts possible]:
What is on TV?
---------------
Using the all_data view in the TV database, show the first 100 TV shows that start on 9/10/2017 at 8:00PM 
(StartTime is 20:00:00). Display results in order by ChannelNumber. Show ONLY the DisplayName, ChannelNumber, StartTime, EndTime, and Title.
' + CHAR(10)

GO

SELECT TOP 100 CONVERT(CHAR(10),DisplayName) AS 'Channel Name',
			ChannelNumber AS 'Channel Number',
			CONVERT(VARCHAR(8), StartTime ,108) AS 'Start Time',
			CONVERT(VARCHAR(8), EndTime ,108) AS 'End Time',
			CONVERT(CHAR(30), Title) AS 'Title'
FROM		all_data
WHERE		StartTime = '9-10-17 20:00:00'
ORDER BY	ChannelNumber;

GO
PRINT 'CIS 275, Lab Week 2, Question 8  [3pts possible]:
Rick and Morty
--------------
Show a distinct list of all Rick and Morty episodes in the SHOW table. Include the following columns:

Title - 20 wide.
Episode - 20 wide.
Series # - 10 wide.
Episode # - 3 wide.
Original Air Date - 12 wide, formatted as, for example, "Apr 01, 2017".

Display results in order by episode number.' + CHAR(10)

GO

SELECT DISTINCT CONVERT(CHAR(20),Title) AS 'Title',
		CONVERT(CHAR(20),EpisodeName) AS 'Episode',
		CONVERT(CHAR(10),SeriesNum) AS 'Series #',
		CONVERT(CHAR(3),EpisodeNum) AS 'Episode #',
		CONVERT(VARCHAR(12), OriginalAirDate, 107)
FROM	SHOW
WHERE	Title = 'Rick and Morty'
ORDER BY 'Episode';

GO
PRINT 'CIS 275, Lab Week 2, Question 9  [3pts possible]:
Couch Potato Achievement
------------------------
Produce a list of the 10 longest shows. Exclude sports-related genres and shows where the title 
is "To Be Announced" or "SIGN OFF". Include the episode name, date, time, and program length.' + CHAR(10)

GO

SELECT TOP 10 DisplayName AS 'Channel Name',
		Title,
		CONVERT(CHAR(20),ISNULL(EpisodeName, 'N/A')) AS 'Episode',
		CONVERT(VARCHAR(12), StartTime ,107) AS 'Date',
		CONVERT(VARCHAR(8), StartTime ,108) + '-' + CONVERT(VARCHAR(8), EndTime ,108) AS 'Time',
		CONVERT(VARCHAR(8),EndTime - StartTime,108) AS 'Length'
FROM	all_data
WHERE	Genre NOT IN ('Action sports', 'Baseball', 'Basketball', 'Boxing', 'Football', 'Golf', 'Hockey', 'Motorsports', 'Pro wrestling','Rugby', 'Soccer', 'Sports event', 'Sports non-event', 'Sports talk', 'Tennis', 'Wrestling') 
AND Title NOT IN ('To Be Announced', 'SIGN OFF')
ORDER BY 'Length' DESC;

GO
PRINT 'CIS 275, Lab Week 2, Question 10  [3pts possible]:
It''s a Good Life
-----------------
Find all showings of The Twilight Zone episode "It''s a Good Life." Include the channgel, date, and starting and ending times.' + CHAR(10)

GO

SELECT	DisplayName AS 'Channel Name', 
		CONVERT(VARCHAR(12), StartTime ,107) + ': ' + CONVERT(VARCHAR(8), StartTime ,108) + ' - ' + CONVERT(VARCHAR(8), EndTime, 108) AS 'Time'
FROM	all_data
WHERE	EpisodeName = 'It''s a Good Life'
ORDER BY StartTime;

GO
-------------------------------------------------------------------------------------
-- This is an anonymous program block. DO NOT CHANGE OR DELETE.
-------------------------------------------------------------------------------------
BEGIN
    PRINT '|---' + REPLICATE('+----',15) + '|';
    PRINT ' End of CIS275 Lab Week 2' + REPLICATE(' ',50) + CONVERT(CHAR(12),GETDATE(),101);
    PRINT '|---' + REPLICATE('+----',15) + '|';
END;
