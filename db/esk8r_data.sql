INSERT INTO dbo.Category (ParentId, Category, UserId) VALUES 
(NULL, 'Drive Train', 1),
(1,    'Wheels', 1),
(1,    'Trucks', 1),
(1,    'Mount', 1),
(1,    'Pulleys', 1),
(1,    'Pulleys', 1),
(NULL, 'Accessory', 1),
(6,    'Lights', 1),
(6,    'Pulley Cover', 1),
(6,    'Hardware', 1),
(NULL, 'Chassis', 1),
(11,   'Deck', 1),
(11,   'Enclosure', 1),
(11,    'X-Thing', 1),
(NULL, 'Electric', 1),
(15,   'Motor', 1),
(15,   'ESC', 1),
(15,   'Remote', 1),
(15,   'Battery', 1),
(15,   'BMS', 1),
(15,   'Charger', 1),
(15,   'Bluetooth', 1),
(19,   'Nickel Strip', 1);

INSERT INTO dbo.Brand (OwnerUserId, CreatedByUserId, UniqueId, BrandName, Url) VALUES 
(1, 1, 'esk8life', 'esk8life', 'esk8life.com'),
(null, 1, 'BesTech', 'BesTech', 'bestechpower.com'),
(null, 1, '[Generic]', '[Generic]', '');

INSERT INTO dbo.Item (UniqueId, ParentId, CategoryId, BrandId, ItemName, ItemDesc, Url, Price) VALUES 
('bms-d140-10s', null, 20, 2, 'BesTech HCX-D140 BMS - 10s', '', '', 30),
('bms-d140-12s', null, 20, 2, 'BesTech HCX-D140 BMS - 12s', '', '', 31),
('2.4ghz-mini-remote', null, 18, 3, '2.4Ghz Mini Remote',   '', '', 19),
('nickel-strip-10x0.15x10ft', null, 23, 3, 'Nickel Strip - 10mm x .15mm x 10ft', '', '', 9);

--select * from Category