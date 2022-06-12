SPOOL project.txt 
SET ECHO ON 
/* 
CIS 353 - Database Design Project 
Austin Ackermann
Ethan Grant
Thanh Tran
Ben Ziegler
*/ 
CREATE TABLE Customers
(
customerID INTEGER PRIMARY KEY,
firstName CHAR(15) NOT NULL,
lastName CHAR(15) NOT NULL,
address CHAR(50) NOT NULL,
phone CHAR(25),
email CHAR(50),
--
-- Integrity Constraints
--
-- custIDLen: Customer IDs are 6 digits long
CONSTRAINT custIDLen CHECK ((customerID >= 100000) AND (customerID <= 999999)),
--
-- custPhoneSyntax: Phone numbers are of the form (xxx) xxx-xxxx
CONSTRAINT custPhoneSyntax CHECK (phone LIKE '(%)%-%'),
--
-- custEmailSyntax: Emails are of the form xxx@xxx.xxx (ex: someguy123@mymail.net)
CONSTRAINT custEmailSyntax CHECK (email LIKE '%@%.%')
);
-- -----------------------------------------------------------------------------------
CREATE TABLE Stores
(
storeNum INTEGER PRIMARY KEY,
address CHAR(50) NOT NULL,
district CHAR(50) NOT NULL,
region CHAR(50) NOT NULL,
storeSize CHAR(20) NOT NULL,
--
-- Integrity Constraints
--
-- storeDistRegion: Store districts and regions must belong to one another. 
-- (note: There are 3 regions, each with 3 districts in them. D1-1 belongs to R1, D2-1 to R2, D3-1 to R3 etc.)
CONSTRAINT storeDistRegion CHECK
((region IN ('R1') AND district IN ('D1-1', 'D1-2', 'D1-3')) OR (region IN ('R2') AND district IN ('D2-1', 'D2-2', 'D2-3')) OR
(region IN ('R3') AND district IN ('D3-1', 'D3-2', 'D3-3'))),
--
-- properStoreSize: Store sizes must be small, medium, or large
CONSTRAINT properStoreSize CHECK (storeSize IN ('small', 'medium', 'large'))
);
-- -----------------------------------------------------------------------------------
CREATE TABLE Items (
serialNum INTEGER PRIMARY KEY,
description CHAR(1000) NOT NULL,
name CHAR(255) NOT NULL,
rentalRate CHAR(15) NOT NULL,
--
-- Integrity Constraints
--
-- itemSerialLen: Item serial numbers are 6 digits long
CONSTRAINT itemSerialLen CHECK ((serialNum >= 100000) AND (serialNum <= 999999))
);
-- -----------------------------------------------------------------------------------
CREATE TABLE Orders (
orderNum INTEGER PRIMARY KEY,
orderDate CHAR(15) NOT NULL,
lineID INTEGER NOT NULL,
managerID INTEGER NOT NULL,
--
-- Integrity Constraints
--
-- orderNumLen: Order numbers are 6 digits long
CONSTRAINT orderNumLen CHECK ((orderNum >= 100000) AND (orderNum <= 999999)),
--
-- orderDateSyntax: Order dates are of the form mm/dd/yyyy (ex: 01/01/2000)
CONSTRAINT orderDateSyntax CHECK (orderDate LIKE '%/%/%')
);
-- -----------------------------------------------------------------------------------
CREATE TABLE Managers (
managerID INTEGER PRIMARY KEY,
firstName CHAR(15) NOT NULL,
lastName CHAR(15) NOT NULL,
gender CHAR(25) NOT NULL,
age INTEGER NOT NULL,
phone CHAR(25) NOT NULL,
role CHAR(25) NOT NULL,
--
-- Integrity Constraints
--
-- managerIDLen: Manager IDs are 6 digits long
CONSTRAINT managerIDLen CHECK ((managerID >= 100000) AND (managerID <= 999999)),
--
-- managerPhoneSyntax: Phone numbers are of the form (xxx) xxx-xxxx
CONSTRAINT managerPhoneSyntax CHECK (phone LIKE '(%)%-%'),
--
-- managerRole: Manager roles must be 'general', 'district', or 'regional'
CONSTRAINT managerRole CHECK (role IN ('general', 'district', 'regional')),
--
-- managerAge: Managers must be at least 20 years old, 25 if they are district, and 30 years for regional.
CONSTRAINT managerAge CHECK ((age > 20 AND role = 'general') OR (age > 25 AND role = 'district') OR (age > 30 AND role = 'regional'))
);
--
-- orderManagerIDFK: managerID is a foreign key that references Managers managerID
ALTER TABLE Orders ADD CONSTRAINT orderManagerIDFK FOREIGN KEY (managerID) REFERENCES Managers(managerID)
ON DELETE CASCADE;
--
-- -----------------------------------------------------------------------------------
CREATE TABLE Employees (
employeeID INTEGER PRIMARY KEY,
firstName CHAR(25) NOT NULL,
lastName CHAR(15) NOT NULL,
gender CHAR(25) NOT NULL,
age INTEGER NOT NULL,
phone CHAR(25) NOT NULL,
storeNum INTEGER NOT NULL,
--
-- Integrity Constraints
--
-- employeeIDLen: Employee IDs are 6 digits long
CONSTRAINT employeeIDLen CHECK ((employeeID >= 100000) AND (employeeID <= 999999)),
--
-- employeePhoneSyntax: Phone numbers are of the form (xxx) xxx-xxxx
CONSTRAINT employeePhoneSyntax CHECK (phone LIKE '(%)%-%'),
--
-- employeeStoreFK: Store numbers are foreign keys that reference Stores(storeNum)
CONSTRAINT employeeStoreFK FOREIGN KEY (storeNum) REFERENCES Stores(storeNum)
ON DELETE CASCADE
);
-- -----------------------------------------------------------------------------------
CREATE TABLE OrderLines (
lineID INTEGER NOT NULL,
orderNum INTEGER NOT NULL,
itemOrdered INTEGER NOT NULL,
qty INTEGER NOT NULL,
storeNum INTEGER NOT NULL,
shipmentType CHAR(25) NOT NULL,
price CHAR(15) NOT NULL,
daysToShip INTEGER NOT NULL,
--
-- Integrity Constraints
--
-- orderLineCK: OrderLines have a composite key of both the lineID and the orderNum
CONSTRAINT orderLineCK PRIMARY KEY (lineID, orderNum),
--
-- orderLineIDLen: Order Line IDs are 6 digits long
CONSTRAINT orderLineIDLen CHECK ((lineID >= 100000) AND (lineID <= 999999)),
--
-- orderLineOrderFK: orderNum is a foreign key that references Orders(orderNum)
CONSTRAINT orderLineOrderFK FOREIGN KEY (orderNum) REFERENCES Orders (orderNum)
ON DELETE CASCADE,
--
-- orderLineItemNameFK: itemOrdered is a foreign key that references Items(serialNum)
CONSTRAINT orderLineItemNameFK FOREIGN KEY (itemOrdered) REFERENCES Items(serialNum)
ON DELETE CASCADE,
--
-- orderLineQty: qty is greater than 0
CONSTRAINT orderLineQty CHECK (qty > 0),
--
-- orderLineStoreFK: storeNum is a foreign key that references Stores(storeNum)
CONSTRAINT orderLineStoreFK FOREIGN KEY (storeNum) REFERENCES Stores(storeNum)
ON DELETE CASCADE,
--
-- orderLineShipmentType: shipmentType must be 'regular', 'express', or 'same-day'
CONSTRAINT orderLineShipmentType CHECK (shipmentType IN ('regular', 'express', 'same-day')),
--
-- orderLinePriceSyntax: OrderLine costs are of the form $x.xx (ex: $5.99, $375.55, etc)
CONSTRAINT orderLinePriceSyntax CHECK (price LIKE '$%.%'),
--
-- orderLineShipmentTime: Different shipment types have differing amounts of shipping time (regular: 5+ days, express: 3 days, same-day: 1 day)
--
CONSTRAINT orderLineShipmentTime
CHECK ((shipmentType = 'regular' AND daysToShip >= 5) 	OR 
(shipmentType = 'express' AND daysToShip = 3) 	OR 
(shipmentType = 'same-day' AND daysToShip = 1))
);
--
-- -----------------------------------------------------------------------------------
CREATE TABLE StorePhone (
storeNum PRIMARY KEY,
phone CHAR(25) NOT NULL,
--
-- Integrity Constraints
--
--
-- storePhoneSyntax: Phone numbers are of the form (xxx) xxx-xxxx
CONSTRAINT storePhoneSyntax CHECK (phone LIKE '(%)%-%'),
--
-- storePhoneStoreNumFK: storeNum is a foreign key the references Stores(storeNum)
CONSTRAINT phoneStoreNumFK FOREIGN KEY (storeNum) REFERENCES Stores(storeNum)
ON DELETE CASCADE
);
-- -----------------------------------------------------------------------------------
CREATE TABLE ItemPrices (
serialNum NOT NULL,
price CHAR(15) NOT NULL,
--
-- Integrity Constraints
--
-- itemPriceCK: The primary key is a composite of both the serial num and the price
CONSTRAINT itemPriceCK PRIMARY KEY (serialNum, price),
--
-- itemPricesSerialNumFK: serialNum is a foreign key that references Items(serialNum)
CONSTRAINT itemPriceSerialNumFK FOREIGN KEY (serialNum) REFERENCES Items(serialNum)
ON DELETE CASCADE
);
-- -----------------------------------------------------------------------------------
CREATE TABLE GoesTo (
customerID INTEGER,
storeNum INTEGER,
itemPurchased INTEGER NOT NULL,
quantity INTEGER,
orderedOnline CHAR(15) NOT NULL,
--
-- Integrity Constraints
--
-- goesToCK: GoesTo has a composite key of the customerID, the storeNum, and the item purchased
CONSTRAINT goesToCK PRIMARY KEY (customerID, storeNum, itemPurchased),
--
-- goesToCustomerIDFK: customerID is a foreign key that references Customers(customerID)
CONSTRAINT goesToCustomerIDFK FOREIGN KEY (customerID) REFERENCES Customers(customerID)
ON DELETE CASCADE,
--
-- goesToStoreNumFK: storeNum is a foreign key that references Stores(storeNum)
CONSTRAINT goesToStoreNumFK FOREIGN KEY (storeNum) REFERENCES Stores(storeNum)
ON DELETE CASCADE,
--
-- goesToItemPurchasedFK: itemPurchased is a foreign key that references Items(name)
CONSTRAINT itemPurchased FOREIGN KEY (itemPurchased) REFERENCES Items(serialNum)
ON DELETE CASCADE,
--
-- goesToQuantity: quantity is greater than 0
CONSTRAINT goesToQuantity CHECK (quantity > 0),
--
-- goesToOrderedOnline: orderedOnline is a boolean (it can only be 'true' or 'false')
CONSTRAINT goesToOrderedOnline CHECK (orderedOnline IN ('true', 'false'))
);
-- -----------------------------------------------------------------------------------
CREATE TABLE Has (
serialNum INTEGER,
lineID INTEGER,
--
-- Integrity Constraints
--
-- HasCK: Has has a composite key of both the serialNum and the lineID
CONSTRAINT HasCK PRIMARY KEY (serialNum, lineID),
--
-- hasSerialNumFK: serialNum is a foreign key that references Items(serialNum)
CONSTRAINT hasSerialNumFK FOREIGN KEY (serialNum) REFERENCES Items(serialNum)
);
-- -----------------------------------------------------------------------------------
CREATE TABLE Manages (
managerID INTEGER,
employeeID INTEGER,
--
-- Integrity Constraints
--
-- managesCK: Manages has a composite key of both the managerID and the employeeID
CONSTRAINT managesCK PRIMARY KEY (managerID, employeeID),
--
-- managesManagerIDFK: managerID is a forgeign key that references Managers(managerID)
CONSTRAINT managesManagerIDFK FOREIGN KEY (managerID) REFERENCES Managers(managerID),
--
-- managesEmployeeIDFK: employeeID is a foreign key that references Employees(employeeID)
CONSTRAINT managesEmployeeIDFK FOREIGN KEY (employeeID) REFERENCES Employees(employeeID)
);
-- -----------------------------------------------------------------------------------
INSERT INTO Customers VALUES (100000, 'Dave', 'Smith', '332 Michigan Ave.', '(555) 333-2222', 'dsmith@gmail.com');
INSERT INTO Customers VALUES (100001, 'Joe', 'Smith', '324 Niles Ave.', '(555) 444-1111', 'jsmith@gmail.com');
INSERT INTO Customers VALUES (100002, 'Max', 'Albon', '443 Lakeshore Dr.', '(555) 543-2353', 'malbon@gmail.com');
INSERT INTO Customers VALUES (100003, 'Liv', 'Reeves', '3321 Lincoln Ave.', '(555) 876-0966', 'lreeves@gmail.com');
INSERT INTO Customers VALUES (100004, 'Bill', 'Guy', '987 Niles Ave.', NULL, NULL);
INSERT INTO Customers VALUES (100005, 'Justin', 'Smith', '312 Lakeshore Ave.', '(555) 777-4545', NULL);
INSERT INTO Customers VALUES (100006, 'Ryan', 'Mercer', '1543 2nd St.', '(555) 652-7777', 'rmercer@gmail.com');
INSERT INTO Customers VALUES (100007, 'Jack', 'Batler', '3112 6th St.', '(555) 888-8272', NULL);
INSERT INTO Customers VALUES (100008, 'Peyton', 'Handy', '3262 Bush Dr.', '(555) 545-7828', 'phandy@gmail.com');
INSERT INTO Customers VALUES (100009, 'Jo', 'Reeves', '3001 10th St.', NULL, 'jreeves@gmail.com');
INSERT INTO Customers VALUES (100010, 'Bo', 'Term', '1872 Bush Dr.', NULL, NULL);
INSERT INTO Customers VALUES (100011, 'Nate', 'Boon', '884 Michigan Ave.', '(555) 000-5050', NULL);
INSERT INTO Customers VALUES (100012, 'Kim', 'Palhamus', '4112 Lincoln Ave.', '(555) 450-4504', 'kpalhamus@gmail.com');
INSERT INTO Customers VALUES (100013, 'Troy', 'Jones', '112 Michigan Ave.', '(555) 955-4222', 'tjones@gmail.com');
INSERT INTO Customers VALUES (100014, 'Vic', 'Brown', '394 Lakeshore Dr.', '(555) 564-4547', 'vbrown@gmail.com');
INSERT INTO Customers VALUES (100015, 'Olivia', 'Ruth', '1165 Lincoln Ave.', '(555) 840-0875', 'oruth@gmail.com');
INSERT INTO Customers VALUES (100016, 'John', 'Babalon', '3920 16th St.', NULL, NULL);
INSERT INTO Customers VALUES (100017, 'Jon', 'Smith', '2316 Obama Dr.', NULL, NULL);
INSERT INTO Customers VALUES (100018, 'Frank', 'Gulag', '2562 Bush Dr.', '(555) 684-7782', 'fgulag@gmail.com');
INSERT INTO Customers VALUES (100019, 'Kevin', 'Miller', '2919 7th Ave.', '(555) 457-7747', 'kmiller@gmail.com');
INSERT INTO Customers VALUES (100020, 'Tina', 'Vaught', '622 Michigan Ave.', '(555) 754-7796', NULL);
INSERT INTO Customers VALUES (100021, 'Charlie', 'Jones', '5841 1st St.', '(555) 993-9687', 'cjones@gmail.com');
INSERT INTO Customers VALUES (100022, 'Ignus', 'Victus', '855 Niles Ave.', '(555) 378-7875', 'ivictus@gmail.com');
INSERT INTO Customers VALUES (100023, 'Myles', 'Tillery', '6552 14th St.', '(555) 778-6642', 'mtillery@gmail.com');
INSERT INTO Customers VALUES (100024, 'Izak', 'Ruddell', '2826 Bush Dr.', NULL, NULL);
INSERT INTO Customers VALUES (100025, 'Ryan', 'Haynes', '2584 15th St.', '(555) 877-4455', 'rhaynes@gmail.com');
--------------------------------------------------------------------------------------
INSERT INTO Stores VALUES (100000, '555 Michigan Ave.', 'D1-1', 'R1', 'large');
INSERT INTO Stores VALUES (100001, '3232 Lincoln Ave.', 'D3-1', 'R3', 'medium');
INSERT INTO Stores VALUES (100002, '423 Lakeshore Dr.', 'D1-2', 'R1', 'medium');
INSERT INTO Stores VALUES (100003, '3344 1st St.', 'D2-2', 'R2', 'small');
INSERT INTO Stores VALUES (100004, '3333 16th St.', 'D2-1', 'R2', 'medium');
INSERT INTO Stores VALUES (100005, '7684 7th St.', 'D2-3', 'R2', 'medium');
INSERT INTO Stores VALUES (100006, '9090 Obama Dr.', 'D3-2', 'R3', 'small');
INSERT INTO Stores VALUES (100007, '1231 Bush Dr.', 'D3-3', 'R3', 'large');
INSERT INTO Stores VALUES (100008, '543 Niles Ave.', 'D1-3', 'R1', 'medium');
INSERT INTO Stores VALUES (100009, '123 River Ave.', 'D3-2', 'R3', 'large');
--------------------------------------------------------------------------------------
INSERT INTO Items VALUES (100000, 'A top of the line console from Microsoft, the XBOX: Series X boasts up to 120FPS and 4K visuals.', 'XBOX: Series X', '$9.99/mo');
INSERT INTO Items VALUES (100001, 'A superior gaming console from Microsoft, the XBOX: Series S is an all digital, lightweight console for avid gamers.', 'XBOX: Series S', '$10.99/mo');
INSERT INTO Items VALUES (200000, 'A top gaming console from Sony, the PlayStation 5 offers up to 120FPS, stunning visuals, and incredible performance.', 'PlayStation 5', '$9.99/mo');
INSERT INTO Items VALUES (300000, 'The newest and best console from Nintendo. The Nintendo Switch offers incredible exclusives you wont find anywhere else.', 'Nintendo Switch', '$9.99/mo');
INSERT INTO Items VALUES (300001, 'For on-the-go gamers, the Nintendo Switch Lite is a dedicated handheld console that you can take anywhere.', 'Nintendo Switch Lite', '$8.99/mo');
INSERT INTO Items VALUES (100002, 'Shooter game for XBOX.', 'Halo Infinite', '$4.99/mo');
INSERT INTO Items VALUES (100003, 'Shooter game for XBOX.', 'Call of Duty Vanguard: XBOX Version', '$4.99/mo');
INSERT INTO Items VALUES (100004, 'Shooter game for XBOX.', 'Battlefield 2042: XBOX Version', '$4.99/mo');
INSERT INTO Items VALUES (200001, 'Shooter game for PlayStation 5.', 'Call of Duty Vanguard: PlayStation 5 Version', '$4.99/mo');
INSERT INTO Items VALUES (200002, 'Shooter game for PlayStation 5.', 'Battlefield 2042: PlayStation 5 Version', '$4.99/mo');
INSERT INTO Items VALUES (200003, 'Action game for PlayStation 5.', 'God of War (2018)', '$4.99/mo');
INSERT INTO Items VALUES (300002, 'Catch Pokemon and battle with other trainers in Pokemon: Brilliant Diamond.', 'Pokemon: Brilliant Diamond', '$4.99/mo');
INSERT INTO Items VALUES (300003, 'Catch Pokemon and battle with other trainers in Pokemon: Shining Pearl.', 'Pokemon: Shining Pearl', '$4.99/mo');
INSERT INTO Items VALUES (300004, 'Race with friends, family, and players all around the world in the newest Mario Kart game, Mario Kart 8: Deluxe.', 'Mario Kart 8: Deluxe', '$4.99/mo');
INSERT INTO Items VALUES (100005, 'Controller compatible with XBOX: Series X, and XBOX: Series S', 'XBOX Controller (Basic)', '$2.99/mo');
INSERT INTO Items VALUES (100006, 'Premium controller for XBOX', 'XBOX Elite Controller', '$2.99/mo');
INSERT INTO Items VALUES (200004, 'Controller for PlayStation 5', 'PlayStation 5 Controller', '$2.99/mo');
INSERT INTO Items VALUES (200005, 'Premium controller for PlayStation 5', 'PlayStation 5 Scuff Controller', '$2.99/mo');
INSERT INTO Items VALUES (300005, 'Controller for Nintendo Switch', 'Joy-Con Controller Pack (Pack of 2)', '$2.99/mo');
--------------------------------------------------------------------------------------
INSERT INTO Managers VALUES (100000, 'Peyton', 'Bitfelt', 'M', '37', '(555) 732-8911', 'regional');
INSERT INTO Managers VALUES (100001, 'Jack', 'Butler', 'M', '45', '(555) 534-6645', 'regional');
INSERT INTO Managers VALUES (100002, 'John', 'Casey', 'M', '26', '(555) 886-7444', 'district');
INSERT INTO Managers VALUES (100003, 'Olivia', 'Stevens', 'F', '21', '(555) 654-9135', 'general');
INSERT INTO Managers VALUES (100004, 'Evan', 'Bradford', 'M', '32', '(555) 774-9053', 'district');
INSERT INTO Managers VALUES (100005, 'Nate', 'Dean', 'M', '43', '(555) 987-2288', 'district');
INSERT INTO Managers VALUES (100006, 'Ryan', 'Reeves', 'M', '31', '(555) 733-6868', 'general');
INSERT INTO Managers VALUES (100007, 'Erica', 'Baptist', 'F', '29', '(555) 228-0280', 'general');
INSERT INTO Managers VALUES (100008, 'Nate', 'Marsh', 'M', '35', '(555) 820-6130', 'regional');
--------------------------------------------------------------------------------------
INSERT INTO Orders VALUES (100000, '10/10/2021', 100000, 100006);
INSERT INTO Orders VALUES (100001, '10/11/2021', 100001, 100006);
INSERT INTO Orders VALUES (100002, '11/09/2021', 100002, 100007);
INSERT INTO Orders VALUES (100003, '11/12/2021', 100003, 100003);
INSERT INTO Orders VALUES (100004, '11/07/2021', 100004, 100005);
INSERT INTO Orders VALUES (100005, '10/23/2021', 100005, 100003);
INSERT INTO Orders VALUES (100006, '11/16/2021', 100006, 100007);
INSERT INTO Orders VALUES (100007, '11/19/2021', 100007, 100004);
INSERT INTO Orders VALUES (100008, '10/19/2021', 100008, 100002);
--------------------------------------------------------------------------------------
INSERT INTO Employees VALUES (200000, 'River', 'Johnson', 'F', '21', '(555) 815-6965', 100001);
INSERT INTO Employees VALUES (200001, 'Bob', 'Dean', 'M', '19', '(555) 833-9166', 100002);
INSERT INTO Employees VALUES (200002, 'Bill', 'Ruiz', 'M', '42', '(555) 453-2412', 100003);
INSERT INTO Employees VALUES (200003, 'Ryan', 'Baldwin', 'M', '32', '(555) 846-5545', 100001);
INSERT INTO Employees VALUES (200004, 'Danielle', 'Rickwood', 'F', '19', '(555) 456-6645', 100004);
INSERT INTO Employees VALUES (200005, 'Jill', 'Lauqus', 'F', '24', '(555) 864-6752', 100005);
INSERT INTO Employees VALUES (200006, 'Zach', 'Miller', 'M', '28', '(555) 465-0450', 100002);
INSERT INTO Employees VALUES (200007, 'Max', 'Miller', 'M', '31', '(555) 868-0785', 100006);
INSERT INTO Employees VALUES (200008, 'Josh', 'Johnson', 'M', '24', '(555) 870-4454', 100007);
INSERT INTO Employees VALUES (200009, 'Tom', 'Smith', 'M', '21', '(555) 564-6654', 100008);
INSERT INTO Employees VALUES (200010, 'Todd', 'Batson', 'M', '44', '(555) 786-0707', 100009);
INSERT INTO Employees VALUES (200011, 'Summer', 'Smith', 'F', '31', '(555) 868-0078', 100008);
INSERT INTO Employees VALUES (200012, 'Pat', 'Miller', 'M', '46', '(555) 087-6680', 100001);
INSERT INTO Employees VALUES (200013, 'Sean', 'Hitchcock', 'M', '39', '(555) 770-8875', 100008);
INSERT INTO Employees VALUES (200014, 'Mark', 'Dean', 'M', '20', '(555) 857-7577', 100003);
INSERT INTO Employees VALUES (200015, 'Avery', 'Ricktus', 'F', '30', '(555) 312-8785', 100005);
INSERT INTO Employees VALUES (200016, 'Eric', 'Shellhorn', 'M', '34', '(555) 045-5466', 100006);
INSERT INTO Employees VALUES (200017, 'Evan', 'Acker', 'M', '25', '(555) 867-5678', 100009);
INSERT INTO Employees VALUES (200018, 'Rick', 'Doty', 'M', '18', '(555) 546-6422', 100001);
INSERT INTO Employees VALUES (200019, 'Morty', 'Johnson', 'M', '19', '(555) 789-6456', 100008);
INSERT INTO Employees VALUES (200020, 'Jen', 'Dipkey', 'F', '22', '(555) 444-4645', 100004);
INSERT INTO Employees VALUES (200021, 'Troy', 'Bell', 'M', '36', '(555) 678-6451', 100005);
--------------------------------------------------------------------------------------
INSERT INTO OrderLines VALUES (100000, 100000, 200000, 1, 100001, 'same-day', '$599.99', 1);
INSERT INTO OrderLines VALUES (100001, 100001, 100000, 1, 100005, 'express', '$1799.97', 3);
INSERT INTO OrderLines VALUES (100002, 100002, 300000, 1, 100008, 'same-day', '$299.99', 1);
INSERT INTO OrderLines VALUES (100003, 100003, 100006, 2, 100002, 'regular', '$259.98', 5);
INSERT INTO OrderLines VALUES (100004, 100004, 100002, 1, 100006, 'express', '$179.97', 3);
INSERT INTO OrderLines VALUES (100005, 100005, 300005, 4, 100002, 'same-day', '$79.99', 1);
INSERT INTO OrderLines VALUES (100006, 100006, 300004, 1, 100009, 'regular', '$299.95', 5);
INSERT INTO OrderLines VALUES (100007, 100007, 200005, 1, 100002, 'express', '$199.98', 3);
INSERT INTO OrderLines VALUES (100008, 100008, 200002, 1, 100007, 'regular', '$299.95', 5);
--------------------------------------------------------------------------------------
INSERT INTO StorePhone VALUES (100001, '(555) 673-9902');
INSERT INTO StorePhone VALUES (100002, '(555) 445-4534');
INSERT INTO StorePhone VALUES (100003, '(555) 673-4322');
INSERT INTO StorePhone VALUES (100004, '(555) 999-3321');
INSERT INTO StorePhone VALUES (100005, '(555) 999-6685');
INSERT INTO StorePhone VALUES (100006, '(555) 999-7774');
INSERT INTO StorePhone VALUES (100007, '(555) 445-6653');
INSERT INTO StorePhone VALUES (100008, '(555) 445-0089');
INSERT INTO StorePhone VALUES (100009, '(555) 673-6598');
--------------------------------------------------------------------------------------
-- XBOX: Series X retail
INSERT INTO ItemPrices VALUES (100000, '$599.99');
-- XBOX: Series X discount
INSERT INTO ItemPrices VALUES (100000, '$499.99');
--
-- XBOX: Series S retail
INSERT INTO ItemPrices VALUES (100001, '$299.99');
-- XBOX: Series S discount
INSERT INTO ItemPrices VALUES (100001, '$249.99');
--
-- Halo Infinite retail
INSERT INTO ItemPrices VALUES (100002, '$59.99');
-- Halo Infinite discount
INSERT INTO ItemPrices VALUES (100002, '$39.99');
--
-- Call of Duty Vanguard: XBOX Version retail
INSERT INTO ItemPrices VALUES (100003, '$59.99');
-- Call of Duty Vanguard: XBOX Version discount
INSERT INTO ItemPrices VALUES (100003, '$39.99');
--
-- Battlefield 2042: XBOX Version retail
INSERT INTO ItemPrices VALUES (100004, '$59.99');
-- Battlefield 2042: XBOX Version discount
INSERT INTO ItemPrices VALUES (100004, '$39.99');
--
-- XBOX Controller (Basic) retail
INSERT INTO ItemPrices VALUES (100005, '$59.99');
-- XBOX Controller (Basic) discount
INSERT INTO ItemPrices VALUES (100005, '$39.99');
-- 
-- XBOX Elite Controller retail
INSERT INTO ItemPrices VALUES (100006, '$129.99');
-- XBOX Elite Controller discount
INSERT INTO ItemPrices VALUES (100006, '$89.99');
-- 
-- PlayStation 5 retail
INSERT INTO ItemPrices VALUES (200000, '$599.99');
-- PlayStation 5 discoun
INSERT INTO ItemPrices VALUES (200000, '$499.99');
-- 
-- Call of Duty Vanguard: PlayStation Version retail
INSERT INTO ItemPrices VALUES (200001, '$59.99');
-- Call of Duty Vanguard: PlayStation Version discount
INSERT INTO ItemPrices VALUES (200001, '$39.99');
-- 
-- Battlefield 2042: PlayStation Version retail
INSERT INTO ItemPrices VALUES (200002, '$59.99');
-- Battlefield 2042: PlayStation Version discount
INSERT INTO ItemPrices VALUES (200002, '$39.99');
-- 
-- God of War (2018) retail
INSERT INTO ItemPrices VALUES (200003, '$59.99');
-- God of War (2018) discount
INSERT INTO ItemPrices VALUES (200003, '$39.99');
-- 
-- PlayStation 5 Controller retail
INSERT INTO ItemPrices VALUES (200004, '$59.99');
-- PlayStation 5 Controller discount
INSERT INTO ItemPrices VALUES (200004, '$39.99');
-- 
-- PlayStation 5 Scuff Controller retail
INSERT INTO ItemPrices VALUES (200005, '$99.99');
-- PlayStation 5 Scuff Controller discount
INSERT INTO ItemPrices VALUES (200005, '$69.99');
-- 
-- Nintendo Switch retail
INSERT INTO ItemPrices VALUES (300000, '$299.99');
-- Nintendo Switch discount
INSERT INTO ItemPrices VALUES (300000, '$229.99');
-- 
-- Nintendo Switch Lite retail
INSERT INTO ItemPrices VALUES (300001, '$199.99');
-- Nintendo Switch Lite discount
INSERT INTO ItemPrices VALUES (300001, '$119.99');
-- 
-- Pokemon: Brilliant Diamond retail
INSERT INTO ItemPrices VALUES (300002, '$59.99');
-- Pokemon: Brilliant Diamond discount
INSERT INTO ItemPrices VALUES (300002, '$39.99');
-- 
-- Pokemon: Shining Pearl retail
INSERT INTO ItemPrices VALUES (300003, '$59.99');
-- Pokemon: Shining Pearl discount
INSERT INTO ItemPrices VALUES (300003, '$39.99');
-- 
-- Mario Kart 8: Deluxe retail
INSERT INTO ItemPrices VALUES (300004, '$59.99');
-- Mario Kart 8: Deluxe discount
INSERT INTO ItemPrices VALUES (300004, '$39.99');
-- 
-- Joy-Con Controller Pack (Pack of 2) retail
INSERT INTO ItemPrices VALUES (300005, '$79.99');
-- Joy-Con Controller Pack (Pack of 2) discount
INSERT INTO ItemPrices VALUES (300005, '$49.99');
--------------------------------------------------------------------------------------
INSERT INTO GoesTo VALUES (100000, 100001, 100002, 1, 'false');
INSERT INTO GoesTo VALUES (100000, 100001, 100003, 1, 'false');
INSERT INTO GoesTo VALUES (100000, 100001, 100004, 1, 'false');
INSERT INTO GoesTo VALUES (100000, 100001, 200001, 1, 'false');
INSERT INTO GoesTo VALUES (100000, 100001, 200002, 1, 'false');
INSERT INTO GoesTo VALUES (100000, 100001, 200003, 1, 'false');
INSERT INTO GoesTo VALUES (100000, 100001, 300002, 1, 'false');
INSERT INTO GoesTo VALUES (100000, 100001, 300003, 1, 'false');
INSERT INTO GoesTo VALUES (100000, 100001, 300004, 1, 'false');
INSERT INTO GoesTo VALUES (100001, 100009, 300001, 2, 'false');
INSERT INTO GoesTo VALUES (100002, 100003, 100006, 2, 'true');
INSERT INTO GoesTo VALUES (100003, 100002, 300005, 4, 'true');
INSERT INTO GoesTo VALUES (100004, 100009, 100005, 1, 'false');
INSERT INTO GoesTo VALUES (100005, 100003, 300004, 1, 'false');
INSERT INTO GoesTo VALUES (100006, 100004, 100002, 1, 'true');
INSERT INTO GoesTo VALUES (100007, 100006, 300000, 1, 'false');
INSERT INTO GoesTo VALUES (100008, 100008, 100002, 1, 'false');
INSERT INTO GoesTo VALUES (100009, 100006, 200005, 1, 'true');
INSERT INTO GoesTo VALUES (100010, 100008, 100004, 1, 'false');
INSERT INTO GoesTo VALUES (100011, 100001, 100001, 1, 'false');
INSERT INTO GoesTo VALUES (100012, 100002, 100000, 1, 'false');
INSERT INTO GoesTo VALUES (100013, 100001, 200000, 1, 'true');
INSERT INTO GoesTo VALUES (100014, 100003, 200001, 1, 'false');
INSERT INTO GoesTo VALUES (100015, 100002, 200003, 1, 'false');
INSERT INTO GoesTo VALUES (100016, 100005, 100002, 1, 'false');
INSERT INTO GoesTo VALUES (100017, 100007, 300002, 1, 'false');
INSERT INTO GoesTo VALUES (100018, 100008, 300000, 1, 'true');
INSERT INTO GoesTo VALUES (100019, 100006, 100000, 1, 'true');
INSERT INTO GoesTo VALUES (100020, 100001, 200000, 2, 'false');
INSERT INTO GoesTo VALUES (100021, 100004, 100004, 1, 'false');
INSERT INTO GoesTo VALUES (100022, 100009, 300004, 1, 'true');
INSERT INTO GoesTo VALUES (100023, 100005, 100006, 1, 'false');
INSERT INTO GoesTo VALUES (100024, 100008, 200002, 1, 'true');
INSERT INTO GoesTo VALUES (100025, 100005, 100003, 1, 'false');
--------------------------------------------------------------------------------------
INSERT INTO Has VALUES (100000, 100001);
INSERT INTO Has VALUES (100002, 100004);
INSERT INTO Has VALUES (100006, 100003);
INSERT INTO Has VALUES (200000, 100000);
INSERT INTO Has VALUES (200002, 100008);
INSERT INTO Has VALUES (200005, 100007);
INSERT INTO Has VALUES (300000, 100002);
INSERT INTO Has VALUES (300004, 100006);
INSERT INTO Has VALUES (300005, 100005);
--------------------------------------------------------------------------------------
INSERT INTO Manages VALUES (100000, 200000);
INSERT INTO Manages VALUES (100000, 200003);
INSERT INTO Manages VALUES (100000, 200012);
INSERT INTO Manages VALUES (100000, 200018);
INSERT INTO Manages VALUES (100001, 200009);
INSERT INTO Manages VALUES (100001, 200011);
INSERT INTO Manages VALUES (100001, 200013);
INSERT INTO Manages VALUES (100001, 200019);
INSERT INTO Manages VALUES (100002, 200010);
INSERT INTO Manages VALUES (100002, 200017);
INSERT INTO Manages VALUES (100003, 200008);
INSERT INTO Manages VALUES (100004, 200001);
INSERT INTO Manages VALUES (100004, 200006);
INSERT INTO Manages VALUES (100005, 200007);
INSERT INTO Manages VALUES (100005, 200016);
INSERT INTO Manages VALUES (100006, 200004);
INSERT INTO Manages VALUES (100006, 200020);
INSERT INTO Manages VALUES (100007, 200002);
INSERT INTO Manages VALUES (100007, 200014);
INSERT INTO Manages VALUES (100008, 200005);
INSERT INTO Manages VALUES (100008, 200015);
INSERT INTO Manages VALUES (100008, 200021);
--------------------------------------------------------------------------------------
COMMIT; 
-- 
SELECT * FROM Customers;
SELECT * FROM Stores;
SELECT * FROM Items;
SELECT * FROM Orders;
SELECT * FROM Managers;
SELECT * FROM Employees;
SELECT * FROM OrderLines;
SELECT * FROM StorePhone;
SELECT * FROM ItemPrices;
SELECT * FROM GoesTo;
SELECT * FROM Has;
SELECT * FROM Manages;
-- 
< The SQL queries>. Include the following for each query: 
− A comment line stating the query number and the feature(s) it demonstrates 
(e.g. -- Q25 – correlated subquery). 
− A comment line stating the query in English. 
− The SQL code for the query. 
-- 
< The insert/delete/update statements to test the enforcement of ICs > 
Include the following items for every IC that you test (Important: see the next section titled 
“Submit a final report” regarding which ICs you need to test).  
− A comment line stating: Testing: < IC name> 
− A SQL INSERT, DELETE, or UPDATE that will test the IC. 
COMMIT; 
-- 
SPOOL OFF