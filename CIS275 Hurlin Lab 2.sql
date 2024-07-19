/*
*******************************************************************************************
CIS275 at PCC
CIS275 Lab Week 2: using SQL SERVER 2012 and the TV database
*******************************************************************************************

                                   CERTIFICATION:

   By typing my name below I certify that the enclosed is original coding written by myself
without unauthorized assistance.  I agree to abide by class restrictions and understand that
if I have violated them, I may receive reduced credit (or none) for this assignment.

                CONSENT:   Skyler Hurlin
                DATE:      1/25/2022

*******************************************************************************************
*/

USE TV    -- ensures correct database is active


GO
PRINT '|---' + REPLICATE('+----',15) + '|'
PRINT 'Read the questions below and insert your queries where prompted.  When  you are finished,
you should be able to run the file as a script to execute all answers sequentially (without errors!)' + CHAR(10)
PRINT 'Queries should be well-formatted.  SQL is not case-sensitive, but it is good form to
capitalize keywords and to capitalize table names as they appear in the database; you should also put 
each projected column on its own line and use indentation for neatness.  Example:

   SELECT Name,
          CustomerID
   FROM   CUSTOMER
   WHERE  CustomerID < 106;

All SQL statements should end in a semicolon.  Whatever format you choose for your queries, make
sure that it is readable and consistent.' + CHAR(10)
PRINT 'Be sure to remove the double-dash comment indicator when you insert your code!';
PRINT '|---' + REPLICATE('+----',15) + '|' + CHAR(10) + CHAR(10)
GO


GO
PRINT 'CIS 275, Lab Week 2, Question 1  [3pts possible]:
What channel is SYFY?
---------------------
Write a SELECT statement that finds the channels named SYFYP and SYFYHDP in the CHANNEL table of the TV
database. Use a WHERE clause with an OR statement to return only these two channels.

Display only the ChannelNumber and DisplayName columns.

Hint: Correct results will look like this (note that DisplayName is 200 characters wide, so I''ve edited a bit):

ChannelNumber DisplayName
------------- -----------
59            SYFYP
1411          SYFYHDP
' + CHAR(10)

GO

SELECT	ChannelNumber,
		DisplayName + CHAR(10)
FROM	CHANNEL
WHERE	ChannelNumber = 59
OR		ChannelNumber = 1411;

GO
PRINT 'CIS 275, Lab Week 2, Question 2  [3pts possible]:
What channel is OPB?
---------------------
Write a SELECT statement that finds all the channels with OPB in the display name.
Use a WHERE clause with LIKE and wildcards to find all matching channels.

Display only the ChannelNumber and DisplayName columns.

This time, use CONVERT to make the DisplayName be 10 characters wide. Use AS to give your column a name.

Display results in ascending order by ChannelNumber.

Hint: Correct results will look like this:

ChannelNumber ChannelName
------------- -----------
10            KOPB      
1010          KOPBDT    
1165          KOPBDT2   
1166          KOPBDT3   
' + CHAR(10)

GO

SELECT	ChannelNumber,
		CONVERT(CHAR(10),DisplayName) AS ChannelName
FROM	CHANNEL
WHERE	DisplayName LIKE '%OPB%'
ORDER BY ChannelNumber;


GO
PRINT 'CIS 275, Lab Week 2, Question 3  [3pts possible]:
What are the genres?
--------------------
Produce a list of the distinct genres, sorted in alphabetical order by genre. 

Display the genre with no more than 20 characters wide. Make sure your genre column has a column name.

Hint: Genre is a column in the SHOW table.

Hint 2: Use the DISTINCT keyword to get the distinct list.

Hint 3: Correct results will have 114 rows and will look like this:

Genre
--------------------
-                   
Action              
Action sports       
Adults only         
Adventure           
Agriculture         
Animals             
Anthology           
Art                 
Arts/crafts         
Auction             
Auto                
Auto racing         
Aviation            
Baseball            
Basketball          
...
Weather             
Western             
Wrestling 
' + CHAR(10)

GO

SELECT DISTINCT CONVERT(CHAR(20),Genre) AS Genre
FROM	SHOW
ORDER BY Genre;

GO
PRINT 'CIS 275, Lab Week 2, Question 4  [3pts possible]:
Best SF?
--------
Find the top rated family safe sci fi shows in the SHOW table. Include all shows where the Genre is sci fi, the 
StarRating is 8 or over, and the Classification is either G, PG, or PG-13. Use IN with a set of values to match
the Classification.

Produce the following columns: Title, Description, StarRating, Classification. Title should be no more than 20 
characters wide and Description should be no more than 50 characters wide. Classification should be no more
than 5 characters wide. Don''t forget to give all columns names!

Order in descending order by star rating. For shows with the same star rating, order by title alphabetically (A-Z).

Hint: Use the results in the previous query to determine the correct spelling for the sci fi genre.

Hint 2: Correct results will have 24 rows and will look like this (I did a bit of minor editing because
of apostrophes):

Title                Description                                        StarRating  Classification
-------------------- -------------------------------------------------- ----------- --------------
Avatar               On an alien planet, a former Marine (Sam Worthingt 10          PG-13
Gravity              The destruction of their shuttle leaves two astron 10          PG-13
Minority Report      A policeman (Tom Cruise) tries to establish his in 10          PG-13
Star Wars: The Force Thirty years after the defeat of the Galactic Empi 10          PG-13
The Day the Earth St Klaatu (Michael Rennie) and his guardian robot, Go 10          G    
Dawn of the Planet o Human survivors of a plague threaten Caesar''s gro 8           PG-13
Fantastic Planet     The 39-foot-tall pastel Draags keep leashes on the 8           PG   
Gattaca              An outcast (Ethan Hawke) takes part in a complicat 8           PG-13
Guardians of the Gal A space adventurer (Chris Pratt) becomes the quarr 8           PG-13
I Am Legend          After a man-made plague transforms Earth''s popula 8           PG-13
Independence Day     A fighter pilot (Will Smith), a computer whiz (Jef 8           PG-13
Interstellar         As mankind''s time on Earth comes to an end, a gro 8           PG-13
Invasion of the Body San Francisco health inspectors (Donald Sutherland 8           PG   
Midnight Special     The government and a group of religious extremists 8           PG-13
Pacific Rim          A washed-up ex-pilot (Charlie Hunnam) and an untes 8           PG-13
Rise of the Planet o A scientist''s (James Franco) quest to find a cur  8           PG-13
Serenity             Crew members (Nathan Fillion, Gina Torres, Alan Tu 8           PG-13
Solaris              A widowed psychologist (George Clooney) arrives at 8           PG-13
The Abyss            Oil-platform workers, including an estranged coupl 8           PG-13
The Fifth Element    A New York City cabdriver (Bruce Willis) tries to  8           PG-13
The Hunger Games     A resourceful teen (Jennifer Lawrence) takes her y 8           PG-13
The Hunger Games: Ca After their unprecedented victory in the 74th Hung 8           PG-13
Twilight Zone: The M Four tales include a bigot (Vic Morrow), oldsters  8           PG   
Westworld            Androids go haywire with guests (Richard Benjamin, 8           PG   
' + CHAR(10)

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
is NULL. Use "Channel Name" as the header for the name column and "Sort Order" for the sort order column.
Display results in ascending order by SortOrder.

Hint: The correct answer will have 93 rows and will look like this:

Channel Name Sort Order
------------ -----------
KATUDT       702
KRCWDT       703
KPXGDT       705
KOINDT       706
DSCHDP       707
KGWDT        708
WGNAPHD      709
KOPBDT       710
VEL          711
KPTVDT       712
KPDXDT       713
FUSEHD       714
...
UPHD         797
AXSTV        798
NFLNRZD      799
' + CHAR(10)

GO

SELECT DisplayName AS 'Channel Name',
		SortOrder AS 'Sort Order'
FROM	CHANNEL
WHERE	SortOrder BETWEEN 700 AND 799
		AND ExternalID IS NOT NULL
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

Display results in order by start time.

Hint: Visit this page for the section on Date and Time Styles:
https://docs.microsoft.com/en-us/sql/t-sql/functions/cast-and-convert-transact-sql?view=sql-server-2017

Hint 2: To get the Length, subtract the start time from the end time and convert the
result using the appropriate date format.

Hint 3: You can concatenate string values in the SELECT clause by adding them together with +.

Hint 4: Correct results will have 19 rows and will look like this:

Time                Title                Length   Description
------------------- -------------------- -------- --------------------------------------------------
23:00:00 - 01:00:00 Lake Placid          02:00:00 A New York paleontologist (Bridget Fonda) goes to 
01:00:00 - 03:00:00 Jeepers Creepers     02:00:00 A cloaked figure (Jonathan Breck) terrorizes two s
03:00:00 - 04:00:00 The Twilight Zone    01:00:00 Mute: Parents raise their daughter (Ann Jillian) w
04:00:00 - 04:30:00 Paid Programming     00:30:00 Paid programming. (HDTV)                          
04:30:00 - 05:00:00 Paid Programming     00:30:00 Paid programming. (HDTV)                          
05:00:00 - 05:30:00 Paid Programming     00:30:00 Paid programming. (HDTV)                          
05:30:00 - 06:00:00 Paid Programming     00:30:00 Paid programming. (HDTV)                          
06:00:00 - 07:00:00 CSI: Crime Scene Inv 01:00:00 19 Down...: When the team discovers a connection b
07:00:00 - 08:00:00 CSI: Crime Scene Inv 01:00:00 One to Go: Grissom announces that he is leaving, w
08:00:00 - 09:00:00 CSI: Crime Scene Inv 01:00:00 The Grave Shift: Dr. Langston''s first day on the 
09:00:00 - 10:00:00 CSI: Crime Scene Inv 01:00:00 Disarmed & Dangerous: A specialized team of forens
10:00:00 - 11:00:00 CSI: Crime Scene Inv 01:00:00 Deep Fried & Minty Fresh: The team investigates a 
11:00:00 - 12:00:00 CSI: Crime Scene Inv 01:00:00 Miscarriage of Justice: As Langston testifies at t
12:00:00 - 14:00:00 Seventh Son          02:00:00 A supernatural champion (Jeff Bridges) has little 
14:00:00 - 17:00:00 Need for Speed       03:00:00 Determined to take down his treacherous rival (Dom
17:00:00 - 18:57:00 Lake Placid          01:57:00 A New York paleontologist (Bridget Fonda) goes to 
18:57:00 - 21:00:00 Lake Placid 2        02:03:00 A sheriff, a big-game hunter and a wildlife office
21:00:00 - 22:00:00 Face Off: Game Face  01:00:00 Stone Cold Superheroes: The artists create plant-h
22:00:00 - 00:30:00 300                  02:30:00 Sparta''s King Leonidas (Gerard Butler) and his ba
' + CHAR(10)

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
(StartTime is 20:00:00).

Display results in order by ChannelNumber. 

Show ONLY the DisplayName, ChannelNumber, StartTime, EndTime, and Title.

Use CONVERT to format the StartTime and EndTime hh:mi:ss without the day, month, or year. 

Use CAST or CONVERT make DisplayName 10 characters wide, and Title 30 characters wide. 

Make sure all columns have appropriate names (using AS where needed).

Hint: A DATETIME column can be matched against a string like 8/30/1962 13:00:00.

Hint 2: Correct results will have 100 rows, and look like this:

Channel Name Channel Number Start Time End Time Title
------------ -------------- ---------- -------- ------------------------------
KATU         2              20:00:00   21:00:00 Celebrity Family Feud         
KRCW         3              20:00:00   20:30:00 Two and a Half Men            
KPXG         5              20:00:00   21:00:00 Law & Order: Criminal Intent  
KOIN         6              20:00:00   21:00:00 Big Brother                   
DSCP         7              20:00:00   21:00:00 Alaska: The Last Frontier     
WGNAP        9              20:00:00   21:00:00 Blue Bloods                   
KOPB         10             20:00:00   21:30:00 The Carpenters: Close to You (
KPTV         12             20:00:00   21:00:00 The Orville                   
KPDX         13             20:00:00   21:00:00 Rookie Blue                   
TELEP        15             20:00:00   00:00:00 Ad Channel                    
QVC          16             20:00:00   21:00:00 Today''s Top Tech              
...
MEXCAN       625            20:00:00   20:30:00 Liga Mexicana de Jaripeo Profe
MULTV        626            20:00:00   22:00:00 Poncho en Domingo             
TEFEI        629            20:00:00   22:30:00 La Peña de Morfi  
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

Display results in order by episode number.

Correct results will look like this:

Title                Episode              Series #   Episode # Original Air Date
-------------------- -------------------- ---------- --------- -----------------
Rick and Morty       The Rickshank Rickde EP01833673 301       Apr 01, 2017
Rick and Morty       Rickmancing the Ston EP01833673 302       Jul 30, 2017
Rick and Morty       Pickle Rick          EP01833673 303       Aug 06, 2017
Rick and Morty       Vindicators 3: The R EP01833673 304       Aug 13, 2017
Rick and Morty       The Whirly Dirly Con EP01833673 305       Aug 20, 2017
Rick and Morty       Rest and Ricklaxatio EP01833673 306       Aug 27, 2017
Rick and Morty       The Ricklantis Mixup EP01833673 307       Sep 10, 2017
' + CHAR(10)

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
is "To Be Announced" or "SIGN OFF". Format your results to look like this:

Channel Name Title                Episode              Date         Time                Length
------------ -------------------- -------------------- ------------ ------------------- --------
BBCAPH       Doctor Who           Deep Breath          Sep 08, 2017 04:30:00 - 12:30:00 08:00:00
BBCAPH       Doctor Who           Deep Breath          Sep 08, 2017 12:30:00 - 20:30:00 08:00:00
BBCAPH       Doctor Who           Deep Breath          Sep 08, 2017 20:30:00 - 04:30:00 08:00:00
CSPAN2       Public Affairs Event N/A                  Sep 08, 2017 21:00:00 - 05:00:00 08:00:00
CSPAN2       Book TV              N/A                  Sep 10, 2017 10:00:00 - 18:00:00 08:00:00
BBCAP        Doctor Who           Deep Breath          Sep 08, 2017 04:30:00 - 12:30:00 08:00:00
BBCAP        Doctor Who           Deep Breath          Sep 08, 2017 12:30:00 - 20:30:00 08:00:00
BBCAP        Doctor Who           Deep Breath          Sep 08, 2017 20:30:00 - 04:30:00 08:00:00
TVMRT        Beyond Today         N/A                  Sep 03, 2017 19:30:00 - 03:30:00 08:00:00
TVMRT        Beyond Today         N/A                  Sep 04, 2017 03:30:00 - 11:30:00 08:00:00

Hint: Use ISNULL to display NULL values in Episode as N/A, and restrict them to no more than 20
characters wide.
' + CHAR(10)

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
Find all showings of The Twilight Zone episode "It''s a Good Life." Format your results exactly
as they appear below.

Hint: You can convert the same DATETIME twice, using two different format codes, and concatenate the
results together into a single string.

Correct output will look like this (only two columns):

Channel Name Time
------------ ---------------------------------
SYFYP        Sep 15, 2017: 06:00:00 - 06:30:00
SYFYHDP      Sep 15, 2017: 06:00:00 - 06:30:00
SYFYP        Sep 16, 2017: 05:00:00 - 05:30:00
SYFYHDP      Sep 16, 2017: 05:00:00 - 05:30:00
' + CHAR(10)

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


