--Identify the artists and their albums
-- Locate the table with artists.

Select *
FROM Artist

-- Write a query to show all artist names. Use an alias here called artist.

SELECT Name as Artist
FROM Artist

--Now, locate the table with albums. Write a query to show all album titles

SELECT Title
FROM Album

-- Join the artist table to album table with the following columns:  
-- name (use an alias here called artist), album title.
-- JOINs: Join name table2name ON table1name.column = table2name.column

Select Name as Artist, Title
FROM Artist
INNER JOIN Album ON Artist.ArtistId = Album.ArtistId

-- How many rows are in the result set?

Select Count(*) as Total_Rows
FROM Artist
INNER JOIN Album ON Artist.ArtistId = Album.ArtistId

--Now, let's learn more about the album tracks and genres
-- Locate the table with album tracks.

Select *
FROM Track

-- Write a query to join the track table to the previous query with the following columns: 
-- artist name, album title, album tracks (use an alias called tracks)

Select Artist.Name as Artist, Album.Title, COUNT(Track.Name) as Tracks
FROM Artist
INNER JOIN Album ON Artist.ArtistId = Album.ArtistId
INNER JOIN Track ON Album.AlbumId = Track.AlbumId
GROUP BY Artist.Name, Album.Title

-- Now, locate the genre table.

Select *
FROM Genre

-- Join genre table to the track table from the previous query with the following columns: 
-- artist name, album title, album tracks, genre name (use an alias here called genre)

Select Artist.Name as Artist, Album.Title, COUNT(Track.Name) as Tracks, Genre.Name as Genre
FROM Artist
INNER JOIN Album ON Artist.ArtistId = Album.ArtistId
INNER JOIN Track ON Album.AlbumId = Track.AlbumId
INNER JOIN Genre ON Track.GenreId = Genre.GenreId
GROUP BY Artist.Name, Album.Title

-- Modify the query to find all rock, jazz, and classical albums

Select Artist.Name as Artist, Album.Title, COUNT(Track.Name) as Tracks, Genre.Name as Genre
FROM Artist
INNER JOIN Album ON Artist.ArtistId = Album.ArtistId
INNER JOIN Track ON Album.AlbumId = Track.AlbumId
INNER JOIN Genre ON Track.GenreId = Genre.GenreId
WHERE Genre.Name IN ('Rock', 'Jazz', 'Classical')
GROUP BY Artist.Name, Album.Title, Genre.Name

--Modify the query to prevent the filter from executing without deleting anything

Select Artist.Name as Artist, Album.Title, COUNT(Track.Name) as Tracks, Genre.Name as Genre
FROM Artist
INNER JOIN Album ON Artist.ArtistId = Album.ArtistId
INNER JOIN Track ON Album.AlbumId = Track.AlbumId
INNER JOIN Genre ON Track.GenreId = Genre.GenreId
WHERE Genre.Name IN ('Rock', 'Jazz', 'Classical') or Genre.Name is null
GROUP BY Artist.Name, Album.Title, Genre.Name

--We need to get the total sales price for each album.
-- Write a query with the following columns: 
-- album title, genre, total track sales price (name this column 'total_sales')

Select Album.Title, Genre.Name as Genre, sum(UnitPrice) as Total_Sales
FROM Artist
INNER JOIN Album ON Artist.ArtistId = Album.ArtistId
INNER JOIN Track ON Album.AlbumId = Track.AlbumId
INNER JOIN Genre ON Track.GenreId = Genre.GenreId
GROUP BY Album.Title, Genre.Name

-- Calculate the total sales, minimum, maximum, average by genre

Select Genre.Name as Genre, sum(UnitPrice) as Total_Sales
, min(UnitPrice), max(UnitPrice), avg(UnitPrice)
FROM Artist
INNER JOIN Album ON Artist.ArtistId = Album.ArtistId
INNER JOIN Track ON Album.AlbumId = Track.AlbumId
INNER JOIN Genre ON Track.GenreId = Genre.GenreId
GROUP BY Genre.Name

--Now let's see if we can get more information about the number of tracks sold.
-- Locate the table that contains sales and quantity information.

SELECT *
FROM InvoiceLine

-- Write a query to show the total tracks sold in price and quantity per album with 
-- the following columns: album title, genre, total sales, total quantity

Select Album.Title, Genre.Name as Genre, sum(Track.UnitPrice) as Total_Sales
, sum(Quantity) as Total_Quantity
FROM Artist
INNER JOIN Album ON Artist.ArtistId = Album.ArtistId
INNER JOIN Track ON Album.AlbumId = Track.AlbumId
INNER JOIN Genre ON Track.GenreId = Genre.GenreId
INNER JOIN InvoiceLine ON Track.TrackId = InvoiceLine.TrackId
GROUP BY Album.Title, Genre.Name

-- Order the results by price from high to low. Which album has the highest sales? 

Select Album.Title, Genre.Name as Genre, sum(Track.UnitPrice) as Total_Sales
, sum(Quantity) as Total_Quantity
FROM Artist
INNER JOIN Album ON Artist.ArtistId = Album.ArtistId
INNER JOIN Track ON Album.AlbumId = Track.AlbumId
INNER JOIN Genre ON Track.GenreId = Genre.GenreId
INNER JOIN InvoiceLine ON Track.TrackId = InvoiceLine.TrackId
GROUP BY Album.Title, Genre.Name
ORDER BY Total_Sales desc

-- Battlestar Galactica (Classic), Season 1 had the highest sales

-- Filter the results to show albums with total sales > $25

Select Album.Title, Genre.Name as Genre, sum(Track.UnitPrice) as Total_Sales
, sum(Quantity) as Total_Quantity
FROM Artist
INNER JOIN Album ON Artist.ArtistId = Album.ArtistId
INNER JOIN Track ON Album.AlbumId = Track.AlbumId
INNER JOIN Genre ON Track.GenreId = Genre.GenreId
INNER JOIN InvoiceLine ON Track.TrackId = InvoiceLine.TrackId
GROUP BY Album.Title, Genre.Name
HAVING Total_Sales > 25

--Execute various queries to display specific data from these tables
-- Write a query to display the total number of tracks per album

Select Album.Title, COUNT(Track.TrackId) as Number_of_Tracks
FROM Artist
INNER JOIN Album ON Artist.ArtistId = Album.ArtistId
INNER JOIN Track ON Album.AlbumId = Track.AlbumId
GROUP BY Album.Title

-- Write a query to show total number of albums by Deep Purple. Include the artist name 
-- and the total albums in the result.

Select DISTINCT (Artist.Name), COUNT(Album.Title) as Total_Albums 
FROM Artist
INNER JOIN Album ON Artist.ArtistId = Album.ArtistId
INNER JOIN Track ON Album.AlbumId = Track.AlbumId
GROUP BY Artist.Name
HAVING Artist.Name = 'Deep Purple'

-- Write a query to display the total number of artists in each genre. 
-- Sort the number in descending order

Select Genre.Name as Genre, COUNT(DISTINCT Artist.Name) as Total_Artists
FROM Artist
INNER JOIN Album ON Artist.ArtistId = Album.ArtistId
INNER JOIN Track ON Album.AlbumId = Track.AlbumId
INNER JOIN Genre ON Track.GenreId = Genre.GenreId
GROUP BY Genre.Name
















