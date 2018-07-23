IF EXISTS(SELECT * FROM sys.tables WHERE NAME = '_ChangeLog')	DROP TABLE dbo._ChangeLog
IF EXISTS(SELECT * FROM sys.tables WHERE NAME = 'Asset')		DROP TABLE dbo.Asset
IF EXISTS(SELECT * FROM sys.tables WHERE NAME = 'BuildDetail')	DROP TABLE dbo.BuildDetail
IF EXISTS(SELECT * FROM sys.tables WHERE NAME = 'BuildHeader')	DROP TABLE dbo.BuildHeader

IF EXISTS(SELECT * FROM sys.tables WHERE NAME = 'CompatDetail')	DROP TABLE dbo.CompatDetail
IF EXISTS(SELECT * FROM sys.tables WHERE NAME = 'CompatHeader')	DROP TABLE dbo.CompatHeader

IF EXISTS(SELECT * FROM sys.tables WHERE NAME = 'Item')			DROP TABLE dbo.Item
IF EXISTS(SELECT * FROM sys.tables WHERE NAME = 'ConfigDetail')	DROP TABLE dbo.ConfigDetail
IF EXISTS(SELECT * FROM sys.tables WHERE NAME = 'ConfigHeader')	DROP TABLE dbo.ConfigHeader
IF EXISTS(SELECT * FROM sys.tables WHERE NAME = 'Brand')		DROP TABLE dbo.Brand
IF EXISTS(SELECT * FROM sys.tables WHERE NAME = 'Category')		DROP TABLE dbo.Category

IF EXISTS(SELECT * FROM sys.views WHERE NAME = 'vCompat')		DROP VIEW dbo.vCompat
IF EXISTS(SELECT * FROM sys.views WHERE NAME = 'vConfig')		DROP VIEW dbo.vConfig
IF EXISTS(SELECT * FROM sys.views WHERE NAME = 'vItems')		DROP VIEW dbo.vItems
GO

-- EXTEND IDENTITY MODELS (TABLES)
-- ASP.NET Identity MUST HAVE CREATED ITS TABLES FIRST
-- REGISTER NEW USER WITH UI
IF EXISTS(SELECT * FROM sys.tables WHERE name = '_Users')
BEGIN

	IF NOT EXISTS(
		SELECT * 
		FROM sys.columns 
		WHERE name = 'IdNum' 
			AND OBJECT_NAME(object_id) = '_Users')
	BEGIN
		ALTER TABLE dbo._Users ADD IdNum INT IDENTITY(1,1)
	END

	IF NOT EXISTS(
		SELECT * FROM SYS.indexes WHERE name = 'UQ_IdNum')
	BEGIN
		CREATE UNIQUE INDEX UQ_IdNum ON dbo._Users (IdNum)
	END

END

------------------------
--- CHANGELOG
CREATE TABLE dbo._ChangeLog (
	
	Id INT IDENTITY(1,1)

	, CreateDate DATETIME NOT NULL 
		DEFAULT GETDATE()

	, SourceTable VARCHAR(100) NOT NULL
	, SourceRecordId INT NOT NULL
	, SourceRecord XML NOT NULL

	, CONSTRAINT PK_ChangeLog 
		PRIMARY KEY (Id)
)
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
	, UserId INT NOT NULL

	, CONSTRAINT PK_Category 
		PRIMARY KEY (Id)
	, CONSTRAINT FK_Category_CategoryParent 
		FOREIGN KEY (ParentId) 
		REFERENCES Category(Id)
	, CONSTRAINT FK_Category_User
		FOREIGN KEY (UserId) 
		REFERENCES _Users(IdNum)
)
GO

CREATE NONCLUSTERED INDEX IX_Category ON dbo.Category (
	ParentId
)
GO

CREATE TRIGGER tgCategoryUpdate ON dbo.Category AFTER UPDATE
AS

	DECLARE @id INT
	DECLARE @xml XML

	SELECT @id = id 
	FROM deleted

	SELECT @xml = (
		SELECT * 
		FROM deleted
		FOR XML AUTO
	)

	INSERT INTO dbo._ChangeLog (SourceTable, SourceRecordId, SourceRecord) VALUES ('Category', @id, @xml);
GO

------------------------
--- ITEM
CREATE TABLE dbo.Brand (

	Id INT IDENTITY(1,1)

	, Active BIT NOT NULL 
		DEFAULT 1
	, CreateDate DATETIME NOT NULL 
		DEFAULT GETDATE()
	
	, OwnerUserId INT NULL
	, CreatedByUserId INT NOT NULL

 	, UniqueId NVARCHAR(100) NOT NULL
	, BrandName NVARCHAR(100) NOT NULL
	, BrandDesc NVARCHAR(2000) NULL
	
	, [Url] NVARCHAR(200) NOT NULL

	, CONSTRAINT PK_Brand 
		PRIMARY KEY (Id)
	, CONSTRAINT FK_Brand_OwnerUser 
		FOREIGN KEY (OwnerUserId) 
		REFERENCES dbo._Users(IdNum)
	, CONSTRAINT FK_Brand_CreatedByUser 
		FOREIGN KEY (CreatedByUserId) 
		REFERENCES dbo._Users(IdNum)
)
GO

CREATE NONCLUSTERED INDEX IX_Brand ON dbo.Brand (
	UniqueId
	, OwnerUserId
	, CreatedByUserId
)
GO

CREATE TRIGGER tgBrandUpdate ON dbo.Brand AFTER UPDATE
AS

	DECLARE @id INT
	DECLARE @xml XML

	SELECT @id = id 
	FROM deleted

	SELECT @xml = (
		SELECT * 
		FROM deleted
		FOR XML AUTO
	)

	INSERT INTO dbo._ChangeLog (SourceTable, SourceRecordId, SourceRecord) 
	VALUES ('Brand', @id, @xml);
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
--- CONFIG HEADER
CREATE TABLE dbo.ConfigHeader (
	
	Id INT IDENTITY(1,1)

	, Active BIT NOT NULL 
		DEFAULT 1
	, CreateDate DATETIME NOT NULL 
		DEFAULT GETDATE()
	
	, UserId INT NOT NULL
	, UniqueId NVARCHAR(100) NOT NULL
	, ConfigName NVARCHAR(100) NOT NULL
	, Notes NVARCHAR(500) NULL
	, ConfigType NVARCHAR(50) NOT NULL

	, CONSTRAINT PK_ConfigHeader 
		PRIMARY KEY (Id)
	, CONSTRAINT FK_ConfigHeader_User 
		FOREIGN KEY (UserId) 
		REFERENCES dbo._Users(IdNum)

)
GO

CREATE NONCLUSTERED INDEX IX_ConfigHeader ON dbo.ConfigHeader (
	UserId
)
GO

CREATE TRIGGER tgConfigHeaderUpdate ON dbo.ConfigHeader AFTER UPDATE
AS
	DECLARE @id INT
	DECLARE @xml XML

	SELECT @id = id 
	FROM deleted

	SELECT @xml = (
		SELECT * 
		FROM deleted
		FOR XML AUTO
	)

	INSERT INTO dbo._ChangeLog (SourceTable, SourceRecordId, SourceRecord) VALUES ('ConfigHeader', @id, @xml);
GO

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
	, Quantity SMALLINT NOT NULL DEFAULT 1
	, Notes NVARCHAR(100) NULL
	, IsRequired BIT NOT NULL

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

CREATE TRIGGER tgConfigDetailUpdate ON dbo.ConfigDetail AFTER UPDATE
AS
	DECLARE @id INT
	DECLARE @xml XML

	SELECT @id = id 
	FROM deleted

	SELECT @xml = (
		SELECT * 
		FROM deleted
		FOR XML AUTO
	)

	INSERT INTO dbo._ChangeLog (SourceTable, SourceRecordId, SourceRecord) VALUES ('ConfigDetail', @id, @xml);
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
	, ConfigHeaderId INT NULL

	, BrandId INT NULL
	, ItemName NVARCHAR(100) NOT NULL
	, ItemDesc NVARCHAR(2000) NULL
	
	, [Url] NVARCHAR(200) NULL
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
	, CONSTRAINT FK_Item_ConfigHeader 
		FOREIGN KEY (ConfigHeaderId) 
		REFERENCES ConfigHeader(Id)
)
GO

CREATE NONCLUSTERED INDEX IX_Item ON dbo.Item (
	UniqueId
	, ParentId
	, BrandId
)
GO

CREATE TRIGGER tgItemUpdate ON dbo.Item AFTER UPDATE
AS
	DECLARE @id INT
	DECLARE @xml XML

	SELECT @id = id 
	FROM deleted

	SELECT @xml = (
		SELECT * 
		FROM deleted
		FOR XML AUTO
	)

	INSERT INTO dbo._ChangeLog (SourceTable, SourceRecordId, SourceRecord) VALUES ('Item', @id, @xml);
GO


------------------------
--- BUILD HEADER
CREATE TABLE dbo.BuildHeader (
	
	Id INT IDENTITY(1,1)

	, Active BIT NOT NULL 
		DEFAULT 1
	, CreateDate DATETIME NOT NULL 
		DEFAULT GETDATE()

	, UserId INT NOT NULL
	, UniqueId NVARCHAR(100) NOT NULL
	, BuildName NVARCHAR(100) NOT NULL
	, Notes NVARCHAR(500) NULL
	, BuilderEmail NVARCHAR(100) NOT NULL
	, BuildExtUrl NVARCHAR(200) NULL

	, CONSTRAINT PK_BuildHeader 
		PRIMARY KEY (Id)
	, CONSTRAINT FK_BuildHeader_User 
		FOREIGN KEY (UserId) 
		REFERENCES dbo._Users(IdNum)
)
GO

CREATE NONCLUSTERED INDEX IX_BuildHeader ON dbo.BuildHeader (
	UniqueId
)
GO

CREATE TRIGGER tgBuildHeaderUpdate ON dbo.BuildHeader AFTER UPDATE
AS
	DECLARE @id INT
	DECLARE @xml XML

	SELECT @id = id 
	FROM deleted

	SELECT @xml = (
		SELECT * 
		FROM deleted
		FOR XML AUTO
	)

	INSERT INTO dbo._ChangeLog (SourceTable, SourceRecordId, SourceRecord) VALUES ('BuildHeader', @id, @xml);
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

	, ItemName NVARCHAR(100) NULL
	, ItemDescription NVARCHAR(500) NULL

	, Url NVARCHAR(200) NULL

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

CREATE TRIGGER tgBuildDetailUpdate ON dbo.BuildDetail AFTER UPDATE
AS
	DECLARE @id INT
	DECLARE @xml XML

	SELECT @id = id 
	FROM deleted

	SELECT @xml = (
		SELECT * 
		FROM deleted
		FOR XML AUTO
	)

	INSERT INTO dbo._ChangeLog (SourceTable, SourceRecordId, SourceRecord) VALUES ('BuildDetail', @id, @xml);
GO

------------------------
--- COMPATIBILITY HEADER
CREATE TABLE dbo.CompatHeader (
	
	Id INT IDENTITY(1,1)

	, Active BIT NOT NULL 
		DEFAULT 1
	, CreateDate DATETIME NOT NULL 
		DEFAULT GETDATE()

	, UserId INT NOT NULL
	, UniqueId NVARCHAR(100) NOT NULL
	, CompatName NVARCHAR(100) NOT NULL
	, Notes NVARCHAR(500) NULL

	, CONSTRAINT PK_CompatHeader 
		PRIMARY KEY (Id)
	, CONSTRAINT FK_CompatHeader_User 
		FOREIGN KEY (UserId) 
		REFERENCES dbo._Users(IdNum)
)
GO

CREATE NONCLUSTERED INDEX IX_CompatHeader ON dbo.CompatHeader (
	UserId,
	UniqueId
)
GO

CREATE TRIGGER tgCompatHeaderUpdate ON dbo.CompatHeader AFTER UPDATE
AS
	DECLARE @id INT
	DECLARE @xml XML

	SELECT @id = id 
	FROM deleted

	SELECT @xml = (
		SELECT * 
		FROM deleted
		FOR XML AUTO
	)
	INSERT INTO dbo._ChangeLog (SourceTable, SourceRecordId, SourceRecord) VALUES ('CompatHeader', @id, @xml);

GO

------------------------
--- COMPATIBILITY DETAIL
CREATE TABLE dbo.CompatDetail (
	
	Id INT IDENTITY(1,1)

	, Active BIT NOT NULL 
		DEFAULT 1
	, CreateDate DATETIME NOT NULL 
		DEFAULT GETDATE()

	, CompatHeaderId INT NOT NULL
	, ItemId INT NOT NULL

	, ItemName NVARCHAR(100) NULL
	, ItemDescription NVARCHAR(500) NULL

	, Url NVARCHAR(200) NULL

	, CONSTRAINT PK_CompatDetail 
		PRIMARY KEY (Id)
	, CONSTRAINT FK_CompatDetail_CompatHeader
		FOREIGN KEY (CompatHeaderId) 
		REFERENCES CompatHeader(Id)
	, CONSTRAINT FK_CompatDetail_Item
		FOREIGN KEY (ItemId) 
		REFERENCES Item(Id)
)
GO

CREATE NONCLUSTERED INDEX IX_CompatDetail ON dbo.CompatDetail (
	CompatHeaderId
	, ItemId
)
GO

CREATE TRIGGER tgCompatDetailUpdate ON dbo.CompatDetail AFTER UPDATE
AS
	DECLARE @id INT
	DECLARE @xml XML

	SELECT @id = id 
	FROM deleted

	SELECT @xml = (
		SELECT * 
		FROM deleted
		FOR XML AUTO
	)

	INSERT INTO dbo._ChangeLog (SourceTable, SourceRecordId, SourceRecord) VALUES ('Compat', @id, @xml);
GO

CREATE VIEW vConfig AS 
select ch.Id ConfigId
	, ch.UniqueId ConfigUniqueId

	, ch.ConfigName
	, ch.ConfigType
	, cd.Id ConfigDetailId
	, cd.IsRequired
	, cat.CatGroupId
	, cat.CatGroup
	, cat.Id CategoryId
	, cat.Category
from ConfigHeader ch
	join ConfigDetail cd
		on cd.ConfigHeaderId = ch.Id	
	join (
		select 
			parent.Id CatGroupId,
			parent.Category CatGroup,
			child.Id,
			child.Category
		from Category child
			join Category parent
				on child.ParentId = parent.Id	
	) cat
		on cd.CategoryId = cat.Id
go

CREATE VIEW vItems AS 
select 
	i.Id ItemId,
	b.Id BrandId,
	b.BrandName,
	c.Id CategorId,
	c.Category,

	i.ItemName,
	i.ItemDesc,
	i.Url,
	i.Price
from dbo.Item i
	join dbo.Category c
		on i.CategoryId = c.Id
	join dbo.Brand b
		on i.BrandId = b.Id
go

CREATE VIEW dbo.vCompat
as
select 
	ch.Id CompatHeaderId
	, ch.CompatName
	, ch.UniqueId
	, ch.UserId
	, i.ItemId
	, i.BrandId
	, i.BrandName
	, i.CategorId
	, i.Category
	, i.ItemName
	, i.ItemDesc
	, i.Url
	, i.Price
from CompatHeader ch
	join CompatDetail cd
		on cd.CompatHeaderId = ch.Id
	join vItems i
		on cd.ItemId = i.ItemId
go