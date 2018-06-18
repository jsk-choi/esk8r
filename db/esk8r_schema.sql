IF EXISTS(SELECT * FROM sys.tables WHERE NAME = 'Asset')		DROP TABLE dbo.Asset
IF EXISTS(SELECT * FROM sys.tables WHERE NAME = 'BuildDetail')	DROP TABLE dbo.BuildDetail
IF EXISTS(SELECT * FROM sys.tables WHERE NAME = 'BuildHeader')	DROP TABLE dbo.BuildHeader
IF EXISTS(SELECT * FROM sys.tables WHERE NAME = 'ConfigDetail')	DROP TABLE dbo.ConfigDetail
IF EXISTS(SELECT * FROM sys.tables WHERE NAME = 'ConfigHeader')	DROP TABLE dbo.ConfigHeader
IF EXISTS(SELECT * FROM sys.tables WHERE NAME = 'Item')			DROP TABLE dbo.Item
IF EXISTS(SELECT * FROM sys.tables WHERE NAME = 'Brand')		DROP TABLE dbo.Brand
IF EXISTS(SELECT * FROM sys.tables WHERE NAME = 'Category')		DROP TABLE dbo.Category
GO

------------------------
--- CATEGORY
CREATE TABLE dbo.Category (
	Id INT IDENTITY(1,1)

	, Active BIT NOT NULL 
		DEFAULT 1
	, CreateDate DATETIME NOT NULL 
		DEFAULT GETDATE()

	, ParentId INT NULL
	, Category NVARCHAR(100) NOT NULL

	, CONSTRAINT PK_Category 
		PRIMARY KEY (Id)
	, CONSTRAINT FK_Category_CategoryParent 
		FOREIGN KEY (ParentId) 
		REFERENCES Category(Id)
)
GO

CREATE NONCLUSTERED INDEX IX_Category ON dbo.Category (
	ParentId
)
GO

------------------------
--- ITEM
CREATE TABLE dbo.Brand (

	Id INT IDENTITY(1,1)

	, Active BIT NOT NULL 
		DEFAULT 1
	, CreateDate DATETIME NOT NULL 
		DEFAULT GETDATE()

 	, UniqueId NVARCHAR(100) NOT NULL
	, BrandName NVARCHAR(100) NOT NULL
	, BrandDesc NVARCHAR(2000) NULL
	
	, [Url] NVARCHAR(200) NOT NULL

	, CONSTRAINT PK_Brand 
		PRIMARY KEY (Id)
)
GO

CREATE NONCLUSTERED INDEX IX_Brand ON dbo.Brand (
	UniqueId
)
GO


------------------------
--- ITEM
CREATE TABLE dbo.Item (

	Id INT IDENTITY(1,1)

	, Active BIT NOT NULL 
		DEFAULT 1
	, CreateDate DATETIME NOT NULL 
		DEFAULT GETDATE()

 	, UniqueId NVARCHAR(100) NOT NULL
	, ParentId INT NULL
	, CategoryId INT NULL

	, BrandId INT NOT NULL
	, ItemName NVARCHAR(100) NOT NULL
	, ItemDesc NVARCHAR(2000) NOT NULL
	
	, [Url] NVARCHAR(200) NOT NULL
	, Price MONEY NOT NULL

	, CONSTRAINT PK_Item 
		PRIMARY KEY (Id)
	, CONSTRAINT FK_Item_ItemParent 
		FOREIGN KEY (ParentId) 
		REFERENCES Item(Id)
	, CONSTRAINT FK_Item_Brand 
		FOREIGN KEY (BrandId) 
		REFERENCES Brand(Id)
	, CONSTRAINT FK_Item_Category 
		FOREIGN KEY (CategoryId) 
		REFERENCES Category(Id)
)
GO

CREATE NONCLUSTERED INDEX IX_Item ON dbo.Item (
	UniqueId
	, ParentId
	, BrandId
)
GO

------------------------
--- ASSET
CREATE TABLE dbo.Asset (
	
	Id INT IDENTITY(1,1)

	, Active BIT NOT NULL 
		DEFAULT 1
	, CreateDate DATETIME NOT NULL 
		DEFAULT GETDATE()

	, ItemId INT NOT NULL
	, ItemSource VARCHAR(100) NOT NULL
	, ItemDesc VARCHAR(100) NOT NULL
	, AssetName VARCHAR(100) NOT NULL
	, AssetType VARCHAR(100) NOT NULL

	, CONSTRAINT PK_Asset 
		PRIMARY KEY (Id)
)
GO

CREATE NONCLUSTERED INDEX IX_Asset ON dbo.Asset (
	ItemId
)
GO

------------------------
--- BUILD HEADER
CREATE TABLE dbo.BuildHeader (
	
	Id INT IDENTITY(1,1)

	, Active BIT NOT NULL 
		DEFAULT 1
	, CreateDate DATETIME NOT NULL 
		DEFAULT GETDATE()

	, UniqueId NVARCHAR(100) NOT NULL
	, BuildName NVARCHAR(100) NOT NULL
	, Notes NVARCHAR(500) NULL
	, BuilderEmail NVARCHAR(100) NOT NULL
	, BuildExtUrl NVARCHAR(200) NULL

	, CONSTRAINT PK_BuildHeader 
		PRIMARY KEY (Id)
)
GO

CREATE NONCLUSTERED INDEX IX_BuildHeader ON dbo.BuildHeader (
	UniqueId
)
GO

------------------------
--- BUILD DETAIL
CREATE TABLE dbo.BuildDetail (
	
	Id INT IDENTITY(1,1)

	, Active BIT NOT NULL 
		DEFAULT 1
	, CreateDate DATETIME NOT NULL 
		DEFAULT GETDATE()

	, BuildHeaderId INT NOT NULL
	, ItemId INT NULL
	, ConfigHeaderId INT NULL

	, CONSTRAINT PK_BuildDetail 
		PRIMARY KEY (Id)
	, CONSTRAINT FK_BuildDetail_BuildHeader
		FOREIGN KEY (BuildHeaderId) 
		REFERENCES BuildHeader(Id)
	, CONSTRAINT FK_BuildDetail_Item
		FOREIGN KEY (ItemId) 
		REFERENCES Item(Id)
)
GO

CREATE NONCLUSTERED INDEX IX_BuildDetail ON dbo.BuildDetail (
	BuildHeaderId
	, ItemId
	, ConfigHeaderId
)
GO

------------------------
--- CONFIG HEADER
CREATE TABLE dbo.ConfigHeader (
	
	Id INT IDENTITY(1,1)

	, Active BIT NOT NULL 
		DEFAULT 1
	, CreateDate DATETIME NOT NULL 
		DEFAULT GETDATE()

	, UniqueId NVARCHAR(100) NOT NULL
	, ConfigName NVARCHAR(100) NOT NULL
	, Notes NVARCHAR(500) NULL

	, CONSTRAINT PK_ConfigHeader 
		PRIMARY KEY (Id)
)
GO

--CREATE NONCLUSTERED INDEX IX_ConfigHeader ON dbo.ConfigHeader ()
--GO

------------------------
--- CONFIG DETAIL
CREATE TABLE dbo.ConfigDetail (
	
	Id INT IDENTITY(1,1)

	, Active BIT NOT NULL 
		DEFAULT 1
	, CreateDate DATETIME NOT NULL 
		DEFAULT GETDATE()

	, ConfigHeaderId INT NOT NULL
	, CategoryId INT NULL
	, Notes NVARCHAR(100) NULL

	, CONSTRAINT PK_ConfigDetail 
		PRIMARY KEY (Id)
	, CONSTRAINT FK_ConfigDetail_ConfigHeader
		FOREIGN KEY (ConfigHeaderId) 
		REFERENCES ConfigHeader(Id)
	, CONSTRAINT FK_ConfigDetail_Category
		FOREIGN KEY (CategoryId) 
		REFERENCES Category(Id)
)
GO

CREATE NONCLUSTERED INDEX IX_ConfigDetail ON dbo.ConfigDetail (
	ConfigHeaderId,
	CategoryId
)
GO
