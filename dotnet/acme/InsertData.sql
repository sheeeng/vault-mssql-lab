CREATE SCHEMA AcmeSchema;
GO

CREATE TABLE AcmeSchema.AcmeTable (
  Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
  RandomString NVARCHAR(50),
  RandomDateTime NVARCHAR(50)
);
GO

INSERT INTO AcmeSchema.AcmeTable (RandomString, RandomDateTime) VALUES
  (N'ABCD1234', N'1970-01-01T00:00:00.00Z'),
  (LEFT(REPLACE(NEWID(),'-',''),8), FORMAT(GetUtcDate(),'yyyy-MM-ddTHH:mm:ss.ff')+"Z"),
  (LEFT(REPLACE(NEWID(),'-',''),8), FORMAT(GetUtcDate(),'yyyy-MM-ddTHH:mm:ss.ff')+"Z"),
  (LEFT(REPLACE(NEWID(),'-',''),8), FORMAT(GetUtcDate(),'yyyy-MM-ddTHH:mm:ss.ff')+"Z");
GO

SELECT TOP (50) * FROM AcmeSchema.AcmeTable ;
GO
