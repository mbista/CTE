https://docs.microsoft.com/en-us/sql/relational-databases/lesson-1-connecting-to-the-database-engine?view=sql-server-2017CREATE TABLE dbo.subscribers 
  ( 
     [SubscriberID]  INT IDENTITY(1, 1) PRIMARY KEY, 
     [FirstName]     VARCHAR(25), 
     [LastName]      VARCHAR(25), 
     [MiddleInitial] VARCHAR(25) NULL, 
     [Address]       VARCHAR(100), 
     [City]          VARCHAR(50), 
     [State]         VARCHAR(2), 
     [Zip]           INT, 
     [Subscription]  INT 
  ); 

CREATE TABLE dbo.magazine 
  ( 
     [MagazineID] INT IDENTITY(1, 1) PRIMARY KEY, 
     [Name]       VARCHAR(50), 
     [Company]    VARCHAR(100), 
     [Language]   VARCHAR(100),
	 [Cost]		  MONEY
  );

INSERT INTO dbo.subscribers(FirstName,LastName,MiddleInitial, [Address],City,[State],[Zip], Subscription)
VALUES
 ('James','May',NULL,'123 Hollywood Blvd','Los Angels','CA',90028,1),
 ('Richard','Hammond',NULL,'456 Some Place','Los Angeles','CA',90028,1),
 ('Jeremey','Clarkson','T','191 Jaguar Drive','Jaguar','CA',90028,1),
 ('Jeremey','Clarkson','T','191 Jaguar Drive','Jaguar','CA',90028,2),
 ('Jeremey','Clarkson','T','191 Jaguar Drive','Jaguar','CA',90028,9),
 ('Jeremey','Clarkson','T','191 Jaguar Drive','Jaguar','CA',90028,10),
 ('Jeremey','Clarkson','T','191 Jaguar Drive','Jaguar','CA',90028,8),
 ('Richard','Hammond',NULL,'456 Some Place','Los Angeles','CA',90028,2),
 ('Richard','Hammond',NULL,'456 Some Place','Los Angeles','CA',90028,9),
 ('Richard','Hammond',NULL,'456 Some Place','Los Angeles','CA',90028,9),
 ('James','May',NULL,'123 Hollywood Blvd','Los Angels','CA',90028,9),
 ('James','May',NULL,'123 Hollywood Blvd','Los Angels','CA',90028,4),
 ('Monish','Bista',NULL,'999 Spooner Street','Marietta','GA',30062,3),
 ('Monish','Bista',NULL,'999 Spooner Street','Marietta','GA',30062,5),
 ('Monish','Bista',NULL,'999 Spooner Street','Marietta','GA',30062,7),
 ('Monish','Bista',NULL,'999 Spooner Street','Marietta','GA',30062,9),
 ('Monish','Bista',NULL,'999 Spooner Street','Marietta','GA',30062,10),
 ('Monish','Bista',NULL,'999 Spooner Street','Marietta','GA',30062,1),
 ('Monish','Bista',NULL,'999 Spooner Street','Marietta','GA',30062,8)

 INSERT INTO dbo.magazine([Name],[Company],[Language],[Cost])
 VALUES
 ('CarsCarsCars!','Car magazine inc','English',10),
 ('Motor Head','Car magazine inc','English',10),
 ('MSDN','MicroSoft','English',0),
 ('Times','Some company','English',12),
 ('Times','Some company','Nepali',15),
 ('Gai Jatra','Ktm printing','Nepali',0.5),
 ('Draon Ball Z','Funimation','Japanese',5),
 ('Grand Tour','Amazon','English',1),
 ('ScienceTech','Science','English',5),
 ('GQ','GQ','English',10)

select * from dbo.subscribers
Select * from dbo.Magazine

Select Motorheads.[Name] as MagazinesForMotorHeads,s.zip as DeliverToZip, count(Motorheads.M_id) as [CopiesToSend]
from subscribers as s
Inner join
(
	Select magazineID as M_id, m.Name
	from  dbo.magazine as m
	where m.MagazineID in (1,2,8)
	Group by m.MagazineID,m.[Name]
) as Motorheads --Select subscription
On Motorheads.M_id = s.Subscription
Group by Motorheads.[Name], s.zip;

--the same thing can be done with the use of with CTE

with MotorHeads_CTE(MagazineID, MagazineName)
as 
--defining MotorHeads_CTE
(
	Select magazineID, m.Name
	from  dbo.magazine as m
	where m.MagazineID in (1,2,8)
	Group by m.MagazineID,m.[Name]
)
select  distinct MHCTE.MagazineName as MagazinesForMotorHeads, s.Zip as DeliverToZip, Count(MHCTE.MagazineID) as CopiesToSend
from MotorHeads_CTE as MHCTE
join subscribers as s
on MHCTE.MagazineID = s.Subscription
Group by MHCTE.MagazineName, s.Zip;


--Delete Duplicate
WITH dupe_CTE(FirstName,LastName,MiddleInitial, [Address],City,[State],[Zip], Subscription, DupeID)
as(
	SELECT s.FirstName,s.LastName,s.MiddleInitial, s.[Address],s.City,s.[State],s.[Zip], s.Subscription, ROW_NUMBER()
			OVER(PARTITION BY s.FirstName,s.LastName,s.MiddleInitial, s.[Address],s.City,s.[State],s.[Zip], s.Subscription
			ORDER BY s.FirstName,s.LastName,s.MiddleInitial, s.[Address],s.City,s.[State],s.[Zip], s.Subscription) as 'DupeID'
	FROM subscribers as s)
DELETE FROM dupe_CTE
WHERE DupeID>1;