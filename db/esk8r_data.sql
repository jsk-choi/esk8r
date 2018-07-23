INSERT INTO dbo.Category (ParentId, Category, UserId) VALUES 
(NULL,	'DriveTrain',1),
(NULL,	'Accessory',1),
(NULL,	'Chassis',1),
(NULL,	'Electric',1),
(1,		'Wheels',1),
(1,		'Trucks',1),
(1,		'Mount',1),
(1,		'MotorPulley',1),
(1,		'WheelPulley',1),
(2,		'Lights',1),
(2,		'PulleyCover',1),
(2,		'Hardware',1),
(3,		'Deck',1),
(3,		'Enclosure',1),
(3,		'X-Thing',1),
(4,		'Battery',1),
(16,	'NickelStrip',1),
(4,		'Motor',1),
(4,		'HubMotor',1),
(4,		'ESC',1),
(4,		'Remote',1),
(4,		'BMS',1),
(4,		'Charger',1),
(4,		'Bluetooth',1);

INSERT INTO dbo.Brand (OwnerUserId, CreatedByUserId, UniqueId, BrandName, Url) VALUES 
(null, 1, '[generic]','[generic]', ''),
(1,    1, 'esk8life', 'esk8life', 'esk8life.com'),
(null, 1, 'besTech',  'BesTech', 'bestechpower.com'),
(null, 1, 'caliber',  'Caliber', 'calibertruckco.com'),
(null, 1, 'torqueboards',  'Torque Boards', 'diyelectricskateboard.com'),
(null, 1, 'enertion',  'Enertion', 'enertion.com');

INSERT INTO dbo.Item (UniqueId, ParentId, CategoryId, BrandId, ItemName, ItemDesc, Url, Price) VALUES 
('bms-d140-10s', null, 22, 3, 'BesTech HCX-D140 BMS - 10s', '', '', 30),
('bms-d140-12s', null, 22, 3, 'BesTech HCX-D140 BMS - 12s', '', '', 31),
('2.4ghz-mini-remote', null, 21, 1, '2.4Ghz Mini Remote',   '', '', 19),
('nickel-strip-10x0.15x10ft', null, 17, 1, 'Nickel Strip - 10mm x .15mm x 10ft', '', '', 9),
('enertion-36t-12mm-pulley', null, 9, 6, 'Enertion 36t 12mm Wheel Pulley', '', '', 14),
('218mm-trucks', null, 6, 5, '218mm Trucks', '', '', 65),
('caliber-ii-trucks', null, 6, 4, 'Caliber II Trucks', '', '', 40),
('enertion-mount-clone', null, 7, 1, 'Enertion Mount Clone', '', '', 40);

INSERT INTO dbo.ConfigHeader(UserId, UniqueId, ConfigName, ConfigType) VALUES 
(1, 'mono-drive', 'Mono Drive', 'Build'),
(1, 'dual-drive', 'Dual Drive', 'Build'),
(1, 'carvon-drive', 'Carvon Drive', 'Component');

INSERT INTO dbo.ConfigDetail(ConfigHeaderId, CategoryId, IsRequired) VALUES 
(1,5,1), (1,6,1), (1,7,1), (1,8,1),
(1,9,1), (1,13,0), (1,14,1), (1,16,1),
(1,18,1), (1,20,1), (1,21,1), (1,23,1),
(2,5,1), (2,6,1), (2,7,1), (2,7,1),
(2,8,1), (2,8,1), (2,9,1), (2,9,1),
(2,13,1), (2,14,1), (2,16,1), (2,18,1),
(2,18,1), (2,20,1), (2,20,1), (2,23,0),
(3,6,1), (3,7,1), (3,7,1), (3,8,1),
(3,8,1), (3,9,1), (3,9,1), (3,18,1),
(3,18,1), (2,21,1);

INSERT INTO dbo.CompatHeader(UserId, UniqueId, CompatName) VALUES 
(1, 'caliber-ii-trucks', 'Caliber ii Trucks'),
(1, 'tb-218mm-trucks', 'TorqueBoards 218mm Trucks');

INSERT INTO dbo.CompatDetail(CompatHeaderId, ItemId) VALUES 
(1, 6), (1, 7), (1, 8), (2, 6), (2, 5);



--select * from ConfigHeader

--select * from Category
--select * from Brand
--select * from Item

--select * from BuildHeader
--select * from BuildDetail

--select * from ConfigHeader
--select * from ConfigDetail

----select * from _ChangeLog

--sp_spaceused '_ChangeLog'

