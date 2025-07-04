

--SCHEMA DEFINITIONS (DDL)

DROP TABLE IF EXISTS Transactions; 
DROP TABLE IF EXISTS CustomerAddresses;
DROP TABLE IF EXISTS Accounts;
DROP TABLE IF EXISTS Customers;
DROP TABLE IF EXISTS BatchRuns;

CREATE TABLE BatchRuns (
    BatchId INT AUTO_INCREMENT PRIMARY KEY, 
    BatchDate DATE NOT NULL, 
    Status ENUM('Pending', 'Completed', 'Failed') NOT NULL, 
    RecordsProcessed INT, 
    StartedAt DATETIME, 
    EndedAt DATETIME, 
    Notes TEXT 
);

CREATE TABLE Customers (
    CustomerId INT AUTO_INCREMENT PRIMARY KEY, 
    CustomerName VARCHAR(100) NOT NULL, 
    Email VARCHAR(100) UNIQUE, 
    PhoneNumber VARCHAR(20),
    DateOfBirth DATE,
    BatchId INT,
    BatchStatus ENUM('Pending', 'Processed', 'Failed', 'Excluded') DEFAULT 'Pending', 
    ExternalSyncTimestamp DATETIME, FOREIGN KEY (BatchId) REFERENCES BatchRuns (BatchId)
);

CREATE TABLE Accounts (
    AccountId INT AUTO_INCREMENT PRIMARY KEY,
    AccountNumber VARCHAR(20) NOT NULL UNIQUE,
    CustomerId INT NOT NULL,
    AccountType ENUM('Savings', 'Checking', 'Loan') NOT NULL,
    OpeningDate DATE NOT NULL,
    CurrentBalance DECIMAL(15, 2) NOT NULL,
    BatchId INT, 
    BatchStatus ENUM('Pending', 'Processed', 'Failed', 'Excluded') DEFAULT 'Pending',
    ExternalSyncTimestamp DATETIME, 
    FOREIGN KEY (CustomerId) REFERENCES Customers (CustomerId), 
    FOREIGN KEY (BatchId) REFERENCES BatchRuns (BatchId)
);    

CREATE TABLE CustomerAddresses (
    AddressId INT AUTO_INCREMENT PRIMARY KEY,
    CustomerId INT NOT NULL,
    AddressLine1 VARCHAR(255) NOT NULL,
    AddressLine2 VARCHAR(255),
    City VARCHAR(100),
    State VARCHAR(100),
    PostalCode VARCHAR(20),
    Country VARCHAR(100),
    AddressType ENUM('Home', 'Work', 'Billing', 'Shipping') NOT NULL, 
    BatchId INT, 
    FOREIGN KEY (CustomerId) REFERENCES Customers (CustomerId),
    FOREIGN KEY (BatchId) REFERENCES BatchRuns (BatchId)
);    

CREATE TABLE Transactions (
    TransactionId INT AUTO_INCREMENT PRIMARY KEY,
    AccountId INT NOT NULL,
    Date DATE NOT NULL,
    Amount DECIMAL(15, 2) NOT NULL,
    LoanBalance DECIMAL(15, 2),
    BatchId INT,
    BatchStatus ENUM('Pending', 'Processed', 'Failed', 'Excluded') DEFAULT 'Pending',
    ExternalSyncTimestamp DATETIME,
    FOREIGN KEY (AccountId) REFERENCES Accounts (AccountId),
    FOREIGN KEY (BatchId) REFERENCES BatchRuns (BatchId)
);


--BatchRuns
INSERT INTO BatchRuns (BatchDate, Status, RecordsProcessed, StartedAt, EndedAt, Notes) VALUES
('2025-06-17', 'Completed', 1500, '2025-06-17 01:00:00', '2025-06-17 01:30:00',''),
('2025-06-18', 'Completed', 1625, '2025-06-18 01:00:00', '2025-06-18 01:28:10',''),
('2025-06-19', 'Completed', 1580, '2025-06-19 01:00:00', '2025-06-19 01:32:45',''),
('2025-06-20', 'Completed', 1600, '2025-06-20 01:00:00', '2025-06-20 01:29:30',''),
('2025-06-21', 'Completed', 1550, '2025-06-21 01:00:00', '2025-06-21 01:31:15','');


INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (1, 'Laura Cox', 'nathan15@example.org', '2585895703', '1998-04-23', 3, 'Excluded', '2025-07-02 06:42:52');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (1, 'ACC000001', 1, 'Loan', '2024-06-05', 8923.75, 3, 'Failed', '2025-06-30 08:27');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (1, 1, '695 William Port Suite 763', NULL, 'Washingtonbury', 'NM', '44318', 'USA', 'Home', 3); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (1, 1, '2025-06-04', 1865.06, 812.2, 3, 'Failed', '2025-07-02 21:23:52');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (2, 'Ms. Susan Anderson', 'vweber@example.org', '282.750.4015x20420', '1976-04-19', 1, 'Pending', '2025-07-04 10:50:59');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (2, 'ACC000002', 2, 'Loan', '2022-06-14', 2276.03, 1, 'Processed', '2025-07-03 00:49');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (2, 2, '6758 Chavez Roads', NULL, 'Johnsonland', 'MH', '41319', 'USA', 'Work', 1); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (2, 2, '2025-06-22', 816.53, 2259.52, 1, 'Excluded', '2025-07-04 07:55:13');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (3, 'Emily Thomas', 'donovansteven@example.net', '268.607.3627x071', '1962-11-28', 4, 'Excluded', '2025-06-30 02:17:19');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (3, 'ACC000003', 3, 'Savings', '2022-04-03', 4816.1, 4, 'Excluded', '2025-06-30 14:27');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (3, 3, '030 Johnson Inlet', NULL, 'Swansonstad', 'OK', '66135', 'USA', 'Billing', 4); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (3, 3, '2025-06-13', 1673.69, 218.03, 4, 'Pending', '2025-07-01 22:07:52');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (4, 'Brandon Manning', 'mary21@example.com', '542.662.9649x221', '1984-10-12', 2, 'Excluded', '2025-06-30 03:23:46');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (4, 'ACC000004', 4, 'Loan', '2021-05-03', 8603.04, 2, 'Processed', '2025-07-03 06:00');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (4, 4, '22170 Trevino Lodge', NULL, 'Port Cory', 'AZ', '81298', 'USA', 'Billing', 2); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (4, 4, '2025-06-17', -321.25, 2033.26, 2, 'Failed', '2025-07-03 18:36:20');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (5, 'Madison Russell', 'savagesamantha@example.org', '+1-331-358-0026x256', '1984-11-11', 3, 'Excluded', '2025-06-30 12:40:58');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (5, 'ACC000005', 5, 'Checking', '2024-07-31', 7788.95, 3, 'Pending', '2025-07-02 09:28');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (5, 5, '4338 Cox Crossing Apt. 071', NULL, 'Marcuschester', 'DC', '10264', 'USA', 'Shipping', 3); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (5, 5, '2025-06-14', -287.07, 4028.57, 3, 'Processed', '2025-07-03 05:40:02');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (6, 'Carrie White', 'ryan94@example.org', '631.901.7090x9604', '1970-08-03', 1, 'Failed', '2025-07-03 23:45:11');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (6, 'ACC000006', 6, 'Loan', '2024-07-06', 9260.68, 1, 'Excluded', '2025-07-02 00:27');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (6, 6, '920 Martha Fords Suite 635', NULL, 'Lake Dakotaland', 'WV', '26810', 'USA', 'Billing', 1); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (6, 6, '2025-06-06', 498.12, 299.89, 1, 'Processed', '2025-06-30 14:19:03');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (7, 'Alexis Kelly', 'kmiller@example.org', '915.531.5393x83700', '2006-07-09', 2, 'Excluded', '2025-07-02 08:35:16');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (7, 'ACC000007', 7, 'Savings', '2024-01-07', 1875.17, 2, 'Failed', '2025-06-30 05:29');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (7, 7, '054 Brandi Wells', NULL, 'South Rodney', 'DE', '90873', 'USA', 'Work', 2); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (7, 7, '2025-06-27', -983.92, 1735.38, 2, 'Failed', '2025-07-04 07:34:17');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (8, 'Phillip Anderson', 'ethompson@example.org', '599.335.0854', '1995-12-21', 5, 'Failed', '2025-07-01 23:26:53');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (8, 'ACC000008', 8, 'Savings', '2024-05-20', 7235.73, 5, 'Excluded', '2025-07-03 07:39');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (8, 8, '03788 Howard Rapids', NULL, 'South Michaelbury', 'NH', '98602', 'USA', 'Shipping', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (8, 8, '2025-06-08', 1552.65, 2850.78, 5, 'Pending', '2025-07-01 23:50:49');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (9, 'Rebecca Thompson PhD', 'james69@example.net', '962-977-8564', '1999-06-28', 3, 'Processed', '2025-07-03 10:52:28');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (9, 'ACC000009', 9, 'Checking', '2023-10-31', 2328.36, 3, 'Excluded', '2025-07-02 14:00');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (9, 9, '23371 Hart Wall', NULL, 'Smithstad', 'MH', '06144', 'USA', 'Billing', 3); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (9, 9, '2025-06-18', 574.6, 2644.57, 3, 'Excluded', '2025-07-02 09:39:29');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (10, 'Andrew Williams', 'cwright@example.org', '619-336-1733x98537', '1995-09-04', 4, 'Excluded', '2025-07-01 11:27:55');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (10, 'ACC000010', 10, 'Checking', '2022-08-21', 9841.51, 4, 'Excluded', '2025-07-02 17:11');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (10, 10, '71910 Heidi Circle Apt. 484', NULL, 'Rachelton', 'AZ', '32568', 'USA', 'Shipping', 4); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (10, 10, '2025-06-18', 14.97, 126.14, 4, 'Processed', '2025-07-01 06:28:25');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (11, 'Kelly Martinez', 'carlosburnett@example.net', '+1-869-471-6222x864', '1963-01-17', 4, 'Pending', '2025-07-03 04:08:16');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (11, 'ACC000011', 11, 'Savings', '2023-05-08', 9634.58, 4, 'Pending', '2025-07-03 21:46');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (11, 11, '3844 Roberts Forges Suite 850', NULL, 'Port Elizabeth', 'WY', '79607', 'USA', 'Home', 4); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (11, 11, '2025-06-25', 1593.66, 3748.98, 4, 'Processed', '2025-06-30 13:08:36');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (12, 'Scott Owens', 'katrinahiggins@example.org', '615.516.5043x350', '1962-04-08', 4, 'Pending', '2025-07-02 05:24:21');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (12, 'ACC000012', 12, 'Savings', '2021-07-12', 8934.28, 4, 'Excluded', '2025-07-02 17:00');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (12, 12, '7322 Fernando Ridge Apt. 473', NULL, 'Gilesbury', 'KY', '79404', 'USA', 'Shipping', 4); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (12, 12, '2025-07-01', -185.06, 2959.83, 4, 'Failed', '2025-07-01 19:05:59');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (13, 'Kelsey Davis', 'rebeccareyes@example.com', '(416)994-9109x37441', '1967-07-23', 2, 'Pending', '2025-07-01 12:00:38');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (13, 'ACC000013', 13, 'Checking', '2023-08-30', 401.29, 2, 'Processed', '2025-07-04 02:10');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (13, 13, '3142 Johnson Crossroad Suite 596', NULL, 'Hallshire', 'AZ', '55109', 'USA', 'Billing', 2); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (13, 13, '2025-06-13', 1849.66, 2094.0, 2, 'Processed', '2025-07-01 08:47:04');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (14, 'Timothy Martinez', 'burnsaaron@example.org', '842.482.0061x2002', '1949-08-10', 2, 'Pending', '2025-07-04 12:36:01');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (14, 'ACC000014', 14, 'Loan', '2022-05-12', 3021.31, 2, 'Pending', '2025-07-04 07:45');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (14, 14, '991 Marcus Fork', NULL, 'West Jimmyfurt', 'FL', '11924', 'USA', 'Billing', 2); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (14, 14, '2025-06-22', -750.51, 1310.9, 2, 'Pending', '2025-06-29 17:17:57');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (15, 'Luis Brown', 'huntmark@example.com', '(653)402-3322', '1990-08-30', 5, 'Excluded', '2025-07-03 14:20:35');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (15, 'ACC000015', 15, 'Savings', '2024-10-09', 1471.5, 5, 'Excluded', '2025-07-02 10:32');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (15, 15, '9167 Jason Corners', NULL, 'West Jeffreytown', 'AR', '22764', 'USA', 'Work', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (15, 15, '2025-06-28', 110.01, 455.73, 5, 'Processed', '2025-07-03 03:11:30');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (16, 'Justin Johnson', 'pamela81@example.com', '(662)353-8909x122', '1964-09-28', 1, 'Processed', '2025-07-04 08:53:55');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (16, 'ACC000016', 16, 'Checking', '2021-05-24', 6437.53, 1, 'Pending', '2025-07-01 10:50');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (16, 16, '911 Patel Ports Suite 231', NULL, 'Savageside', 'TN', '13349', 'USA', 'Home', 1); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (16, 16, '2025-06-24', -18.6, 1294.8, 1, 'Excluded', '2025-06-30 23:26:55');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (17, 'Andrea Gonzalez', 'smithkristen@example.com', '589.375.1008x073', '1965-01-09', 2, 'Excluded', '2025-07-04 08:11:50');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (17, 'ACC000017', 17, 'Savings', '2021-02-06', 7678.99, 2, 'Excluded', '2025-06-30 10:49');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (17, 17, '555 Warner Villages Apt. 381', NULL, 'Briantown', 'GU', '76945', 'USA', 'Billing', 2); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (17, 17, '2025-06-23', 1952.74, 1562.96, 2, 'Pending', '2025-07-03 07:03:12');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (18, 'Adam Bass', 'lisa75@example.org', '809.686.3683x040', '1963-11-18', 2, 'Processed', '2025-07-02 15:31:50');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (18, 'ACC000018', 18, 'Loan', '2023-02-26', 5548.86, 2, 'Excluded', '2025-06-30 00:44');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (18, 18, '06647 Catherine Ford Suite 374', NULL, 'Lake Jenniferland', 'MA', '42345', 'USA', 'Home', 2); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (18, 18, '2025-06-19', -994.03, 4199.61, 2, 'Pending', '2025-07-04 06:19:40');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (19, 'Barbara Carpenter', 'deborahsanchez@example.org', '+1-248-220-5669x656', '1977-03-24', 1, 'Failed', '2025-07-03 05:03:50');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (19, 'ACC000019', 19, 'Loan', '2021-02-22', 3901.02, 1, 'Failed', '2025-07-01 08:39');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (19, 19, '7060 Julie Island', NULL, 'Jamesview', 'IA', '95212', 'USA', 'Home', 1); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (19, 19, '2025-06-07', 642.38, 4727.22, 1, 'Excluded', '2025-07-02 04:05:53');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (20, 'Tracy Martin', 'wandatodd@example.org', '001-490-720-9034x264', '1996-04-29', 1, 'Processed', '2025-07-01 07:41:09');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (20, 'ACC000020', 20, 'Loan', '2024-10-20', 4951.66, 1, 'Excluded', '2025-07-02 20:00');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (20, 20, '881 Hunt Parks Suite 972', NULL, 'New Jeffrey', 'KY', '07640', 'USA', 'Work', 1); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (20, 20, '2025-07-03', -57.45, 4548.74, 1, 'Excluded', '2025-07-04 07:43:16');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (21, 'Jennifer Lopez DDS', 'elaine56@example.com', '860-565-2639x20281', '1991-01-23', 5, 'Processed', '2025-07-02 02:47:14');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (21, 'ACC000021', 21, 'Loan', '2024-10-08', 361.4, 5, 'Failed', '2025-06-29 15:55');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (21, 21, '90791 Martinez Fort Suite 045', NULL, 'New Connorstad', 'IA', '59347', 'USA', 'Shipping', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (21, 21, '2025-06-22', 1182.02, 4921.2, 5, 'Processed', '2025-06-30 16:41:33');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (22, 'Jay Martin', 'alyssacarter@example.com', '+1-598-201-5348x971', '1967-05-30', 2, 'Failed', '2025-06-29 23:34:41');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (22, 'ACC000022', 22, 'Loan', '2021-10-14', 6939.69, 2, 'Excluded', '2025-07-04 09:41');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (22, 22, '1431 Mark Crossroad Apt. 292', NULL, 'Lake Stephanie', 'HI', '11888', 'USA', 'Home', 2); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (22, 22, '2025-06-11', 1174.2, 1787.84, 2, 'Excluded', '2025-07-03 04:26:41');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (23, 'Gary Roberts', 'pottercharles@example.com', '523.630.7901', '1977-09-21', 1, 'Pending', '2025-06-30 09:04:17');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (23, 'ACC000023', 23, 'Loan', '2022-07-30', 9314.4, 1, 'Excluded', '2025-06-30 00:44');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (23, 23, '007 Garcia Plains', NULL, 'East Julie', 'NE', '91901', 'USA', 'Home', 1); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (23, 23, '2025-06-06', -386.7, 4203.84, 1, 'Processed', '2025-07-03 01:52:05');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (24, 'Amanda Campbell', 'christopher61@example.net', '602.856.8650x717', '2002-07-23', 3, 'Pending', '2025-06-30 11:14:28');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (24, 'ACC000024', 24, 'Savings', '2023-06-30', 4393.6, 3, 'Processed', '2025-07-01 16:24');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (24, 24, '4236 Stephanie Harbor Suite 259', NULL, 'Codyside', 'CO', '73376', 'USA', 'Shipping', 3); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (24, 24, '2025-06-28', -953.76, 2740.67, 3, 'Excluded', '2025-07-01 17:49:09');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (25, 'William Guzman', 'stephenssteven@example.com', '461.750.3041x681', '1975-07-24', 4, 'Failed', '2025-06-29 14:21:39');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (25, 'ACC000025', 25, 'Checking', '2023-09-11', 5218.34, 4, 'Excluded', '2025-06-30 15:28');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (25, 25, '8914 Lori Via', NULL, 'North Nicolechester', 'AL', '32962', 'USA', 'Billing', 4); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (25, 25, '2025-06-25', -201.28, 1180.38, 4, 'Pending', '2025-06-29 20:02:06');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (26, 'Mckenzie Olson', 'howeashley@example.com', '+1-300-624-6276', '1993-02-27', 5, 'Processed', '2025-07-03 12:59:30');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (26, 'ACC000026', 26, 'Savings', '2024-05-30', 1688.49, 5, 'Failed', '2025-06-29 20:30');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (26, 26, '555 Harrington Station Suite 181', NULL, 'New Ritaton', 'MP', '74881', 'USA', 'Shipping', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (26, 26, '2025-06-15', -868.57, 472.89, 5, 'Excluded', '2025-07-03 16:20:38');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (27, 'Sean Turner', 'brucebates@example.com', '001-719-351-6039', '1987-07-04', 1, 'Processed', '2025-06-30 19:11:50');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (27, 'ACC000027', 27, 'Savings', '2023-04-21', 4881.15, 1, 'Excluded', '2025-06-30 13:06');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (27, 27, '776 Samantha Islands Apt. 493', NULL, 'North Danielland', 'WA', '03058', 'USA', 'Shipping', 1); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (27, 27, '2025-07-03', 844.46, 3973.85, 1, 'Excluded', '2025-07-02 03:01:24');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (28, 'Danielle Mendez', 'sydney00@example.org', '(263)824-7004x692', '2000-08-16', 4, 'Excluded', '2025-07-01 12:14:11');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (28, 'ACC000028', 28, 'Checking', '2023-08-03', 1721.15, 4, 'Failed', '2025-07-03 20:02');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (28, 28, '3341 Emily Views Suite 142', NULL, 'South John', 'MD', '18799', 'USA', 'Billing', 4); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (28, 28, '2025-06-25', -895.87, 3899.08, 4, 'Processed', '2025-07-02 12:09:59');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (29, 'Sarah Reeves', 'iburgess@example.org', '(516)350-5649x720', '1986-01-06', 5, 'Pending', '2025-06-30 08:21:38');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (29, 'ACC000029', 29, 'Loan', '2024-12-12', 5543.33, 5, 'Excluded', '2025-07-03 12:46');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (29, 29, '3557 Weiss Walks', NULL, 'Timothytown', 'ND', '90991', 'USA', 'Home', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (29, 29, '2025-06-04', -840.0, 217.79, 5, 'Pending', '2025-07-03 19:57:30');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (30, 'Patricia Blackburn', 'ortizkimberly@example.org', '768-853-0429', '1987-11-29', 1, 'Failed', '2025-06-29 16:40:12');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (30, 'ACC000030', 30, 'Savings', '2024-02-06', 879.56, 1, 'Processed', '2025-06-30 06:51');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (30, 30, '6626 Ashley Pike', NULL, 'South Josephville', 'FL', '85652', 'USA', 'Shipping', 1); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (30, 30, '2025-07-02', 375.93, 1162.49, 1, 'Pending', '2025-06-29 14:23:18');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (31, 'Daniel Adkins', 'elizabeth03@example.com', '503-406-2673', '1986-10-05', 4, 'Pending', '2025-07-02 13:03:41');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (31, 'ACC000031', 31, 'Checking', '2023-11-30', 6388.54, 4, 'Processed', '2025-07-01 11:18');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (31, 31, '2250 Olson Pike', NULL, 'Port Sara', 'NE', '22488', 'USA', 'Billing', 4); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (31, 31, '2025-06-21', -687.41, 1663.62, 4, 'Processed', '2025-07-04 06:20:00');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (32, 'Mario Cruz', 'vtran@example.net', '385-604-0055', '1995-12-07', 2, 'Failed', '2025-07-03 19:27:05');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (32, 'ACC000032', 32, 'Loan', '2024-05-31', 9444.97, 2, 'Excluded', '2025-07-01 08:27');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (32, 32, '889 Ross Lights', NULL, 'East Melissaview', 'FL', '72726', 'USA', 'Billing', 2); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (32, 32, '2025-06-13', 63.07, 20.69, 2, 'Excluded', '2025-07-02 17:07:52');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (33, 'Michael Walker', 'ibarraabigail@example.org', '(456)276-5952', '2000-10-07', 1, 'Failed', '2025-06-30 22:04:04');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (33, 'ACC000033', 33, 'Savings', '2023-10-20', 2235.13, 1, 'Processed', '2025-06-29 22:28');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (33, 33, '23574 Joseph Camp', NULL, 'North Christinaburgh', 'MA', '45941', 'USA', 'Billing', 1); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (33, 33, '2025-06-18', 44.22, 4116.99, 1, 'Processed', '2025-06-30 21:05:41');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (34, 'Catherine Mitchell', 'dalesingleton@example.net', '226-866-7129x42913', '1991-09-12', 2, 'Failed', '2025-07-03 02:06:30');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (34, 'ACC000034', 34, 'Loan', '2021-01-15', 1447.88, 2, 'Failed', '2025-06-29 21:18');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (34, 34, '3322 Nelson Ranch', NULL, 'Lake Christopher', 'AR', '65401', 'USA', 'Shipping', 2); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (34, 34, '2025-06-11', -924.33, 3798.39, 2, 'Processed', '2025-07-04 05:01:49');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (35, 'Austin Morales', 'lvaldez@example.net', '448-353-3114x45830', '1951-05-26', 3, 'Failed', '2025-07-01 06:33:26');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (35, 'ACC000035', 35, 'Savings', '2020-12-16', 9775.06, 3, 'Failed', '2025-07-03 12:01');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (35, 35, '5275 Alison Isle', NULL, 'New Amanda', 'IL', '98271', 'USA', 'Work', 3); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (35, 35, '2025-06-27', 1184.25, 4207.99, 3, 'Pending', '2025-07-03 06:20:20');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (36, 'Annette Smith', 'bensonkaren@example.com', '(971)565-8765', '1968-09-22', 1, 'Excluded', '2025-06-30 00:19:01');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (36, 'ACC000036', 36, 'Checking', '2022-12-20', 2327.75, 1, 'Failed', '2025-07-03 22:18');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (36, 36, '827 Jared Centers', NULL, 'Lake Amanda', 'WI', '42388', 'USA', 'Home', 1); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (36, 36, '2025-06-29', -986.91, 2683.61, 1, 'Pending', '2025-07-04 04:55:36');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (37, 'Christina Pearson', 'szamora@example.com', '804-799-4010x91850', '1996-06-24', 1, 'Failed', '2025-06-29 20:32:48');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (37, 'ACC000037', 37, 'Checking', '2022-02-27', 367.33, 1, 'Excluded', '2025-07-03 07:18');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (37, 37, '13316 Atkinson Circles Suite 738', NULL, 'Hopkinsville', 'VA', '14511', 'USA', 'Home', 1); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (37, 37, '2025-06-30', 742.84, 2558.07, 1, 'Excluded', '2025-07-04 00:24:30');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (38, 'Pamela Smith DDS', 'dmurphy@example.net', '316-910-9391', '1984-11-16', 3, 'Excluded', '2025-07-01 02:12:20');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (38, 'ACC000038', 38, 'Loan', '2020-07-07', 7957.92, 3, 'Pending', '2025-06-30 10:54');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (38, 38, '282 Bryan Knoll', NULL, 'Sosatown', 'WV', '18922', 'USA', 'Home', 3); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (38, 38, '2025-06-18', -33.48, 3563.36, 3, 'Processed', '2025-07-01 04:49:02');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (39, 'Joseph Mckinney', 'campbellstephanie@example.com', '939-353-8508x807', '2004-12-12', 4, 'Excluded', '2025-07-04 03:17:48');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (39, 'ACC000039', 39, 'Checking', '2023-02-16', 3621.62, 4, 'Pending', '2025-07-04 03:09');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (39, 39, '04852 Shawna Bridge Apt. 030', NULL, 'Hernandezhaven', 'NH', '31518', 'USA', 'Shipping', 4); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (39, 39, '2025-06-25', 1049.55, 2944.27, 4, 'Processed', '2025-06-30 00:00:57');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (40, 'Monica Weaver', 'cbray@example.org', '997.291.3147x999', '1982-09-27', 2, 'Pending', '2025-07-03 20:59:49');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (40, 'ACC000040', 40, 'Loan', '2025-01-10', 3630.66, 2, 'Processed', '2025-07-01 18:13');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (40, 40, '192 Fitzpatrick Brooks', NULL, 'New Lauraside', 'CA', '29361', 'USA', 'Home', 2); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (40, 40, '2025-06-15', 1960.78, 1272.71, 2, 'Failed', '2025-06-30 22:48:28');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (41, 'Steven Alexander', 'joshua16@example.org', '(401)287-2223', '1958-07-13', 2, 'Pending', '2025-07-04 07:34:02');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (41, 'ACC000041', 41, 'Checking', '2023-04-14', 9116.93, 2, 'Failed', '2025-07-03 12:48');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (41, 41, '694 Kelly Turnpike Apt. 180', NULL, 'South Kimberlyhaven', 'WA', '52382', 'USA', 'Home', 2); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (41, 41, '2025-07-03', 1973.67, 739.08, 2, 'Excluded', '2025-07-03 06:20:38');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (42, 'Ralph Walker', 'kristinegarcia@example.org', '723-888-7277x7950', '1968-12-08', 3, 'Excluded', '2025-07-04 12:14:51');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (42, 'ACC000042', 42, 'Loan', '2024-08-11', 4594.03, 3, 'Failed', '2025-07-03 23:36');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (42, 42, '8251 Raymond Ridge', NULL, 'Watsonmouth', 'LA', '13886', 'USA', 'Work', 3); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (42, 42, '2025-06-14', 1657.71, 4417.12, 3, 'Pending', '2025-06-30 17:15:23');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (43, 'Samantha Martin', 'jamescarlson@example.com', '+1-564-557-5912', '1957-12-26', 2, 'Processed', '2025-07-03 01:26:39');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (43, 'ACC000043', 43, 'Checking', '2023-09-09', 2853.85, 2, 'Failed', '2025-06-30 06:41');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (43, 43, '08031 Hahn Hill', NULL, 'Johnport', 'MI', '45275', 'USA', 'Shipping', 2); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (43, 43, '2025-06-10', 10.57, 1518.57, 2, 'Failed', '2025-07-03 17:00:34');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (44, 'Cynthia Guerrero DDS', 'seanmorrow@example.com', '399.694.2146x881', '1988-11-27', 2, 'Processed', '2025-07-03 03:15:48');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (44, 'ACC000044', 44, 'Savings', '2024-02-04', 5439.71, 2, 'Processed', '2025-07-01 22:59');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (44, 44, '747 John Inlet Suite 931', NULL, 'Christopherside', 'WA', '79372', 'USA', 'Home', 2); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (44, 44, '2025-06-25', -86.14, 3403.29, 2, 'Processed', '2025-07-02 11:55:43');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (45, 'Deborah Ramirez', 'gjenkins@example.net', '001-974-708-4685x7198', '1960-08-22', 2, 'Excluded', '2025-06-30 05:05:36');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (45, 'ACC000045', 45, 'Savings', '2024-01-10', 4657.91, 2, 'Excluded', '2025-07-02 00:14');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (45, 45, '65708 Sparks Neck', NULL, 'New Reneefurt', 'NJ', '05136', 'USA', 'Work', 2); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (45, 45, '2025-06-05', -186.4, 2479.31, 2, 'Pending', '2025-07-02 13:36:52');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (46, 'Michelle Shepherd', 'benjaminlong@example.com', '339.343.1181x508', '1956-01-14', 2, 'Excluded', '2025-07-01 18:53:49');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (46, 'ACC000046', 46, 'Loan', '2022-09-03', 3690.24, 2, 'Failed', '2025-06-30 22:18');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (46, 46, '342 Robert Prairie Apt. 508', NULL, 'East Melvin', 'TN', '82511', 'USA', 'Billing', 2); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (46, 46, '2025-06-12', 487.32, 3636.77, 2, 'Excluded', '2025-06-30 00:09:33');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (47, 'Jeffrey Gill', 'amber70@example.com', '373-844-9529x14151', '1990-11-12', 2, 'Failed', '2025-06-29 15:11:12');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (47, 'ACC000047', 47, 'Savings', '2020-08-15', 893.52, 2, 'Processed', '2025-07-02 19:47');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (47, 47, '94114 Green Springs', NULL, 'West Charles', 'RI', '77759', 'USA', 'Work', 2); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (47, 47, '2025-06-21', 1114.67, 2405.44, 2, 'Processed', '2025-07-04 01:09:39');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (48, 'Devin Gordon', 'kcabrera@example.net', '840.881.5112x060', '1992-09-12', 3, 'Excluded', '2025-07-01 22:16:47');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (48, 'ACC000048', 48, 'Savings', '2021-03-27', 1664.22, 3, 'Processed', '2025-07-01 09:48');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (48, 48, '229 Simon Underpass Suite 517', NULL, 'Diazville', 'OR', '90081', 'USA', 'Shipping', 3); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (48, 48, '2025-06-09', 103.65, 996.22, 3, 'Processed', '2025-07-02 16:26:27');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (49, 'Elizabeth Jackson', 'terrellkathy@example.net', '001-485-332-3710x7589', '1998-10-03', 5, 'Pending', '2025-07-03 05:53:42');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (49, 'ACC000049', 49, 'Checking', '2021-05-05', 5466.38, 5, 'Excluded', '2025-06-29 14:32');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (49, 49, '38971 Poole Causeway Suite 890', NULL, 'Port Mark', 'ME', '78338', 'USA', 'Work', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (49, 49, '2025-06-28', 837.45, 2005.69, 5, 'Excluded', '2025-07-03 09:04:49');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (50, 'Gabriela Nelson', 'austin09@example.org', '597-591-0191', '1997-02-18', 2, 'Processed', '2025-07-03 03:48:44');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (50, 'ACC000050', 50, 'Loan', '2022-11-04', 902.24, 2, 'Excluded', '2025-07-02 03:28');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (50, 50, '80862 Mcknight Radial Suite 707', NULL, 'West Brandihaven', 'GA', '38009', 'USA', 'Billing', 2); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (50, 50, '2025-06-11', 395.18, 676.26, 2, 'Processed', '2025-07-02 02:01:21');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (51, 'Michael Campbell', 'charlestaylor@example.org', '320.987.0281', '1968-05-06', 4, 'Failed', '2025-07-03 06:17:57');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (51, 'ACC000051', 51, 'Checking', '2022-04-14', 5546.56, 4, 'Processed', '2025-07-02 23:07');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (51, 51, '517 Riley Ridges Apt. 850', NULL, 'Mitchellfurt', 'NJ', '82306', 'USA', 'Billing', 4); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (51, 51, '2025-06-16', 540.2, 3357.41, 4, 'Excluded', '2025-07-02 23:57:02');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (52, 'Sarah Boyd', 'crystal17@example.org', '(355)646-8634x17182', '1973-04-24', 2, 'Excluded', '2025-06-29 14:35:51');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (52, 'ACC000052', 52, 'Loan', '2021-04-20', 4473.55, 2, 'Processed', '2025-06-30 09:27');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (52, 52, '2002 Howard Heights', NULL, 'Austinchester', 'RI', '22874', 'USA', 'Work', 2); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (52, 52, '2025-06-15', 1580.85, 3307.17, 2, 'Processed', '2025-07-03 19:23:29');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (53, 'Christina Cox', 'marybrown@example.com', '995-464-1745x0448', '1964-01-03', 4, 'Processed', '2025-07-01 07:46:01');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (53, 'ACC000053', 53, 'Checking', '2020-09-11', 2254.58, 4, 'Processed', '2025-06-30 04:30');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (53, 53, '5787 Charlene Cliffs', NULL, 'Lauraton', 'AR', '31666', 'USA', 'Home', 4); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (53, 53, '2025-06-17', 615.51, 2424.1, 4, 'Processed', '2025-06-30 03:10:30');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (54, 'Kimberly Moore', 'trichard@example.com', '001-304-712-2845x104', '1956-01-26', 3, 'Processed', '2025-07-01 05:30:02');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (54, 'ACC000054', 54, 'Savings', '2024-05-09', 2687.6, 3, 'Processed', '2025-06-30 19:24');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (54, 54, '1039 Brian Row', NULL, 'South Elizabeth', 'NC', '34253', 'USA', 'Billing', 3); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (54, 54, '2025-06-15', 271.02, 4901.8, 3, 'Pending', '2025-06-29 20:45:24');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (55, 'David Day PhD', 'hannahanderson@example.net', '(259)902-1353x1952', '1960-06-20', 5, 'Excluded', '2025-07-02 01:38:11');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (55, 'ACC000055', 55, 'Loan', '2023-05-10', 7349.38, 5, 'Excluded', '2025-07-04 07:13');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (55, 55, '36181 Evelyn Fall Suite 593', NULL, 'South Jamesshire', 'NH', '06285', 'USA', 'Work', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (55, 55, '2025-06-04', 376.9, 1518.91, 5, 'Processed', '2025-07-03 03:51:48');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (56, 'Dominique Price', 'trevor22@example.net', '671-985-2918', '2006-11-07', 1, 'Processed', '2025-07-03 11:00:09');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (56, 'ACC000056', 56, 'Checking', '2021-06-15', 9833.64, 1, 'Failed', '2025-07-03 16:15');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (56, 56, '62224 Washington Valley Suite 084', NULL, 'Amberstad', 'MH', '68025', 'USA', 'Shipping', 1); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (56, 56, '2025-06-06', 556.67, 4716.09, 1, 'Failed', '2025-07-03 14:41:52');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (57, 'Jose Phillips', 'pearsonmark@example.org', '8016739381', '1982-01-06', 5, 'Processed', '2025-07-01 15:25:00');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (57, 'ACC000057', 57, 'Loan', '2023-05-18', 8461.74, 5, 'Failed', '2025-07-02 20:01');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (57, 57, '42161 Vazquez Fords Suite 706', NULL, 'Garciaborough', 'AR', '36214', 'USA', 'Billing', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (57, 57, '2025-06-29', 760.7, 3729.85, 5, 'Failed', '2025-06-30 08:19:17');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (58, 'Scott Harrison', 'christophercolon@example.org', '749-681-5033x658', '1952-12-30', 4, 'Processed', '2025-07-01 19:24:33');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (58, 'ACC000058', 58, 'Checking', '2020-08-23', 5414.77, 4, 'Excluded', '2025-07-01 17:03');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (58, 58, '0507 Hines Crossing Apt. 677', NULL, 'Port Christopherhaven', 'WY', '83505', 'USA', 'Billing', 4); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (58, 58, '2025-07-02', 1686.41, 3881.59, 4, 'Pending', '2025-07-03 11:52:31');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (59, 'Brittany Campbell', 'rojasjames@example.org', '(498)442-1740', '1968-09-16', 1, 'Pending', '2025-07-04 00:09:59');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (59, 'ACC000059', 59, 'Loan', '2021-10-30', 5862.79, 1, 'Excluded', '2025-07-03 05:08');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (59, 59, '3720 Christopher Bypass', NULL, 'East Elizabethborough', 'FL', '29120', 'USA', 'Billing', 1); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (59, 59, '2025-06-15', 1372.27, 442.68, 1, 'Failed', '2025-06-29 21:07:59');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (60, 'Jason Armstrong', 'colleen43@example.net', '319-226-7784', '1961-11-22', 1, 'Pending', '2025-06-30 13:05:01');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (60, 'ACC000060', 60, 'Savings', '2025-02-28', 4445.44, 1, 'Pending', '2025-07-02 09:53');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (60, 60, '53950 Jill Village', NULL, 'West Leslie', 'KY', '65904', 'USA', 'Home', 1); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (60, 60, '2025-06-14', -105.02, 604.69, 1, 'Failed', '2025-06-30 15:38:50');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (61, 'Jacob Johnson', 'benjaminjoseph@example.net', '001-903-361-4839', '1974-04-05', 4, 'Processed', '2025-06-30 18:39:26');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (61, 'ACC000061', 61, 'Savings', '2023-06-03', 3470.7, 4, 'Processed', '2025-06-30 23:52');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (61, 61, '76817 Garner Isle', NULL, 'Michaelfurt', 'DE', '52308', 'USA', 'Work', 4); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (61, 61, '2025-06-30', 376.36, 1363.39, 4, 'Pending', '2025-07-04 02:00:31');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (62, 'Randy Grimes', 'alyssa91@example.org', '+1-344-513-1257', '2003-10-29', 4, 'Processed', '2025-07-01 09:13:18');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (62, 'ACC000062', 62, 'Checking', '2021-02-09', 5540.0, 4, 'Processed', '2025-07-02 06:29');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (62, 62, '05449 Strickland Corners', NULL, 'Lake Douglas', 'KY', '78811', 'USA', 'Work', 4); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (62, 62, '2025-06-26', 1126.21, 3212.36, 4, 'Failed', '2025-06-30 18:43:41');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (63, 'Selena Becker', 'kimberly89@example.net', '+1-955-402-9185x804', '1977-02-02', 5, 'Failed', '2025-06-30 20:57:34');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (63, 'ACC000063', 63, 'Loan', '2024-12-29', 9045.71, 5, 'Failed', '2025-06-30 07:50');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (63, 63, '7892 Andrea Gateway', NULL, 'Port Troyfort', 'MD', '82184', 'USA', 'Home', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (63, 63, '2025-06-22', 219.4, 91.46, 5, 'Pending', '2025-06-29 23:28:08');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (64, 'Brandi Thomas', 'wjackson@example.net', '433-313-9451x2930', '1953-12-19', 1, 'Processed', '2025-06-30 04:34:30');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (64, 'ACC000064', 64, 'Checking', '2023-12-17', 8640.34, 1, 'Excluded', '2025-06-30 16:16');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (64, 64, '211 Bond Extension Suite 465', NULL, 'North Charlesberg', 'IL', '93216', 'USA', 'Home', 1); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (64, 64, '2025-06-06', -905.49, 1245.62, 1, 'Failed', '2025-07-02 12:22:13');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (65, 'Jessica Cruz', 'jacquelineparker@example.com', '+1-903-844-3978x0603', '1980-12-07', 3, 'Excluded', '2025-07-04 11:00:22');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (65, 'ACC000065', 65, 'Loan', '2021-03-17', 6870.66, 3, 'Processed', '2025-07-01 00:06');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (65, 65, '417 Kimberly Underpass', NULL, 'South Kimberlyton', 'VA', '81625', 'USA', 'Home', 3); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (65, 65, '2025-06-21', 1735.57, 462.83, 3, 'Excluded', '2025-07-01 17:41:36');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (66, 'David Taylor', 'gabriel59@example.com', '(880)321-8536x62461', '1981-04-02', 5, 'Processed', '2025-07-01 15:48:49');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (66, 'ACC000066', 66, 'Checking', '2022-06-04', 5548.98, 5, 'Pending', '2025-07-03 13:31');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (66, 66, '4531 Jones Mission', NULL, 'Hillton', 'ID', '55149', 'USA', 'Home', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (66, 66, '2025-06-27', 1707.66, 454.57, 5, 'Pending', '2025-07-01 12:28:08');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (67, 'Stephanie Cabrera', 'jacob70@example.com', '419.824.2922x4555', '1991-07-04', 3, 'Failed', '2025-07-04 03:21:51');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (67, 'ACC000067', 67, 'Savings', '2025-01-17', 8104.76, 3, 'Excluded', '2025-07-03 16:34');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (67, 67, '477 Benton Lights', NULL, 'Hunterton', 'NM', '91285', 'USA', 'Home', 3); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (67, 67, '2025-06-28', 1071.16, 4689.12, 3, 'Excluded', '2025-07-01 02:07:22');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (68, 'Makayla Powell', 'angelawalker@example.org', '001-723-908-9449x443', '1962-12-04', 3, 'Failed', '2025-07-03 08:13:58');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (68, 'ACC000068', 68, 'Loan', '2023-09-27', 1379.77, 3, 'Processed', '2025-06-29 13:39');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (68, 68, '23306 Steven Cape Suite 246', NULL, 'Kristinberg', 'NE', '12449', 'USA', 'Billing', 3); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (68, 68, '2025-06-30', -886.38, 2445.86, 3, 'Pending', '2025-07-02 01:09:54');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (69, 'Jeffrey Mcguire', 'hmueller@example.net', '680.631.5868', '1993-12-14', 5, 'Pending', '2025-07-02 14:25:45');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (69, 'ACC000069', 69, 'Loan', '2024-07-21', 3010.22, 5, 'Processed', '2025-07-01 04:33');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (69, 69, '1394 Amber Highway', NULL, 'Webbtown', 'IL', '94877', 'USA', 'Home', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (69, 69, '2025-06-24', 458.52, 119.7, 5, 'Processed', '2025-07-01 04:49:34');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (70, 'Brian Mitchell', 'wsmith@example.org', '8804867424', '1952-05-25', 2, 'Excluded', '2025-07-03 16:47:09');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (70, 'ACC000070', 70, 'Loan', '2023-05-17', 9290.21, 2, 'Pending', '2025-06-30 18:50');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (70, 70, '70932 Thompson Villages', NULL, 'Jaredtown', 'MA', '54159', 'USA', 'Work', 2); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (70, 70, '2025-06-13', 339.64, 4049.06, 2, 'Processed', '2025-06-30 12:47:42');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (71, 'Scott Jenkins', 'woodssharon@example.net', '328-808-2920x054', '1952-08-14', 5, 'Failed', '2025-07-01 06:28:38');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (71, 'ACC000071', 71, 'Checking', '2023-12-16', 2954.07, 5, 'Pending', '2025-06-29 21:09');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (71, 71, '092 Catherine Dam', NULL, 'Ballville', 'SD', '34420', 'USA', 'Billing', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (71, 71, '2025-06-21', -285.22, 1178.81, 5, 'Excluded', '2025-07-03 18:18:10');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (72, 'Madeline Davis', 'uwalters@example.org', '(537)689-6056', '1979-02-28', 1, 'Failed', '2025-07-01 12:09:41');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (72, 'ACC000072', 72, 'Loan', '2021-06-19', 8417.3, 1, 'Failed', '2025-06-30 22:57');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (72, 72, '29407 Victor Cape', NULL, 'Helenfort', 'NH', '72070', 'USA', 'Home', 1); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (72, 72, '2025-06-12', -526.75, 4543.43, 1, 'Failed', '2025-07-01 09:18:03');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (73, 'Jessica Mata', 'megan38@example.net', '(507)596-8921', '1973-01-22', 5, 'Excluded', '2025-07-01 05:05:10');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (73, 'ACC000073', 73, 'Loan', '2021-02-24', 7116.51, 5, 'Pending', '2025-07-03 13:30');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (73, 73, '422 Zuniga Extensions Apt. 698', NULL, 'West Cheryl', 'VT', '27231', 'USA', 'Work', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (73, 73, '2025-06-10', 1882.32, 767.48, 5, 'Excluded', '2025-07-01 13:55:06');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (74, 'Matthew Ponce', 'rachel95@example.org', '001-692-893-7728x1865', '1952-02-07', 2, 'Processed', '2025-06-30 23:46:19');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (74, 'ACC000074', 74, 'Savings', '2023-09-23', 174.54, 2, 'Pending', '2025-06-29 14:31');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (74, 74, '095 Smith Station Suite 346', NULL, 'New Helenshire', 'AR', '56756', 'USA', 'Home', 2); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (74, 74, '2025-06-09', -904.46, 3503.66, 2, 'Processed', '2025-07-02 04:47:13');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (75, 'Herbert Hernandez', 'lanebenjamin@example.net', '+1-923-200-0250x22603', '2000-02-05', 3, 'Processed', '2025-07-03 19:38:46');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (75, 'ACC000075', 75, 'Savings', '2025-01-27', 3809.01, 3, 'Failed', '2025-06-30 11:51');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (75, 75, '802 Brown Hills Apt. 811', NULL, 'Kristinfurt', 'CO', '67642', 'USA', 'Billing', 3); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (75, 75, '2025-06-12', 1760.46, 1660.34, 3, 'Failed', '2025-06-30 20:24:37');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (76, 'Michele Mayer', 'jennybautista@example.com', '975-969-3911x086', '1998-06-18', 5, 'Excluded', '2025-07-01 20:38:16');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (76, 'ACC000076', 76, 'Checking', '2023-12-28', 8927.72, 5, 'Excluded', '2025-07-02 02:45');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (76, 76, '2049 Ashley Meadow', NULL, 'North David', 'AK', '96529', 'USA', 'Shipping', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (76, 76, '2025-06-09', 1900.56, 4809.64, 5, 'Pending', '2025-07-01 14:54:45');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (77, 'Scott Cook', 'sabrina74@example.net', '870.918.2181x72743', '1996-01-05', 2, 'Failed', '2025-06-30 07:31:14');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (77, 'ACC000077', 77, 'Savings', '2023-07-17', 2082.88, 2, 'Failed', '2025-07-01 15:36');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (77, 77, '53891 Brent Pass', NULL, 'Lisamouth', 'WI', '19707', 'USA', 'Home', 2); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (77, 77, '2025-06-18', -95.23, 1249.44, 2, 'Excluded', '2025-06-30 05:43:44');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (78, 'Stephen Sanders', 'ijordan@example.com', '403-435-4167x67301', '1967-04-02', 1, 'Processed', '2025-07-04 05:52:43');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (78, 'ACC000078', 78, 'Loan', '2024-12-30', 3131.89, 1, 'Processed', '2025-06-30 05:01');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (78, 78, '80951 Joshua Forks', NULL, 'Edwardsburgh', 'FL', '92555', 'USA', 'Home', 1); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (78, 78, '2025-06-07', -115.71, 183.45, 1, 'Excluded', '2025-06-30 07:42:45');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (79, 'Anthony Phillips', 'moorewilliam@example.net', '(979)752-0330x493', '1968-05-21', 3, 'Excluded', '2025-07-02 13:27:42');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (79, 'ACC000079', 79, 'Savings', '2022-07-19', 139.59, 3, 'Pending', '2025-07-03 18:24');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (79, 79, '08305 Clark View Apt. 842', NULL, 'South Tamara', 'SD', '70517', 'USA', 'Shipping', 3); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (79, 79, '2025-06-29', -843.45, 3633.0, 3, 'Pending', '2025-07-01 15:31:32');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (80, 'Sandra Robles', 'hjimenez@example.com', '001-563-813-9090', '1984-02-20', 3, 'Processed', '2025-06-30 22:34:13');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (80, 'ACC000080', 80, 'Checking', '2021-07-23', 3846.63, 3, 'Failed', '2025-07-03 13:18');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (80, 80, '5096 Chad Lights Apt. 770', NULL, 'Lake Matthewville', 'KS', '43149', 'USA', 'Billing', 3); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (80, 80, '2025-07-02', 740.18, 3886.62, 3, 'Pending', '2025-07-04 11:53:41');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (81, 'Christopher Maldonado', 'joelmartinez@example.net', '(211)848-9158', '1978-08-05', 4, 'Pending', '2025-07-02 01:45:21');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (81, 'ACC000081', 81, 'Savings', '2024-12-20', 9786.91, 4, 'Excluded', '2025-06-29 23:45');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (81, 81, '4182 Galvan Forge', NULL, 'North Gregory', 'KS', '84191', 'USA', 'Home', 4); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (81, 81, '2025-06-06', -904.92, 2350.58, 4, 'Excluded', '2025-07-01 03:41:28');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (82, 'Gina Bowen', 'bennettcynthia@example.net', '809.670.5623x57841', '1975-05-12', 3, 'Excluded', '2025-07-02 10:54:30');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (82, 'ACC000082', 82, 'Savings', '2021-06-10', 7136.26, 3, 'Pending', '2025-07-03 04:11');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (82, 82, '9898 Garcia Village Apt. 779', NULL, 'Karenton', 'NC', '56569', 'USA', 'Home', 3); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (82, 82, '2025-06-23', 708.59, 4676.19, 3, 'Pending', '2025-07-02 13:57:19');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (83, 'Rebecca Williams', 'shane79@example.com', '+1-239-641-9061x0945', '1987-02-28', 2, 'Pending', '2025-07-01 13:25:21');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (83, 'ACC000083', 83, 'Checking', '2020-10-23', 6794.56, 2, 'Pending', '2025-06-30 22:48');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (83, 83, '913 Melissa Camp Suite 961', NULL, 'Jacksonberg', 'MH', '23584', 'USA', 'Billing', 2); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (83, 83, '2025-06-08', 886.85, 4530.91, 2, 'Pending', '2025-06-30 08:24:54');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (84, 'Dr. Amanda Fernandez', 'michael79@example.com', '575-358-2812x970', '1969-05-27', 1, 'Processed', '2025-06-30 16:03:36');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (84, 'ACC000084', 84, 'Savings', '2023-06-30', 9880.25, 1, 'Pending', '2025-06-30 23:08');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (84, 84, '861 Olson Road', NULL, 'Flynnland', 'HI', '68318', 'USA', 'Work', 1); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (84, 84, '2025-07-01', 408.46, 3555.55, 1, 'Excluded', '2025-07-03 04:22:47');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (85, 'John Hopkins', 'eatonfelicia@example.net', '723.979.7298x053', '1970-04-10', 4, 'Excluded', '2025-06-29 19:41:52');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (85, 'ACC000085', 85, 'Checking', '2023-07-12', 2239.36, 4, 'Failed', '2025-07-01 19:40');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (85, 85, '166 Lawrence Grove', NULL, 'New Richard', 'AS', '13184', 'USA', 'Billing', 4); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (85, 85, '2025-06-26', -496.25, 3336.89, 4, 'Excluded', '2025-07-03 23:47:57');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (86, 'Hannah Park', 'jjimenez@example.com', '(787)633-8046', '1956-09-10', 2, 'Processed', '2025-06-30 07:00:49');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (86, 'ACC000086', 86, 'Checking', '2023-06-26', 7700.63, 2, 'Excluded', '2025-06-30 02:42');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (86, 86, '1415 Diaz Hollow Apt. 588', NULL, 'North Roy', 'AZ', '83213', 'USA', 'Shipping', 2); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (86, 86, '2025-06-17', 1468.83, 4519.28, 2, 'Pending', '2025-07-01 04:22:59');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (87, 'Toni Moore', 'hartmannicholas@example.com', '(615)676-2204x50230', '1957-06-07', 5, 'Failed', '2025-06-29 13:55:05');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (87, 'ACC000087', 87, 'Checking', '2022-02-08', 7670.71, 5, 'Failed', '2025-07-01 14:02');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (87, 87, '30916 Trevor Rapids', NULL, 'Jessicamouth', 'OR', '92726', 'USA', 'Shipping', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (87, 87, '2025-06-08', -449.87, 3261.17, 5, 'Processed', '2025-07-02 15:38:54');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (88, 'Anthony Robinson', 'dianepatterson@example.com', '801-505-1757x7608', '2004-07-08', 5, 'Pending', '2025-07-03 00:03:36');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (88, 'ACC000088', 88, 'Savings', '2023-10-10', 9554.05, 5, 'Excluded', '2025-06-29 16:17');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (88, 88, '0576 Richardson Summit', NULL, 'New Allison', 'HI', '40872', 'USA', 'Shipping', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (88, 88, '2025-06-15', 468.48, 483.91, 5, 'Processed', '2025-07-01 09:04:51');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (89, 'Sonia Hill', 'michaelmann@example.org', '728.533.7888x3418', '1953-11-16', 3, 'Pending', '2025-07-03 13:31:10');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (89, 'ACC000089', 89, 'Checking', '2020-07-25', 8139.53, 3, 'Excluded', '2025-07-04 05:13');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (89, 89, '659 Hayes Park', NULL, 'Lake Cassie', 'WV', '40903', 'USA', 'Home', 3); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (89, 89, '2025-06-26', 550.57, 987.5, 3, 'Failed', '2025-06-30 15:47:00');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (90, 'Teresa Mcguire', 'nancyjackson@example.net', '(726)893-5770x422', '1972-03-04', 4, 'Processed', '2025-07-04 10:41:38');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (90, 'ACC000090', 90, 'Checking', '2024-02-15', 2920.7, 4, 'Failed', '2025-06-30 06:14');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (90, 90, '568 Kristi Villages Suite 105', NULL, 'Nortonfurt', 'VI', '79891', 'USA', 'Billing', 4); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (90, 90, '2025-06-28', 453.5, 2957.59, 4, 'Excluded', '2025-06-30 12:59:28');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (91, 'Kathryn Hickman', 'sanchezwilliam@example.org', '001-913-383-8112x3162', '1988-12-12', 4, 'Pending', '2025-07-02 00:21:14');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (91, 'ACC000091', 91, 'Checking', '2024-10-27', 7477.74, 4, 'Processed', '2025-07-01 22:23');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (91, 91, '9215 Teresa Parkways', NULL, 'Damonborough', 'NC', '45245', 'USA', 'Shipping', 4); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (91, 91, '2025-06-22', 1735.26, 4355.98, 4, 'Failed', '2025-06-29 17:40:49');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (92, 'Andrea Adams', 'watersrachael@example.com', '+1-475-319-9529x5225', '2005-11-07', 2, 'Pending', '2025-07-03 16:18:31');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (92, 'ACC000092', 92, 'Checking', '2022-08-31', 4821.31, 2, 'Processed', '2025-07-04 09:58');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (92, 92, '9679 Day Circles', NULL, 'North Cherylmouth', 'NC', '05315', 'USA', 'Home', 2); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (92, 92, '2025-06-10', 1871.98, 2144.98, 2, 'Excluded', '2025-07-04 01:26:42');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (93, 'Judy Long', 'doylecatherine@example.com', '537.777.1362', '1996-09-19', 5, 'Pending', '2025-07-01 20:24:52');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (93, 'ACC000093', 93, 'Checking', '2022-02-28', 3529.48, 5, 'Failed', '2025-07-04 02:53');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (93, 93, '245 Martinez Tunnel', NULL, 'Jennaport', 'DC', '75202', 'USA', 'Billing', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (93, 93, '2025-06-08', 477.63, 4547.29, 5, 'Failed', '2025-07-02 18:33:41');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (94, 'Gina Butler', 'christina94@example.org', '(301)810-6535', '1961-02-02', 3, 'Excluded', '2025-07-02 04:52:27');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (94, 'ACC000094', 94, 'Checking', '2021-04-22', 2224.77, 3, 'Pending', '2025-07-03 18:29');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (94, 94, '008 Jennifer Village', NULL, 'West Daniel', 'MH', '51664', 'USA', 'Home', 3); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (94, 94, '2025-06-29', 83.92, 4432.6, 3, 'Failed', '2025-07-03 09:48:03');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (95, 'David Nielsen', 'jenniferdickerson@example.net', '234-948-5897', '1970-03-13', 4, 'Processed', '2025-07-03 20:14:00');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (95, 'ACC000095', 95, 'Loan', '2025-05-27', 8253.96, 4, 'Processed', '2025-07-02 14:12');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (95, 95, '03824 Erickson Mall', NULL, 'Randallborough', 'VA', '25764', 'USA', 'Work', 4); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (95, 95, '2025-06-04', 1099.18, 1074.64, 4, 'Pending', '2025-07-02 18:42:11');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (96, 'Darrell Mack', 'jacob66@example.net', '001-253-236-6323x38120', '1955-11-13', 2, 'Pending', '2025-07-02 14:59:34');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (96, 'ACC000096', 96, 'Loan', '2023-05-05', 1789.97, 2, 'Excluded', '2025-06-30 09:31');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (96, 96, '35626 Ashley Estates Suite 498', NULL, 'Masonshire', 'ID', '07507', 'USA', 'Billing', 2); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (96, 96, '2025-06-29', 607.39, 624.3, 2, 'Excluded', '2025-06-30 12:41:08');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (97, 'Erica Parker', 'zthomas@example.org', '437-523-5938', '1978-03-14', 1, 'Excluded', '2025-06-29 16:51:53');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (97, 'ACC000097', 97, 'Savings', '2022-05-25', 9577.38, 1, 'Processed', '2025-07-01 15:31');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (97, 97, '764 Daniels Plaza Apt. 915', NULL, 'South Jennifer', 'SD', '70131', 'USA', 'Shipping', 1); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (97, 97, '2025-06-13', 599.33, 4558.37, 1, 'Excluded', '2025-07-04 08:24:06');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (98, 'Amy Smith', 'selenawilliams@example.net', '320-524-9526', '2005-05-23', 4, 'Excluded', '2025-07-01 23:04:31');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (98, 'ACC000098', 98, 'Loan', '2022-01-27', 1749.23, 4, 'Failed', '2025-07-04 06:40');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (98, 98, '5501 Monroe Heights', NULL, 'South Codyside', 'UT', '74997', 'USA', 'Shipping', 4); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (98, 98, '2025-06-08', 1220.48, 2715.53, 4, 'Processed', '2025-07-01 18:05:41');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (99, 'Kenneth Tanner', 'esmith@example.net', '970-600-4241', '1976-06-05', 3, 'Excluded', '2025-07-01 14:30:39');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (99, 'ACC000099', 99, 'Loan', '2024-04-22', 5062.18, 3, 'Failed', '2025-07-03 16:23');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (99, 99, '64795 Mccall Fields Suite 942', NULL, 'East Elizabeth', 'PR', '13021', 'USA', 'Work', 3); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (99, 99, '2025-06-06', 1385.77, 1806.37, 3, 'Failed', '2025-07-02 23:39:31');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (100, 'Stanley Green', 'brownrobert@example.net', '952.645.9991x39877', '2004-02-03', 4, 'Failed', '2025-06-29 23:26:42');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (100, 'ACC000100', 100, 'Savings', '2023-04-07', 8120.18, 4, 'Pending', '2025-07-03 07:06');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (100, 100, '5631 Stephen Stravenue Apt. 839', NULL, 'Scottchester', 'FM', '37951', 'USA', 'Shipping', 4); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (100, 100, '2025-06-18', -499.6, 1881.03, 4, 'Processed', '2025-07-04 01:23:45');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (101, 'Kenneth Hess', 'matthewmartinez@example.com', '001-809-894-0338', '1988-09-03', 4, 'Pending', '2025-07-03 20:45:34');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (101, 'ACC000101', 101, 'Loan', '2023-12-05', 9220.44, 4, 'Failed', '2025-06-29 21:32');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (101, 101, '71871 Juan Fords Suite 307', NULL, 'West Ashley', 'WA', '65356', 'USA', 'Billing', 4); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (101, 101, '2025-06-25', 1001.07, 4888.06, 4, 'Processed', '2025-07-01 01:21:04');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (102, 'Chad Frank', 'davisbrandi@example.com', '(515)457-2277x868', '1951-12-26', 1, 'Excluded', '2025-07-03 01:49:42');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (102, 'ACC000102', 102, 'Savings', '2025-01-16', 7088.0, 1, 'Pending', '2025-06-30 07:50');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (102, 102, '70791 David Overpass', NULL, 'Port Kevin', 'ME', '86301', 'USA', 'Work', 1); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (102, 102, '2025-06-08', 1323.4, 162.46, 1, 'Pending', '2025-06-30 23:37:08');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (103, 'Robin Schultz', 'snyderdavid@example.com', '840-731-3825x73920', '1966-05-26', 1, 'Failed', '2025-07-02 16:18:48');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (103, 'ACC000103', 103, 'Checking', '2024-02-04', 4360.71, 1, 'Pending', '2025-07-03 00:41');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (103, 103, '12429 Travis Knolls Suite 776', NULL, 'Lake Matthewport', 'AL', '69591', 'USA', 'Shipping', 1); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (103, 103, '2025-06-15', -626.1, 4823.29, 1, 'Processed', '2025-07-04 00:26:05');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (104, 'Kathryn Kidd', 'bschneider@example.net', '+1-371-691-5589x1114', '1975-09-10', 3, 'Processed', '2025-06-29 15:03:14');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (104, 'ACC000104', 104, 'Savings', '2021-10-05', 9073.98, 3, 'Excluded', '2025-06-30 19:45');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (104, 104, '268 Ryan Skyway', NULL, 'Port Michaelmouth', 'RI', '18373', 'USA', 'Billing', 3); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (104, 104, '2025-06-19', -653.64, 4667.79, 3, 'Processed', '2025-07-02 08:35:45');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (105, 'Laura Finley', 'codymanning@example.net', '660.226.8071', '1969-01-20', 2, 'Excluded', '2025-07-01 06:30:12');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (105, 'ACC000105', 105, 'Loan', '2022-10-24', 9361.12, 2, 'Failed', '2025-07-03 03:40');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (105, 105, '058 Tucker Island', NULL, 'West Victortown', 'SC', '36869', 'USA', 'Shipping', 2); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (105, 105, '2025-06-16', 1110.94, 3228.64, 2, 'Processed', '2025-07-01 06:07:45');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (106, 'Jennifer Wilson', 'idonovan@example.net', '+1-991-310-3704x86719', '1958-12-26', 2, 'Pending', '2025-06-30 14:15:40');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (106, 'ACC000106', 106, 'Savings', '2023-12-09', 5728.2, 2, 'Pending', '2025-07-01 16:27');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (106, 106, '670 Pena Ranch Apt. 467', NULL, 'South Christopher', 'IN', '98018', 'USA', 'Work', 2); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (106, 106, '2025-06-23', -363.05, 3773.45, 2, 'Excluded', '2025-06-29 22:18:16');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (107, 'Timothy Becker', 'mccormickmary@example.com', '303.791.6728x6721', '1987-05-20', 4, 'Processed', '2025-07-02 23:43:39');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (107, 'ACC000107', 107, 'Loan', '2023-01-31', 6633.1, 4, 'Processed', '2025-07-01 10:01');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (107, 107, '4132 Gibson Knolls', NULL, 'Danielchester', 'KY', '75534', 'USA', 'Shipping', 4); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (107, 107, '2025-06-25', 293.87, 37.35, 4, 'Failed', '2025-06-29 19:49:38');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (108, 'Edward Mclaughlin', 'lindaschmidt@example.net', '363.861.5068', '1989-04-07', 1, 'Processed', '2025-07-02 18:03:29');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (108, 'ACC000108', 108, 'Loan', '2022-10-14', 4551.09, 1, 'Pending', '2025-06-30 14:28');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (108, 108, '87042 Acevedo Loop', NULL, 'Burnsside', 'TX', '44231', 'USA', 'Billing', 1); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (108, 108, '2025-06-06', 914.02, 4080.08, 1, 'Pending', '2025-07-02 23:54:09');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (109, 'Susan Shields', 'adamboyd@example.org', '(490)972-2940x50095', '1995-01-18', 1, 'Pending', '2025-07-04 08:23:42');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (109, 'ACC000109', 109, 'Loan', '2022-03-31', 6304.73, 1, 'Excluded', '2025-06-29 14:34');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (109, 109, '294 Mark Plains', NULL, 'East Heathermouth', 'RI', '60607', 'USA', 'Shipping', 1); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (109, 109, '2025-06-16', 1928.33, 4396.75, 1, 'Excluded', '2025-07-01 07:43:14');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (110, 'Jamie Kim', 'dawnnelson@example.net', '7846773772', '1952-09-17', 5, 'Failed', '2025-07-03 00:33:50');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (110, 'ACC000110', 110, 'Loan', '2023-08-16', 8709.07, 5, 'Failed', '2025-07-03 00:49');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (110, 110, '4559 Michael Center', NULL, 'North Meredithbury', 'MP', '61970', 'USA', 'Billing', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (110, 110, '2025-06-14', -618.81, 4457.01, 5, 'Processed', '2025-07-03 14:49:39');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (111, 'Erin Anderson', 'maurice25@example.net', '001-468-602-5844', '1953-07-23', 2, 'Excluded', '2025-07-01 23:20:46');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (111, 'ACC000111', 111, 'Checking', '2024-05-22', 1236.67, 2, 'Processed', '2025-07-02 23:16');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (111, 111, '8296 Pearson Island', NULL, 'New Emilyshire', 'PW', '99926', 'USA', 'Shipping', 2); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (111, 111, '2025-06-30', 1606.76, 4503.74, 2, 'Excluded', '2025-07-03 19:22:33');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (112, 'Chase Hudson', 'kellyhester@example.org', '265-683-1859x5301', '1981-10-04', 3, 'Excluded', '2025-07-01 23:00:23');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (112, 'ACC000112', 112, 'Loan', '2022-04-17', 3870.07, 3, 'Pending', '2025-07-03 13:12');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (112, 112, '45811 Deleon Fork', NULL, 'South Elaineview', 'MD', '52117', 'USA', 'Shipping', 3); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (112, 112, '2025-06-26', 471.6, 3600.72, 3, 'Failed', '2025-07-02 11:29:24');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (113, 'Amy Anderson', 'herreradanielle@example.com', '(893)856-6950x55909', '1972-12-01', 5, 'Pending', '2025-07-03 22:44:39');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (113, 'ACC000113', 113, 'Savings', '2024-11-27', 8650.7, 5, 'Processed', '2025-07-01 03:26');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (113, 113, '176 Garcia Trail Apt. 684', NULL, 'Margaretland', 'OR', '08425', 'USA', 'Work', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (113, 113, '2025-06-07', 899.01, 3328.98, 5, 'Excluded', '2025-06-29 19:14:10');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (114, 'Gregory Hernandez', 'edwardsstacey@example.net', '372.637.8167x007', '2001-10-11', 3, 'Excluded', '2025-07-01 12:49:50');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (114, 'ACC000114', 114, 'Loan', '2022-04-03', 457.41, 3, 'Excluded', '2025-06-30 22:11');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (114, 114, '9003 Hughes Ferry', NULL, 'Mooreton', 'UT', '15020', 'USA', 'Billing', 3); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (114, 114, '2025-06-05', -355.71, 3798.69, 3, 'Processed', '2025-06-30 23:06:41');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (115, 'Carrie Anderson MD', 'kevin95@example.com', '410-871-5013x05094', '1972-12-13', 5, 'Processed', '2025-06-30 06:23:35');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (115, 'ACC000115', 115, 'Savings', '2022-03-24', 3821.14, 5, 'Pending', '2025-07-04 10:53');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (115, 115, '3160 Larson Light', NULL, 'Matthewsport', 'NC', '79051', 'USA', 'Work', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (115, 115, '2025-06-12', 588.02, 957.3, 5, 'Excluded', '2025-07-01 18:49:31');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (116, 'Stephanie Wheeler', 'omar84@example.com', '+1-755-409-1832x816', '2001-02-25', 1, 'Excluded', '2025-07-04 10:13:46');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (116, 'ACC000116', 116, 'Checking', '2021-02-21', 7006.5, 1, 'Pending', '2025-07-03 15:34');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (116, 116, '16708 Walker Wells Suite 710', NULL, 'Port Dwayne', 'MA', '18589', 'USA', 'Shipping', 1); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (116, 116, '2025-06-09', 532.47, 4747.79, 1, 'Processed', '2025-07-02 13:28:50');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (117, 'Tyler Burton', 'gentrykathleen@example.net', '822-355-3565', '1990-04-05', 2, 'Failed', '2025-07-02 21:11:14');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (117, 'ACC000117', 117, 'Checking', '2022-11-06', 7214.63, 2, 'Processed', '2025-06-30 02:12');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (117, 117, '0530 Tina Lock', NULL, 'Port Maryshire', 'AS', '08077', 'USA', 'Home', 2); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (117, 117, '2025-06-10', -423.31, 4404.52, 2, 'Excluded', '2025-07-02 09:30:43');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (118, 'Clinton Miller', 'timothy24@example.net', '(313)597-1930x371', '1952-12-12', 5, 'Pending', '2025-07-03 18:15:14');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (118, 'ACC000118', 118, 'Checking', '2022-05-19', 4565.83, 5, 'Excluded', '2025-07-02 00:18');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (118, 118, '824 Tucker Estates', NULL, 'Matthewstown', 'PW', '32572', 'USA', 'Billing', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (118, 118, '2025-06-19', 412.58, 2286.43, 5, 'Processed', '2025-07-03 17:14:23');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (119, 'Robert Mccall', 'ygarcia@example.net', '624.798.1479', '1991-06-09', 1, 'Processed', '2025-07-03 21:14:59');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (119, 'ACC000119', 119, 'Loan', '2024-07-15', 5661.26, 1, 'Failed', '2025-07-03 04:55');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (119, 119, '29564 Patrick Stravenue', NULL, 'Johnport', 'VI', '40914', 'USA', 'Shipping', 1); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (119, 119, '2025-06-28', 276.05, 4557.09, 1, 'Processed', '2025-07-02 04:13:31');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (120, 'Susan Smith', 'brookechavez@example.net', '(250)509-5777', '1992-10-29', 3, 'Excluded', '2025-06-30 09:00:32');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (120, 'ACC000120', 120, 'Loan', '2024-04-25', 9070.47, 3, 'Pending', '2025-07-01 07:21');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (120, 120, '45368 Tammy Keys', NULL, 'Lake Williammouth', 'VA', '28512', 'USA', 'Home', 3); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (120, 120, '2025-06-23', -273.7, 2939.7, 3, 'Failed', '2025-07-01 23:34:22');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (121, 'Jean Brown', 'bowmandaniel@example.org', '931-474-4265x28629', '1972-06-02', 4, 'Failed', '2025-06-30 21:43:55');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (121, 'ACC000121', 121, 'Checking', '2021-08-24', 5774.56, 4, 'Excluded', '2025-07-03 18:01');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (121, 121, '18608 Lisa Gateway', NULL, 'West Nicholas', 'KS', '14433', 'USA', 'Home', 4); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (121, 121, '2025-06-20', 769.98, 3371.47, 4, 'Processed', '2025-07-04 11:34:44');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (122, 'Jessica Dixon', 'jason56@example.org', '546-455-5027x327', '1984-09-10', 4, 'Processed', '2025-06-29 18:24:03');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (122, 'ACC000122', 122, 'Savings', '2025-03-19', 8602.21, 4, 'Pending', '2025-06-29 20:08');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (122, 122, '7407 Murillo Islands Suite 411', NULL, 'South Sydneyshire', 'RI', '11601', 'USA', 'Billing', 4); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (122, 122, '2025-06-30', 202.89, 514.71, 4, 'Processed', '2025-06-30 10:55:33');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (123, 'Michael Mills', 'pittsjames@example.com', '566.855.6194x29415', '1989-07-26', 3, 'Processed', '2025-07-03 08:05:23');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (123, 'ACC000123', 123, 'Checking', '2023-10-07', 3454.51, 3, 'Processed', '2025-07-03 20:42');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (123, 123, '67099 Jones Isle', NULL, 'Wilkinston', 'KY', '73046', 'USA', 'Work', 3); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (123, 123, '2025-06-16', -905.55, 4445.47, 3, 'Pending', '2025-07-01 14:14:13');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (124, 'Jean Jordan', 'ymalone@example.com', '+1-636-748-5474', '1989-07-03', 2, 'Pending', '2025-07-02 12:09:18');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (124, 'ACC000124', 124, 'Savings', '2024-06-25', 5774.21, 2, 'Excluded', '2025-07-02 03:24');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (124, 124, '69306 Dakota Square Suite 707', NULL, 'Hoganside', 'WV', '21788', 'USA', 'Billing', 2); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (124, 124, '2025-06-07', 908.63, 3232.62, 2, 'Failed', '2025-06-29 20:14:43');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (125, 'Amanda Miller', 'eric77@example.net', '(772)541-4974', '1977-04-06', 4, 'Failed', '2025-07-01 09:19:34');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (125, 'ACC000125', 125, 'Checking', '2023-06-12', 9445.18, 4, 'Excluded', '2025-07-03 00:59');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (125, 125, '596 Peter Route Apt. 557', NULL, 'Elliottmouth', 'CA', '46015', 'USA', 'Work', 4); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (125, 125, '2025-06-11', 353.9, 3458.19, 4, 'Failed', '2025-07-02 08:41:24');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (126, 'Mark Perkins', 'william57@example.net', '(615)629-3986x8732', '1993-11-21', 5, 'Excluded', '2025-07-03 16:41:36');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (126, 'ACC000126', 126, 'Savings', '2024-07-06', 3308.33, 5, 'Excluded', '2025-06-30 02:24');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (126, 126, '12413 David Viaduct', NULL, 'Daniellechester', 'WV', '56422', 'USA', 'Home', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (126, 126, '2025-06-07', 49.53, 4319.73, 5, 'Processed', '2025-07-04 05:03:33');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (127, 'David Nunez', 'bwelch@example.com', '001-744-276-4339x81339', '1997-07-30', 3, 'Processed', '2025-07-04 02:20:25');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (127, 'ACC000127', 127, 'Checking', '2022-01-29', 7923.29, 3, 'Excluded', '2025-06-30 00:38');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (127, 127, '794 Fox Overpass', NULL, 'Colehaven', 'FL', '24463', 'USA', 'Work', 3); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (127, 127, '2025-06-21', 1545.37, 4249.44, 3, 'Failed', '2025-07-02 03:59:11');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (128, 'Philip Campbell', 'leahwebster@example.com', '(530)988-7352', '1977-04-03', 5, 'Failed', '2025-07-03 14:51:37');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (128, 'ACC000128', 128, 'Savings', '2021-08-28', 6270.93, 5, 'Excluded', '2025-07-01 14:26');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (128, 128, '23482 Yvonne Port Suite 588', NULL, 'Christopherborough', 'AZ', '77458', 'USA', 'Work', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (128, 128, '2025-07-03', -945.2, 2244.23, 5, 'Processed', '2025-06-30 02:29:52');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (129, 'Shirley Braun', 'davisshannon@example.org', '(308)863-7737x753', '1986-09-21', 3, 'Failed', '2025-07-01 05:07:11');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (129, 'ACC000129', 129, 'Loan', '2020-12-30', 8141.59, 3, 'Pending', '2025-06-30 08:24');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (129, 129, '5374 Amanda Walks Suite 903', NULL, 'Port Patrick', 'NE', '47493', 'USA', 'Billing', 3); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (129, 129, '2025-06-16', 1715.26, 542.05, 3, 'Processed', '2025-07-04 01:41:08');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (130, 'Donna Stevens', 'kimberlysaunders@example.net', '7022988094', '1952-05-19', 4, 'Pending', '2025-06-30 20:52:52');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (130, 'ACC000130', 130, 'Checking', '2020-11-01', 499.79, 4, 'Pending', '2025-06-30 00:58');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (130, 130, '55352 Mitchell Dam Suite 627', NULL, 'North Laura', 'AS', '24146', 'USA', 'Billing', 4); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (130, 130, '2025-06-26', -240.92, 3662.79, 4, 'Excluded', '2025-07-03 21:17:55');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (131, 'Dana Graves', 'victor49@example.net', '848-770-5010x84144', '1987-01-30', 4, 'Failed', '2025-07-03 08:22:38');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (131, 'ACC000131', 131, 'Loan', '2024-03-17', 4713.0, 4, 'Excluded', '2025-07-02 15:31');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (131, 131, '481 Noble Inlet Suite 762', NULL, 'Cooleyville', 'NH', '19443', 'USA', 'Work', 4); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (131, 131, '2025-06-24', -927.01, 2002.71, 4, 'Failed', '2025-07-02 06:25:44');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (132, 'Sarah Davila', 'jhoward@example.com', '565.313.1761', '1983-11-15', 3, 'Failed', '2025-06-29 20:20:33');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (132, 'ACC000132', 132, 'Savings', '2020-09-04', 4949.18, 3, 'Processed', '2025-06-29 14:21');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (132, 132, '544 Jonathan Cliff', NULL, 'Stephenfort', 'OR', '84400', 'USA', 'Work', 3); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (132, 132, '2025-06-11', -387.21, 1606.37, 3, 'Failed', '2025-07-01 03:48:32');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (133, 'Joel Tran', 'gina97@example.org', '001-526-617-8685', '1979-05-13', 1, 'Failed', '2025-07-04 01:00:58');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (133, 'ACC000133', 133, 'Savings', '2022-04-27', 5226.94, 1, 'Excluded', '2025-06-29 18:06');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (133, 133, '247 Brian Canyon Apt. 197', NULL, 'Lake Colleen', 'CO', '43550', 'USA', 'Work', 1); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (133, 133, '2025-06-18', -142.77, 4503.18, 1, 'Excluded', '2025-06-29 16:34:37');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (134, 'Bryan Wade', 'tina71@example.com', '473.656.0820', '1985-12-31', 1, 'Processed', '2025-07-01 10:12:50');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (134, 'ACC000134', 134, 'Loan', '2022-01-04', 8179.9, 1, 'Pending', '2025-06-29 21:39');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (134, 134, '046 Hughes Shore', NULL, 'South Karenmouth', 'MI', '85601', 'USA', 'Shipping', 1); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (134, 134, '2025-06-28', 754.79, 4849.2, 1, 'Processed', '2025-06-29 22:26:12');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (135, 'James Little', 'warrenkevin@example.org', '+1-503-377-6279x429', '1972-06-13', 2, 'Failed', '2025-07-01 01:38:45');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (135, 'ACC000135', 135, 'Loan', '2022-10-31', 3344.46, 2, 'Failed', '2025-06-30 17:03');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (135, 135, '5536 Deborah Vista Suite 753', NULL, 'New Nicholas', 'NE', '21142', 'USA', 'Billing', 2); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (135, 135, '2025-06-11', -519.33, 4338.13, 2, 'Failed', '2025-07-03 15:37:06');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (136, 'Lisa Baldwin', 'amitchell@example.com', '(731)261-0997x56273', '1952-08-30', 1, 'Excluded', '2025-07-02 13:47:11');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (136, 'ACC000136', 136, 'Savings', '2022-10-02', 410.4, 1, 'Pending', '2025-07-02 08:08');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (136, 136, '715 Maddox Streets', NULL, 'New Robertmouth', 'ND', '95899', 'USA', 'Home', 1); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (136, 136, '2025-06-12', -434.87, 3396.66, 1, 'Processed', '2025-06-30 14:30:14');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (137, 'Denise Villarreal', 'collinsjack@example.com', '+1-878-539-2216x28142', '1988-11-25', 4, 'Processed', '2025-07-02 02:32:29');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (137, 'ACC000137', 137, 'Checking', '2025-03-27', 6236.18, 4, 'Processed', '2025-06-29 23:12');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (137, 137, '9535 Rachel Mall Suite 019', NULL, 'Port Kimberlyburgh', 'CO', '59618', 'USA', 'Billing', 4); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (137, 137, '2025-06-24', 1757.87, 776.24, 4, 'Excluded', '2025-06-30 21:51:38');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (138, 'Joanna Scott', 'james24@example.net', '725.312.8625', '1973-12-05', 4, 'Failed', '2025-06-30 20:53:19');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (138, 'ACC000138', 138, 'Checking', '2025-01-19', 9454.46, 4, 'Failed', '2025-07-01 14:27');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (138, 138, '054 Perry Mountains', NULL, 'Port Sandrahaven', 'MT', '05969', 'USA', 'Work', 4); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (138, 138, '2025-06-12', -280.18, 1676.31, 4, 'Processed', '2025-07-01 16:49:18');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (139, 'Todd Garcia', 'rodriguezchristopher@example.org', '678-405-5792', '1985-07-18', 5, 'Pending', '2025-07-02 20:09:47');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (139, 'ACC000139', 139, 'Loan', '2023-06-29', 4735.05, 5, 'Failed', '2025-07-01 16:59');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (139, 139, '1155 Robert Cliff', NULL, 'Ballardmouth', 'PA', '35463', 'USA', 'Work', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (139, 139, '2025-06-26', 200.93, 2996.91, 5, 'Pending', '2025-07-04 02:49:28');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (140, 'Jeffery Smith', 'wolfjay@example.net', '836.932.7916x750', '1950-04-24', 4, 'Failed', '2025-07-02 21:43:00');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (140, 'ACC000140', 140, 'Savings', '2021-02-04', 4801.81, 4, 'Failed', '2025-07-03 15:47');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (140, 140, '3793 Potter Corners', NULL, 'Port Kellyton', 'KS', '76428', 'USA', 'Home', 4); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (140, 140, '2025-07-01', 52.74, 4712.52, 4, 'Processed', '2025-07-02 20:11:04');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (141, 'Wendy Torres', 'fernandezronald@example.com', '+1-832-238-2244x572', '1954-11-30', 2, 'Processed', '2025-07-02 16:16:05');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (141, 'ACC000141', 141, 'Loan', '2024-09-18', 5051.17, 2, 'Excluded', '2025-07-04 08:20');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (141, 141, '9979 Todd Avenue Apt. 579', NULL, 'Lake Erin', 'OH', '38511', 'USA', 'Work', 2); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (141, 141, '2025-06-09', -783.34, 1101.88, 2, 'Failed', '2025-07-02 23:55:21');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (142, 'Patrick Jefferson', 'melaniehayes@example.org', '(502)720-4600x882', '1983-11-08', 1, 'Failed', '2025-06-30 15:58:44');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (142, 'ACC000142', 142, 'Loan', '2023-08-16', 2123.74, 1, 'Processed', '2025-07-02 11:59');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (142, 142, '101 David Hollow', NULL, 'Gonzaleztown', 'NJ', '06483', 'USA', 'Billing', 1); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (142, 142, '2025-06-11', 949.02, 2615.19, 1, 'Pending', '2025-07-03 02:27:09');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (143, 'Casey Smith', 'marcus32@example.com', '+1-971-328-1088x992', '1966-09-20', 3, 'Excluded', '2025-07-01 21:48:06');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (143, 'ACC000143', 143, 'Loan', '2020-11-02', 5877.23, 3, 'Pending', '2025-07-03 12:13');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (143, 143, '60851 Deborah Extension Suite 090', NULL, 'Michaelton', 'LA', '12627', 'USA', 'Billing', 3); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (143, 143, '2025-06-04', 881.85, 1291.26, 3, 'Failed', '2025-07-01 05:33:57');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (144, 'Victor Foster', 'rjohnson@example.com', '001-660-446-3489x949', '1980-04-18', 4, 'Pending', '2025-07-03 08:18:49');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (144, 'ACC000144', 144, 'Checking', '2023-04-23', 3451.86, 4, 'Failed', '2025-06-30 02:39');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (144, 144, '9126 Michael Cove', NULL, 'Nicoleland', 'IL', '72046', 'USA', 'Work', 4); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (144, 144, '2025-06-20', -753.13, 1180.5, 4, 'Failed', '2025-07-01 13:55:41');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (145, 'Kevin Bailey', 'wcarlson@example.net', '(889)658-3528x3647', '1958-07-28', 5, 'Pending', '2025-07-02 13:16:49');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (145, 'ACC000145', 145, 'Loan', '2021-06-30', 8606.79, 5, 'Failed', '2025-06-30 08:04');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (145, 145, '52655 Fleming Islands Suite 798', NULL, 'West Carol', 'SC', '71034', 'USA', 'Billing', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (145, 145, '2025-07-03', 1484.68, 2942.1, 5, 'Pending', '2025-07-04 05:50:30');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (146, 'Derrick Moore', 'michaelpollard@example.net', '(807)572-8733x3856', '1972-06-29', 4, 'Processed', '2025-07-02 15:04:54');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (146, 'ACC000146', 146, 'Checking', '2023-10-23', 8122.77, 4, 'Pending', '2025-07-01 14:29');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (146, 146, '22245 Tammy Summit Suite 577', NULL, 'Ernestshire', 'MA', '18901', 'USA', 'Home', 4); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (146, 146, '2025-06-14', 348.47, 4376.26, 4, 'Excluded', '2025-07-03 11:49:54');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (147, 'Eric Armstrong', 'stephencampbell@example.net', '789-804-0292', '1984-03-02', 4, 'Excluded', '2025-07-03 22:44:22');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (147, 'ACC000147', 147, 'Loan', '2024-05-02', 137.38, 4, 'Failed', '2025-07-02 17:48');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (147, 147, '6844 Janet Grove Apt. 660', NULL, 'New Robert', 'MP', '55592', 'USA', 'Shipping', 4); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (147, 147, '2025-06-21', 343.39, 2022.41, 4, 'Processed', '2025-07-02 08:42:43');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (148, 'Mrs. Emily Diaz MD', 'marymason@example.net', '001-970-251-0305x11124', '1984-06-06', 3, 'Processed', '2025-06-30 21:43:00');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (148, 'ACC000148', 148, 'Loan', '2024-10-09', 5216.16, 3, 'Failed', '2025-06-30 00:54');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (148, 148, '13782 Martin Way', NULL, 'New Lisa', 'DE', '23299', 'USA', 'Work', 3); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (148, 148, '2025-06-13', 1714.39, 4857.55, 3, 'Processed', '2025-06-30 03:47:40');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (149, 'Joanna Jackson', 'mark24@example.net', '+1-299-257-1695x64925', '1987-11-16', 1, 'Excluded', '2025-07-02 20:32:33');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (149, 'ACC000149', 149, 'Checking', '2020-09-21', 125.17, 1, 'Pending', '2025-07-02 13:38');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (149, 149, '3511 Denise Lodge Suite 782', NULL, 'West Stacey', 'SC', '78806', 'USA', 'Work', 1); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (149, 149, '2025-06-07', 1068.96, 1303.23, 1, 'Failed', '2025-06-30 07:29:53');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (150, 'Mary Whitaker', 'vnovak@example.net', '(342)804-0920', '1951-12-27', 1, 'Processed', '2025-07-03 09:24:35');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (150, 'ACC000150', 150, 'Savings', '2022-03-26', 2598.69, 1, 'Pending', '2025-07-04 07:30');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (150, 150, '72006 Martin Ports', NULL, 'Kaufmanstad', 'NV', '39465', 'USA', 'Home', 1); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (150, 150, '2025-07-02', 1350.41, 3932.0, 1, 'Failed', '2025-07-01 20:54:57');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (151, 'Todd Nelson', 'rachael18@example.org', '001-970-367-5027x169', '1986-03-28', 1, 'Pending', '2025-06-29 22:02:13');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (151, 'ACC000151', 151, 'Checking', '2022-05-27', 3544.46, 1, 'Failed', '2025-07-03 05:12');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (151, 151, '45097 Sullivan Orchard', NULL, 'New Jessicaborough', 'SC', '81027', 'USA', 'Work', 1); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (151, 151, '2025-06-23', -504.84, 1301.26, 1, 'Pending', '2025-07-04 10:21:23');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (152, 'Amy Petersen', 'harriskevin@example.org', '001-347-519-5211x132', '1986-09-09', 1, 'Pending', '2025-06-30 08:26:09');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (152, 'ACC000152', 152, 'Loan', '2021-07-09', 2528.14, 1, 'Processed', '2025-07-04 02:27');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (152, 152, '13973 Harris Mountain', NULL, 'West Robert', 'RI', '74906', 'USA', 'Home', 1); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (152, 152, '2025-06-18', 976.83, 3531.43, 1, 'Excluded', '2025-06-30 04:10:21');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (153, 'Marie Brown', 'fcamacho@example.org', '+1-857-547-5159x071', '2002-03-18', 3, 'Pending', '2025-06-29 22:31:17');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (153, 'ACC000153', 153, 'Checking', '2021-02-28', 8579.11, 3, 'Pending', '2025-07-02 10:08');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (153, 153, '8866 Riggs Bypass Apt. 808', NULL, 'West Sheila', 'GA', '87601', 'USA', 'Billing', 3); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (153, 153, '2025-06-04', 509.27, 1680.45, 3, 'Failed', '2025-07-04 09:07:36');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (154, 'Dr. Donna Miller', 'bdavid@example.net', '(693)800-4991', '1973-09-08', 3, 'Excluded', '2025-07-01 20:41:24');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (154, 'ACC000154', 154, 'Loan', '2024-03-29', 7674.46, 3, 'Pending', '2025-07-03 07:56');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (154, 154, '44442 Deanna Parkways', NULL, 'North Robertborough', 'ID', '96182', 'USA', 'Home', 3); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (154, 154, '2025-06-25', -356.29, 410.83, 3, 'Pending', '2025-07-02 21:07:24');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (155, 'Tara White', 'zrogers@example.org', '6566469685', '1974-01-09', 4, 'Failed', '2025-06-30 20:06:42');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (155, 'ACC000155', 155, 'Loan', '2022-03-11', 8338.86, 4, 'Excluded', '2025-07-01 13:20');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (155, 155, '0520 Adam Mountain', NULL, 'North Tamishire', 'MO', '67979', 'USA', 'Shipping', 4); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (155, 155, '2025-06-30', 489.78, 3849.16, 4, 'Failed', '2025-06-30 09:25:41');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (156, 'Beth Compton', 'wheelercynthia@example.net', '(564)745-5446x4964', '1983-05-10', 5, 'Processed', '2025-06-30 05:37:43');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (156, 'ACC000156', 156, 'Loan', '2022-01-14', 6004.2, 5, 'Excluded', '2025-06-30 13:09');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (156, 156, '1762 Phillips Lodge Apt. 391', NULL, 'Alexanderfurt', 'MN', '03525', 'USA', 'Home', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (156, 156, '2025-07-01', -949.73, 3308.99, 5, 'Failed', '2025-07-04 02:53:30');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (157, 'Logan Hicks', 'melissa58@example.net', '001-268-801-3900x989', '1983-03-04', 4, 'Processed', '2025-07-03 05:29:45');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (157, 'ACC000157', 157, 'Checking', '2021-11-18', 7761.39, 4, 'Excluded', '2025-07-02 10:03');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (157, 157, '1523 Kara Overpass Apt. 930', NULL, 'South Elizabethshire', 'AK', '77141', 'USA', 'Shipping', 4); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (157, 157, '2025-06-07', 1759.56, 1684.5, 4, 'Pending', '2025-07-02 16:00:32');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (158, 'Ms. Nancy Aguilar', 'anthonyweaver@example.net', '8718367908', '1977-01-17', 2, 'Excluded', '2025-07-03 21:54:53');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (158, 'ACC000158', 158, 'Loan', '2025-04-03', 1878.68, 2, 'Failed', '2025-07-01 06:12');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (158, 158, '60747 Eaton Tunnel', NULL, 'South Brian', 'GA', '37779', 'USA', 'Work', 2); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (158, 158, '2025-06-15', -355.1, 2938.99, 2, 'Pending', '2025-06-30 07:29:44');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (159, 'Jacob Shepard', 'michaelclarke@example.org', '(881)988-7134', '1994-10-24', 3, 'Processed', '2025-07-02 17:51:18');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (159, 'ACC000159', 159, 'Checking', '2024-04-29', 5403.28, 3, 'Pending', '2025-07-04 07:14');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (159, 159, '1178 Jerry Mall', NULL, 'Lake Dianeview', 'NM', '93206', 'USA', 'Home', 3); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (159, 159, '2025-06-26', 1410.41, 3387.18, 3, 'Excluded', '2025-07-01 14:14:37');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (160, 'Elizabeth Lopez', 'derek87@example.org', '001-854-278-1567x6559', '1992-05-07', 2, 'Processed', '2025-06-30 00:19:11');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (160, 'ACC000160', 160, 'Savings', '2023-08-22', 8081.81, 2, 'Failed', '2025-07-01 19:39');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (160, 160, '0405 Hector Locks', NULL, 'Samanthaton', 'CO', '90378', 'USA', 'Work', 2); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (160, 160, '2025-06-26', 611.2, 2207.77, 2, 'Failed', '2025-07-02 12:06:43');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (161, 'Kristina Jones', 'freemanholly@example.com', '+1-355-897-9425x05272', '1954-07-18', 1, 'Excluded', '2025-06-29 17:38:05');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (161, 'ACC000161', 161, 'Savings', '2024-11-27', 8133.44, 1, 'Failed', '2025-07-04 02:40');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (161, 161, '712 Alexander Passage', NULL, 'Boyerbury', 'NV', '79121', 'USA', 'Work', 1); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (161, 161, '2025-06-21', 412.51, 666.25, 1, 'Excluded', '2025-07-01 10:17:18');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (162, 'Felicia Nielsen', 'gbennett@example.com', '6218575800', '2004-09-21', 5, 'Pending', '2025-07-04 11:38:28');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (162, 'ACC000162', 162, 'Checking', '2023-09-05', 550.53, 5, 'Pending', '2025-07-02 19:56');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (162, 162, '933 Higgins Falls Suite 090', NULL, 'Jasonton', 'HI', '47389', 'USA', 'Home', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (162, 162, '2025-06-30', -555.39, 1278.34, 5, 'Pending', '2025-07-04 10:31:01');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (163, 'Tracy Ward', 'drichard@example.net', '380-655-5953x2721', '1953-02-08', 5, 'Processed', '2025-07-04 09:05:16');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (163, 'ACC000163', 163, 'Loan', '2021-03-14', 2874.68, 5, 'Failed', '2025-07-04 09:43');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (163, 163, '6048 Thomas Station Apt. 827', NULL, 'North Thomas', 'MH', '63112', 'USA', 'Work', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (163, 163, '2025-07-03', -440.94, 2496.33, 5, 'Pending', '2025-07-04 07:15:49');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (164, 'Adam Harris', 'crystallopez@example.org', '549.210.3377x1593', '1984-10-28', 5, 'Processed', '2025-07-03 11:37:03');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (164, 'ACC000164', 164, 'Checking', '2025-05-07', 7440.17, 5, 'Pending', '2025-06-30 16:43');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (164, 164, '55190 Byrd Knoll Apt. 677', NULL, 'West Kevinfurt', 'KY', '65091', 'USA', 'Work', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (164, 164, '2025-07-01', 946.57, 759.11, 5, 'Excluded', '2025-07-02 22:23:10');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (165, 'Debra Gibbs', 'jessicaowens@example.com', '(205)623-8082x5151', '1984-10-23', 5, 'Processed', '2025-07-01 05:31:00');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (165, 'ACC000165', 165, 'Savings', '2022-08-03', 6426.47, 5, 'Failed', '2025-07-04 10:11');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (165, 165, '390 Cunningham Village Suite 647', NULL, 'Lake Jenniferchester', 'NJ', '69877', 'USA', 'Shipping', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (165, 165, '2025-06-12', 1654.03, 2874.68, 5, 'Processed', '2025-07-02 19:32:58');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (166, 'Gary Medina', 'jparks@example.net', '514.844.0259x0605', '1983-09-04', 5, 'Failed', '2025-07-04 07:04:11');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (166, 'ACC000166', 166, 'Loan', '2023-03-31', 5239.21, 5, 'Pending', '2025-07-04 00:21');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (166, 166, '70291 Amanda Falls Apt. 758', NULL, 'West James', 'CA', '59164', 'USA', 'Work', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (166, 166, '2025-06-16', 451.71, 1722.03, 5, 'Pending', '2025-07-03 09:45:57');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (167, 'Thomas Pearson', 'lorraine16@example.net', '860.372.9497', '1996-10-02', 3, 'Processed', '2025-07-03 15:34:39');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (167, 'ACC000167', 167, 'Loan', '2024-07-06', 1791.91, 3, 'Excluded', '2025-06-29 21:16');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (167, 167, '993 Vasquez Dam Suite 208', NULL, 'North Ericchester', 'HI', '98600', 'USA', 'Shipping', 3); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (167, 167, '2025-07-03', 1933.19, 1632.57, 3, 'Processed', '2025-07-01 19:45:25');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (168, 'Alisha Parks', 'angelica63@example.com', '001-328-835-4423x332', '2004-08-25', 4, 'Excluded', '2025-07-03 14:17:39');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (168, 'ACC000168', 168, 'Checking', '2020-12-07', 4293.63, 4, 'Processed', '2025-07-04 02:22');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (168, 168, '310 Johnson Fork', NULL, 'Theresaville', 'DC', '99660', 'USA', 'Shipping', 4); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (168, 168, '2025-07-02', 797.9, 4775.43, 4, 'Pending', '2025-07-03 19:19:57');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (169, 'Brittany Meyer', 'umartinez@example.org', '742.753.1635', '1977-03-03', 4, 'Failed', '2025-07-02 18:22:43');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (169, 'ACC000169', 169, 'Checking', '2021-07-16', 4709.73, 4, 'Excluded', '2025-07-01 14:34');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (169, 169, '85657 Michael Land Suite 085', NULL, 'Copelandbury', 'FM', '15803', 'USA', 'Shipping', 4); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (169, 169, '2025-06-05', -313.32, 957.64, 4, 'Failed', '2025-07-03 16:05:08');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (170, 'Marc Torres', 'leekristen@example.org', '584-461-2991', '1955-10-03', 3, 'Excluded', '2025-07-01 04:18:36');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (170, 'ACC000170', 170, 'Savings', '2022-12-07', 5609.52, 3, 'Excluded', '2025-07-01 00:25');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (170, 170, '3595 Richmond Land', NULL, 'Hendersonbury', 'WI', '13865', 'USA', 'Home', 3); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (170, 170, '2025-06-22', 685.09, 4099.19, 3, 'Pending', '2025-06-29 20:34:05');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (171, 'Whitney Green', 'flee@example.net', '820-607-0999x0479', '1975-07-09', 1, 'Failed', '2025-07-01 05:31:55');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (171, 'ACC000171', 171, 'Savings', '2025-01-03', 9604.81, 1, 'Failed', '2025-07-02 17:10');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (171, 171, '4546 Kristin Parkways Apt. 126', NULL, 'Lesliebury', 'OK', '71806', 'USA', 'Shipping', 1); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (171, 171, '2025-07-01', 356.9, 3448.39, 1, 'Pending', '2025-07-01 23:35:57');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (172, 'Heidi Burns', 'kevincampbell@example.net', '693.575.8453x748', '1986-10-30', 5, 'Processed', '2025-06-30 21:47:13');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (172, 'ACC000172', 172, 'Checking', '2021-04-21', 6486.67, 5, 'Excluded', '2025-07-02 02:08');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (172, 172, '3624 Gray Plains', NULL, 'New Richard', 'KY', '45384', 'USA', 'Shipping', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (172, 172, '2025-06-21', -209.62, 1659.52, 5, 'Excluded', '2025-07-03 19:42:22');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (173, 'Benjamin Wilson', 'cookvictoria@example.com', '(446)504-9289x6401', '1969-09-03', 4, 'Pending', '2025-06-30 02:19:53');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (173, 'ACC000173', 173, 'Checking', '2024-04-09', 4165.36, 4, 'Pending', '2025-06-30 00:16');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (173, 173, '8965 Rodgers Views Suite 182', NULL, 'Rogersberg', 'NJ', '32749', 'USA', 'Shipping', 4); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (173, 173, '2025-06-16', 1779.97, 1136.58, 4, 'Pending', '2025-07-02 12:45:43');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (174, 'Thomas Yang', 'lcowan@example.net', '3317815726', '1982-11-06', 3, 'Excluded', '2025-07-03 09:56:08');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (174, 'ACC000174', 174, 'Savings', '2021-03-24', 2309.61, 3, 'Pending', '2025-07-03 05:08');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (174, 174, '29065 Lee Cliff', NULL, 'West Christopherside', 'AZ', '29341', 'USA', 'Billing', 3); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (174, 174, '2025-06-21', -667.48, 367.83, 3, 'Processed', '2025-07-01 00:22:24');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (175, 'Danielle Roy', 'eflores@example.com', '(797)327-3473x423', '1958-12-09', 1, 'Pending', '2025-07-03 06:52:40');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (175, 'ACC000175', 175, 'Checking', '2024-11-08', 8934.3, 1, 'Excluded', '2025-07-03 05:07');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (175, 175, '23810 Garcia Ridges', NULL, 'Torresport', 'WY', '66594', 'USA', 'Billing', 1); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (175, 175, '2025-06-28', 1034.72, 216.06, 1, 'Processed', '2025-07-02 21:08:50');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (176, 'Antonio White', 'smithchristopher@example.com', '001-728-862-5889x58883', '1986-02-01', 3, 'Excluded', '2025-07-03 15:11:51');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (176, 'ACC000176', 176, 'Loan', '2022-02-25', 4211.28, 3, 'Pending', '2025-07-02 23:48');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (176, 176, '1852 Wilson Landing Suite 631', NULL, 'East Michael', 'IA', '21954', 'USA', 'Work', 3); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (176, 176, '2025-06-20', -746.62, 2817.45, 3, 'Excluded', '2025-06-30 01:32:53');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (177, 'Michael Kelly', 'matthewshea@example.org', '6196518112', '1949-11-07', 5, 'Processed', '2025-06-30 21:18:00');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (177, 'ACC000177', 177, 'Checking', '2022-12-15', 3964.12, 5, 'Processed', '2025-07-01 11:15');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (177, 177, '230 Andrea Ford Apt. 220', NULL, 'Alvarezland', 'VA', '10377', 'USA', 'Shipping', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (177, 177, '2025-06-19', 615.07, 1701.96, 5, 'Failed', '2025-07-01 01:37:27');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (178, 'Joshua Spencer', 'kelly93@example.org', '319-806-4403x8928', '1991-11-30', 1, 'Failed', '2025-07-03 23:47:59');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (178, 'ACC000178', 178, 'Loan', '2022-02-15', 3571.37, 1, 'Excluded', '2025-07-02 03:27');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (178, 178, '7724 Brady Circle', NULL, 'Cristianmouth', 'IL', '02004', 'USA', 'Home', 1); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (178, 178, '2025-06-28', 1281.01, 3682.47, 1, 'Failed', '2025-07-03 22:11:22');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (179, 'Margaret Horton', 'christina84@example.com', '480.502.8296x74150', '1978-09-22', 4, 'Processed', '2025-07-04 11:40:20');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (179, 'ACC000179', 179, 'Checking', '2022-01-18', 7890.31, 4, 'Failed', '2025-07-01 07:32');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (179, 179, '93932 Burton Dale Apt. 005', NULL, 'New Williamchester', 'SD', '89045', 'USA', 'Work', 4); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (179, 179, '2025-06-07', -292.76, 403.41, 4, 'Pending', '2025-06-30 11:30:10');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (180, 'Rachel Guerra', 'clarkpeter@example.net', '(303)618-6214x7821', '1954-08-29', 1, 'Pending', '2025-06-30 01:04:07');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (180, 'ACC000180', 180, 'Loan', '2023-07-07', 6803.9, 1, 'Failed', '2025-07-04 11:54');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (180, 180, '855 Suarez Pass', NULL, 'North Trevormouth', 'OR', '47769', 'USA', 'Home', 1); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (180, 180, '2025-06-29', -543.21, 1924.87, 1, 'Failed', '2025-07-02 11:16:42');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (181, 'Kara Allen', 'henry61@example.com', '(638)550-3145', '1968-07-01', 4, 'Pending', '2025-07-02 19:46:10');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (181, 'ACC000181', 181, 'Savings', '2022-07-19', 3503.84, 4, 'Processed', '2025-07-02 17:58');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (181, 181, '627 Elliott Ford Suite 332', NULL, 'Briannahaven', 'MS', '73278', 'USA', 'Shipping', 4); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (181, 181, '2025-06-28', 1724.77, 418.65, 4, 'Failed', '2025-06-30 07:26:52');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (182, 'Jerry Reyes', 'vcruz@example.org', '946.270.8176', '2004-08-20', 4, 'Processed', '2025-07-02 18:57:06');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (182, 'ACC000182', 182, 'Savings', '2021-06-27', 1244.7, 4, 'Processed', '2025-07-02 09:19');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (182, 182, '53202 Thomas Meadows Suite 620', NULL, 'Kevinshire', 'FL', '99402', 'USA', 'Home', 4); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (182, 182, '2025-06-30', 789.37, 745.2, 4, 'Pending', '2025-07-01 22:14:28');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (183, 'Alison Gaines', 'tamara13@example.net', '(457)445-4920x30216', '1965-02-10', 5, 'Processed', '2025-07-04 05:40:30');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (183, 'ACC000183', 183, 'Checking', '2022-02-27', 6810.82, 5, 'Pending', '2025-07-03 07:25');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (183, 183, '23247 Jessica Courts', NULL, 'East Jose', 'MO', '76434', 'USA', 'Work', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (183, 183, '2025-06-05', -891.4, 4735.54, 5, 'Pending', '2025-07-02 18:01:23');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (184, 'Sydney Molina', 'guerrerojose@example.net', '810.540.1077', '1950-08-28', 5, 'Pending', '2025-07-03 13:27:00');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (184, 'ACC000184', 184, 'Savings', '2022-07-10', 4028.53, 5, 'Pending', '2025-07-01 14:24');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (184, 184, '2591 Benson Springs Apt. 448', NULL, 'Port Lori', 'IL', '43441', 'USA', 'Work', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (184, 184, '2025-06-08', 1716.49, 619.71, 5, 'Failed', '2025-07-01 06:02:38');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (185, 'Christopher Pope', 'wlindsey@example.com', '4206296325', '1994-03-13', 5, 'Processed', '2025-07-02 19:40:05');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (185, 'ACC000185', 185, 'Loan', '2025-05-11', 4451.01, 5, 'Excluded', '2025-06-29 17:25');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (185, 185, '3337 Benjamin Flat Suite 476', NULL, 'Gordonburgh', 'SC', '86984', 'USA', 'Home', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (185, 185, '2025-06-30', -745.02, 2647.73, 5, 'Excluded', '2025-06-30 01:27:10');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (186, 'Daniel Cohen', 'tiffany44@example.com', '+1-965-238-9691x0458', '1969-11-17', 1, 'Processed', '2025-07-01 09:22:18');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (186, 'ACC000186', 186, 'Loan', '2021-12-17', 4989.82, 1, 'Processed', '2025-07-02 16:55');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (186, 186, '06424 Ruiz Villages Suite 230', NULL, 'New Matthewchester', 'CA', '89294', 'USA', 'Home', 1); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (186, 186, '2025-06-14', -865.78, 2161.29, 1, 'Processed', '2025-07-04 09:25:27');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (187, 'Ronald Martin', 'jonathandeleon@example.com', '+1-887-934-7507', '1988-07-03', 4, 'Excluded', '2025-07-03 05:18:06');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (187, 'ACC000187', 187, 'Savings', '2023-09-12', 269.3, 4, 'Pending', '2025-06-30 15:38');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (187, 187, '16453 Michael Parks', NULL, 'Tammyberg', 'DC', '75133', 'USA', 'Shipping', 4); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (187, 187, '2025-06-07', 1882.58, 4186.75, 4, 'Excluded', '2025-07-01 11:40:04');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (188, 'Pamela Sherman', 'loganbryan@example.org', '001-537-516-1849', '1981-11-18', 4, 'Excluded', '2025-07-02 04:53:59');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (188, 'ACC000188', 188, 'Checking', '2021-03-06', 9393.56, 4, 'Excluded', '2025-07-03 08:30');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (188, 188, '08318 David Pike Suite 583', NULL, 'Jordanmouth', 'AL', '47210', 'USA', 'Billing', 4); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (188, 188, '2025-06-15', 1088.07, 889.03, 4, 'Processed', '2025-07-02 07:36:52');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (189, 'Jessica Martinez', 'qanthony@example.net', '445.714.3619x799', '2004-03-04', 1, 'Pending', '2025-07-04 03:09:46');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (189, 'ACC000189', 189, 'Checking', '2023-04-27', 1178.04, 1, 'Failed', '2025-07-02 15:56');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (189, 189, '41844 Andrew Avenue', NULL, 'North Teresamouth', 'LA', '33927', 'USA', 'Home', 1); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (189, 189, '2025-07-03', 556.48, 213.81, 1, 'Failed', '2025-07-02 23:12:10');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (190, 'Kim Anderson', 'tracie85@example.net', '261-883-7214x28072', '1961-11-27', 2, 'Excluded', '2025-06-30 17:45:04');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (190, 'ACC000190', 190, 'Savings', '2025-04-09', 5281.3, 2, 'Failed', '2025-07-03 23:39');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (190, 190, '63457 Gregory Ways Suite 722', NULL, 'North Carol', 'SC', '62633', 'USA', 'Work', 2); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (190, 190, '2025-06-27', 40.09, 4871.2, 2, 'Excluded', '2025-07-01 08:55:51');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (191, 'Michelle Wright', 'phebert@example.net', '(711)764-3115x34710', '1973-08-28', 5, 'Processed', '2025-07-02 01:40:39');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (191, 'ACC000191', 191, 'Savings', '2024-12-16', 6573.56, 5, 'Pending', '2025-07-01 18:07');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (191, 191, '490 Christian Trail', NULL, 'Stevensside', 'PR', '29914', 'USA', 'Work', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (191, 191, '2025-06-11', 755.21, 4151.09, 5, 'Pending', '2025-07-03 09:11:29');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (192, 'Samantha Anderson', 'trobinson@example.com', '001-940-538-0810x930', '1994-08-15', 1, 'Pending', '2025-07-02 16:48:48');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (192, 'ACC000192', 192, 'Loan', '2025-01-14', 8310.9, 1, 'Processed', '2025-07-02 14:53');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (192, 192, '0766 James Road Apt. 411', NULL, 'Tracieshire', 'FL', '31426', 'USA', 'Shipping', 1); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (192, 192, '2025-06-17', 1575.43, 1349.38, 1, 'Processed', '2025-06-29 16:54:11');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (193, 'Brad Reeves', 'palmerphillip@example.org', '+1-704-647-6367x052', '1993-03-02', 3, 'Pending', '2025-06-30 23:39:53');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (193, 'ACC000193', 193, 'Loan', '2025-03-26', 801.52, 3, 'Pending', '2025-07-03 23:19');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (193, 193, '602 Rebecca Terrace', NULL, 'New Kevin', 'MO', '91909', 'USA', 'Shipping', 3); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (193, 193, '2025-06-09', 1183.59, 1122.59, 3, 'Processed', '2025-07-03 15:45:01');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (194, 'Hannah Hill', 'stephanie17@example.net', '(643)831-3746x734', '2000-05-28', 4, 'Processed', '2025-06-30 17:22:50');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (194, 'ACC000194', 194, 'Checking', '2024-05-25', 9821.28, 4, 'Failed', '2025-07-03 04:43');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (194, 194, '9616 Hanna Place', NULL, 'Lucasburgh', 'WV', '15536', 'USA', 'Billing', 4); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (194, 194, '2025-06-04', 1370.9, 2907.06, 4, 'Excluded', '2025-07-02 17:14:23');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (195, 'Angela Dominguez', 'rsimmons@example.org', '304-237-1158x387', '1951-10-21', 4, 'Processed', '2025-06-29 17:52:14');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (195, 'ACC000195', 195, 'Savings', '2020-08-28', 2908.98, 4, 'Excluded', '2025-06-30 04:09');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (195, 195, '83937 Hernandez Hills Apt. 299', NULL, 'Wilsonstad', 'AK', '50017', 'USA', 'Shipping', 4); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (195, 195, '2025-07-02', -938.45, 1243.28, 4, 'Failed', '2025-07-02 05:38:14');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (196, 'Andrew Meyer', 'jessica03@example.net', '7035142073', '1970-10-22', 1, 'Processed', '2025-07-02 05:35:38');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (196, 'ACC000196', 196, 'Loan', '2025-05-31', 2840.98, 1, 'Pending', '2025-06-30 18:57');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (196, 196, '7809 Kevin Rue Suite 818', NULL, 'South Taylortown', 'MH', '94194', 'USA', 'Work', 1); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (196, 196, '2025-06-07', 1933.47, 434.81, 1, 'Excluded', '2025-07-01 17:33:53');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (197, 'Barry Stewart', 'ethanhayden@example.net', '352-435-9030', '1949-09-12', 4, 'Pending', '2025-06-30 20:50:16');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (197, 'ACC000197', 197, 'Loan', '2024-08-19', 7869.31, 4, 'Failed', '2025-07-01 14:40');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (197, 197, '88237 Daniel Hollow Suite 654', NULL, 'New Kyletown', 'VT', '60468', 'USA', 'Billing', 4); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (197, 197, '2025-06-19', 1090.0, 4479.97, 4, 'Processed', '2025-07-01 02:42:42');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (198, 'Melissa Holden', 'smithnicholas@example.org', '583.489.8879', '1962-02-08', 4, 'Pending', '2025-06-30 08:27:03');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (198, 'ACC000198', 198, 'Savings', '2025-01-15', 5916.3, 4, 'Processed', '2025-07-04 08:05');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (198, 198, '186 Russell Ridge', NULL, 'Craigland', 'TX', '23336', 'USA', 'Billing', 4); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (198, 198, '2025-07-03', 1182.98, 761.67, 4, 'Pending', '2025-07-01 18:34:14');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (199, 'Laura Goodman', 'kimberlyrojas@example.com', '855.889.3417', '1975-04-15', 1, 'Excluded', '2025-07-01 01:48:42');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (199, 'ACC000199', 199, 'Savings', '2024-01-18', 4257.8, 1, 'Processed', '2025-07-02 06:35');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (199, 199, '94876 Walker Ramp', NULL, 'East Nicole', 'MD', '81867', 'USA', 'Shipping', 1); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (199, 199, '2025-06-25', -504.61, 1458.4, 1, 'Failed', '2025-07-02 17:20:24');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (200, 'Paula Pacheco', 'paige19@example.net', '275.562.8256x00388', '1977-04-03', 2, 'Processed', '2025-07-02 18:29:34');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (200, 'ACC000200', 200, 'Savings', '2021-02-21', 7327.11, 2, 'Excluded', '2025-07-03 08:59');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (200, 200, '76133 Tina Mission Apt. 053', NULL, 'North Jenniferville', 'CA', '12153', 'USA', 'Work', 2); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (200, 200, '2025-06-21', 474.72, 2069.03, 2, 'Excluded', '2025-07-04 05:05:45');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (201, 'Marie Reynolds', 'kyleharvey@example.net', '001-838-751-2787x078', '1962-11-25', 4, 'Pending', '2025-07-01 14:13:11');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (201, 'ACC000201', 201, 'Checking', '2021-12-18', 6858.27, 4, 'Failed', '2025-07-04 04:39');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (201, 201, '798 Ramos Mountain Suite 196', NULL, 'Thompsonside', 'MA', '72258', 'USA', 'Billing', 4); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (201, 201, '2025-06-16', 180.71, 3724.11, 4, 'Failed', '2025-07-03 14:21:43');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (202, 'Keith Jimenez', 'sparksbrian@example.net', '001-391-963-0609', '1974-09-23', 2, 'Excluded', '2025-07-01 04:33:24');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (202, 'ACC000202', 202, 'Loan', '2022-11-29', 8838.29, 2, 'Processed', '2025-07-03 09:04');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (202, 202, '5080 Daniel Corner Suite 932', NULL, 'Steinview', 'NV', '59024', 'USA', 'Home', 2); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (202, 202, '2025-06-15', 850.6, 4126.78, 2, 'Processed', '2025-07-02 09:19:00');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (203, 'Lindsey Washington', 'christinawright@example.org', '(357)844-0589', '2002-10-16', 1, 'Failed', '2025-07-01 04:42:47');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (203, 'ACC000203', 203, 'Savings', '2022-07-08', 8514.71, 1, 'Excluded', '2025-07-03 11:13');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (203, 203, '8474 Yesenia Dam', NULL, 'Lake Jeffrey', 'MH', '32818', 'USA', 'Billing', 1); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (203, 203, '2025-06-28', 819.88, 4721.35, 1, 'Excluded', '2025-07-01 04:47:29');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (204, 'Alfred Garcia', 'mark46@example.com', '221.287.5134x02060', '1958-07-06', 1, 'Excluded', '2025-07-02 08:24:02');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (204, 'ACC000204', 204, 'Savings', '2021-02-23', 4581.22, 1, 'Processed', '2025-07-01 22:34');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (204, 204, '70369 Johnson Shores Suite 412', NULL, 'East Brianhaven', 'NH', '52267', 'USA', 'Work', 1); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (204, 204, '2025-07-03', -578.19, 1356.66, 1, 'Failed', '2025-06-30 13:35:34');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (205, 'Ryan Clay', 'james98@example.com', '(500)921-8396x64700', '1969-08-06', 2, 'Failed', '2025-07-03 07:22:01');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (205, 'ACC000205', 205, 'Savings', '2023-02-05', 6728.03, 2, 'Pending', '2025-07-03 06:06');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (205, 205, '41347 Brown Plaza Apt. 559', NULL, 'Port Danielfort', 'TN', '67127', 'USA', 'Home', 2); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (205, 205, '2025-07-01', 1537.9, 3869.82, 2, 'Failed', '2025-07-01 15:52:32');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (206, 'Angela Garza', 'lisa99@example.net', '+1-894-808-1600x387', '2002-08-14', 2, 'Excluded', '2025-07-04 08:25:20');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (206, 'ACC000206', 206, 'Loan', '2021-05-16', 2203.16, 2, 'Failed', '2025-07-04 09:06');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (206, 206, '103 Angela Fall', NULL, 'Williamfort', 'NJ', '93194', 'USA', 'Home', 2); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (206, 206, '2025-06-16', -101.95, 602.57, 2, 'Excluded', '2025-07-03 12:22:02');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (207, 'Carrie Allen', 'willisjennifer@example.com', '950.228.4062', '1980-02-28', 2, 'Excluded', '2025-07-01 04:30:05');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (207, 'ACC000207', 207, 'Loan', '2020-10-20', 7539.8, 2, 'Pending', '2025-07-03 02:26');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (207, 207, '9455 Grant Avenue', NULL, 'South Austinfort', 'UT', '65611', 'USA', 'Billing', 2); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (207, 207, '2025-06-20', -950.83, 258.08, 2, 'Excluded', '2025-06-30 03:22:03');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (208, 'Richard Munoz', 'harrisjose@example.com', '+1-717-428-0494', '2004-09-04', 4, 'Excluded', '2025-07-02 22:27:37');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (208, 'ACC000208', 208, 'Checking', '2025-03-30', 6184.65, 4, 'Pending', '2025-06-29 19:31');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (208, 208, '152 Rebecca Square Suite 334', NULL, 'Medinastad', 'VA', '80657', 'USA', 'Billing', 4); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (208, 208, '2025-06-12', 598.06, 855.07, 4, 'Processed', '2025-07-02 04:14:24');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (209, 'Mrs. Rebecca Clark', 'kimberlyjackson@example.com', '001-222-239-6492x5896', '1984-05-05', 5, 'Processed', '2025-07-01 06:25:39');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (209, 'ACC000209', 209, 'Loan', '2024-06-04', 2421.98, 5, 'Pending', '2025-07-02 11:20');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (209, 209, '04545 Pamela Parkways Apt. 075', NULL, 'Jessefurt', 'RI', '33473', 'USA', 'Home', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (209, 209, '2025-06-20', -907.84, 3833.1, 5, 'Excluded', '2025-07-02 06:01:12');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (210, 'Meghan Lopez', 'eddie61@example.org', '(277)815-4445x02048', '1974-04-06', 5, 'Pending', '2025-06-29 18:47:31');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (210, 'ACC000210', 210, 'Loan', '2024-09-13', 5942.59, 5, 'Pending', '2025-07-03 21:20');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (210, 210, '33992 Alvarez Path', NULL, 'Alejandrotown', 'IL', '32683', 'USA', 'Home', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (210, 210, '2025-06-04', 578.13, 384.45, 5, 'Pending', '2025-07-01 12:09:11');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (211, 'Timothy Johnson', 'pattonlinda@example.com', '+1-303-961-7028x5299', '1952-10-25', 2, 'Failed', '2025-06-30 01:29:35');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (211, 'ACC000211', 211, 'Savings', '2022-07-26', 6953.57, 2, 'Processed', '2025-06-30 21:32');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (211, 211, '09761 Ross Knolls Apt. 109', NULL, 'East Mason', 'HI', '04317', 'USA', 'Billing', 2); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (211, 211, '2025-07-02', 1729.86, 3158.83, 2, 'Failed', '2025-07-03 00:54:57');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (212, 'Katherine Alvarado', 'lewistiffany@example.net', '+1-997-792-0906', '1953-06-20', 1, 'Failed', '2025-06-30 21:57:10');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (212, 'ACC000212', 212, 'Checking', '2023-01-23', 1076.86, 1, 'Processed', '2025-06-29 15:31');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (212, 212, '56170 Jacqueline Trace', NULL, 'Port Zacharyborough', 'RI', '85390', 'USA', 'Shipping', 1); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (212, 212, '2025-06-20', 1743.23, 1098.59, 1, 'Excluded', '2025-06-30 21:30:45');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (213, 'Amy Brooks', 'simpsonclaudia@example.com', '604.715.1304', '1994-08-06', 3, 'Processed', '2025-06-29 22:57:25');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (213, 'ACC000213', 213, 'Loan', '2021-06-06', 9398.61, 3, 'Pending', '2025-07-01 12:52');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (213, 213, '7565 Melissa Valley Suite 626', NULL, 'Daniellestad', 'ND', '61089', 'USA', 'Work', 3); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (213, 213, '2025-06-17', -714.28, 1635.32, 3, 'Excluded', '2025-06-30 07:55:00');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (214, 'Ryan Rodriguez', 'sullivannicholas@example.com', '479-376-7780x92923', '1985-12-11', 5, 'Failed', '2025-07-04 10:08:13');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (214, 'ACC000214', 214, 'Savings', '2024-01-16', 6514.15, 5, 'Pending', '2025-07-04 08:59');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (214, 214, '26567 Sarah Turnpike Apt. 834', NULL, 'South Justinville', 'NH', '08644', 'USA', 'Billing', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (214, 214, '2025-06-29', -291.01, 1635.95, 5, 'Excluded', '2025-06-30 08:34:03');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (215, 'Jason Patrick', 'lukefrancis@example.org', '+1-488-770-9649', '1955-11-12', 2, 'Pending', '2025-07-02 17:02:47');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (215, 'ACC000215', 215, 'Loan', '2022-08-23', 538.86, 2, 'Pending', '2025-07-01 18:10');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (215, 215, '077 Walker Falls Apt. 936', NULL, 'Port Johnshire', 'CA', '31655', 'USA', 'Work', 2); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (215, 215, '2025-07-03', 1747.58, 3242.13, 2, 'Failed', '2025-07-01 20:34:43');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (216, 'Trevor Jones', 'belindacummings@example.org', '(846)213-3052x49856', '1985-02-10', 4, 'Pending', '2025-07-02 10:52:30');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (216, 'ACC000216', 216, 'Checking', '2021-02-04', 5465.32, 4, 'Processed', '2025-07-03 21:14');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (216, 216, '32070 Ricky Causeway', NULL, 'Saraland', 'VI', '33187', 'USA', 'Work', 4); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (216, 216, '2025-06-17', 1306.99, 73.7, 4, 'Processed', '2025-07-03 03:53:50');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (217, 'Dylan Johnson', 'jennifer75@example.org', '450-963-5494', '1981-02-26', 1, 'Pending', '2025-07-03 13:50:08');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (217, 'ACC000217', 217, 'Savings', '2020-10-09', 3833.54, 1, 'Excluded', '2025-07-01 14:00');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (217, 217, '148 May Cove', NULL, 'East Chadfort', 'MS', '20454', 'USA', 'Billing', 1); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (217, 217, '2025-07-03', 1330.15, 36.73, 1, 'Failed', '2025-06-29 19:22:59');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (218, 'Linda Murray', 'daniel48@example.com', '+1-302-352-5747x18926', '2006-02-07', 1, 'Excluded', '2025-06-30 14:14:40');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (218, 'ACC000218', 218, 'Loan', '2020-10-17', 4207.3, 1, 'Failed', '2025-07-02 02:59');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (218, 218, '5986 Meredith Course Apt. 948', NULL, 'Jimenezton', 'MS', '14877', 'USA', 'Work', 1); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (218, 218, '2025-06-21', -617.62, 3230.61, 1, 'Pending', '2025-07-03 14:47:11');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (219, 'Tara Lopez', 'ywang@example.com', '863.660.9655', '1964-01-30', 5, 'Excluded', '2025-07-03 17:40:17');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (219, 'ACC000219', 219, 'Checking', '2020-12-08', 7406.33, 5, 'Processed', '2025-06-30 18:41');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (219, 219, '37025 Parks Port Apt. 046', NULL, 'Lake Patrickhaven', 'MD', '71576', 'USA', 'Home', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (219, 219, '2025-06-10', -939.35, 880.32, 5, 'Processed', '2025-07-04 05:28:40');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (220, 'Sara Bowman', 'hstrong@example.org', '001-536-975-3873x1491', '1970-12-29', 4, 'Pending', '2025-06-30 15:14:33');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (220, 'ACC000220', 220, 'Savings', '2024-05-27', 7907.03, 4, 'Failed', '2025-07-01 20:57');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (220, 220, '429 Smith Ridges', NULL, 'North Craig', 'PW', '41496', 'USA', 'Billing', 4); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (220, 220, '2025-06-05', 745.19, 2327.51, 4, 'Excluded', '2025-06-29 22:06:13');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (221, 'Caroline Garcia', 'rnorton@example.org', '001-646-988-6003x08302', '1996-08-04', 1, 'Pending', '2025-06-30 18:45:24');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (221, 'ACC000221', 221, 'Checking', '2021-03-06', 1486.29, 1, 'Failed', '2025-06-30 12:15');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (221, 221, '4468 Kenneth Junction Suite 035', NULL, 'Levinetown', 'WV', '97525', 'USA', 'Work', 1); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (221, 221, '2025-06-17', 257.48, 2597.14, 1, 'Failed', '2025-07-02 07:51:06');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (222, 'Christine Hughes', 'montgomeryheidi@example.net', '660.498.2159x2893', '1994-11-03', 3, 'Failed', '2025-06-29 20:26:52');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (222, 'ACC000222', 222, 'Checking', '2022-01-26', 8809.92, 3, 'Excluded', '2025-07-01 01:36');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (222, 222, '60296 Stevenson Knolls', NULL, 'Lisafurt', 'GU', '19662', 'USA', 'Shipping', 3); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (222, 222, '2025-06-08', 68.63, 825.0, 3, 'Failed', '2025-07-02 13:09:13');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (223, 'Michael Chapman', 'davidwhite@example.net', '(278)847-0062x8063', '1964-07-20', 5, 'Processed', '2025-07-02 17:20:28');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (223, 'ACC000223', 223, 'Loan', '2020-09-05', 875.53, 5, 'Failed', '2025-07-02 12:01');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (223, 223, '81518 April Valley', NULL, 'Walshland', 'KY', '17023', 'USA', 'Home', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (223, 223, '2025-06-17', 861.67, 4084.96, 5, 'Pending', '2025-07-04 00:10:02');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (224, 'Suzanne Davis', 'andersonjanice@example.org', '+1-418-349-9915', '1997-06-10', 2, 'Failed', '2025-07-03 16:21:46');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (224, 'ACC000224', 224, 'Savings', '2021-02-18', 4029.18, 2, 'Failed', '2025-06-30 05:48');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (224, 224, '9646 Mendoza Views Apt. 957', NULL, 'North Cheryl', 'NH', '93778', 'USA', 'Shipping', 2); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (224, 224, '2025-06-13', -259.4, 3194.12, 2, 'Pending', '2025-06-30 00:04:51');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (225, 'Mark Oconnor', 'ortizjesse@example.com', '398.641.3948', '1988-04-28', 5, 'Pending', '2025-06-30 08:10:56');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (225, 'ACC000225', 225, 'Checking', '2022-09-28', 565.86, 5, 'Pending', '2025-07-02 03:34');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (225, 225, '049 Harvey Mills', NULL, 'New Jackshire', 'ID', '68197', 'USA', 'Shipping', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (225, 225, '2025-06-04', 143.32, 782.43, 5, 'Processed', '2025-06-29 22:03:25');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (226, 'Renee Donaldson', 'xpope@example.net', '(543)692-5455x115', '1963-08-14', 4, 'Excluded', '2025-07-02 10:24:49');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (226, 'ACC000226', 226, 'Loan', '2022-01-18', 6860.16, 4, 'Failed', '2025-07-02 09:02');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (226, 226, '89649 Edwards Hollow Suite 216', NULL, 'East Keith', 'SC', '95555', 'USA', 'Home', 4); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (226, 226, '2025-06-16', 802.14, 1654.48, 4, 'Excluded', '2025-06-30 03:34:31');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (227, 'Tracie Banks', 'martinezpatricia@example.org', '+1-917-480-8738', '1973-01-01', 2, 'Processed', '2025-06-30 00:54:21');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (227, 'ACC000227', 227, 'Savings', '2022-05-25', 2251.26, 2, 'Excluded', '2025-06-30 19:58');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (227, 227, '480 Cory Landing', NULL, 'Catherinetown', 'CT', '99451', 'USA', 'Home', 2); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (227, 227, '2025-06-05', 1222.87, 3796.47, 2, 'Processed', '2025-07-01 12:00:59');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (228, 'Linda Johnston', 'acoleman@example.org', '001-780-770-4587x84642', '1979-11-17', 1, 'Pending', '2025-07-02 00:33:57');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (228, 'ACC000228', 228, 'Savings', '2024-11-07', 515.86, 1, 'Processed', '2025-07-03 05:52');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (228, 228, '0430 Donald Mall', NULL, 'Robertfurt', 'ND', '44172', 'USA', 'Billing', 1); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (228, 228, '2025-06-21', -743.03, 632.95, 1, 'Excluded', '2025-07-02 21:48:26');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (229, 'Harold Mason', 'lynchjaclyn@example.net', '(547)512-1395', '1973-08-28', 5, 'Failed', '2025-07-02 15:03:00');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (229, 'ACC000229', 229, 'Checking', '2021-01-31', 6053.49, 5, 'Excluded', '2025-07-02 05:47');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (229, 229, '30850 Michael Place Suite 034', NULL, 'Lawrencetown', 'HI', '24289', 'USA', 'Home', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (229, 229, '2025-06-10', -172.7, 2255.6, 5, 'Failed', '2025-06-30 00:32:33');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (230, 'Kimberly Cox', 'jwilliams@example.org', '(982)921-8396x87510', '1991-12-07', 3, 'Processed', '2025-06-30 05:15:24');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (230, 'ACC000230', 230, 'Checking', '2021-12-29', 201.14, 3, 'Failed', '2025-06-30 07:26');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (230, 230, '6545 Hill Alley Suite 632', NULL, 'Gomezland', 'KY', '19536', 'USA', 'Shipping', 3); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (230, 230, '2025-07-01', 1120.99, 4538.07, 3, 'Failed', '2025-07-04 02:44:13');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (231, 'Lauren Clark', 'chadjohnson@example.org', '+1-369-373-8990', '1954-06-28', 5, 'Pending', '2025-06-30 05:25:45');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (231, 'ACC000231', 231, 'Savings', '2020-08-08', 6255.08, 5, 'Processed', '2025-07-03 00:15');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (231, 231, '1733 Anthony Court Apt. 336', NULL, 'East Michael', 'MH', '69073', 'USA', 'Home', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (231, 231, '2025-06-15', 509.27, 3955.64, 5, 'Failed', '2025-07-04 12:14:39');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (232, 'Denise Leonard', 'brownlaura@example.com', '513-496-8907', '1990-06-05', 1, 'Failed', '2025-07-03 10:41:39');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (232, 'ACC000232', 232, 'Loan', '2023-10-13', 8642.41, 1, 'Pending', '2025-06-30 02:37');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (232, 232, '64561 Christine Mall Apt. 291', NULL, 'Rayhaven', 'NV', '55740', 'USA', 'Work', 1); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (232, 232, '2025-06-16', -668.29, 540.94, 1, 'Failed', '2025-06-30 21:41:12');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (233, 'Stephanie Mcclain', 'brandimartinez@example.net', '001-841-598-1067x6968', '1996-06-26', 4, 'Pending', '2025-06-30 21:50:33');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (233, 'ACC000233', 233, 'Loan', '2021-04-24', 765.35, 4, 'Failed', '2025-06-30 13:55');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (233, 233, '35102 Courtney Inlet Apt. 167', NULL, 'West Jeremystad', 'CO', '82913', 'USA', 'Home', 4); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (233, 233, '2025-06-07', -197.61, 252.63, 4, 'Processed', '2025-07-01 09:05:30');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (234, 'David Miller', 'williamturner@example.org', '(771)692-0696x83390', '1979-03-29', 3, 'Processed', '2025-07-02 06:49:40');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (234, 'ACC000234', 234, 'Checking', '2020-10-31', 9977.65, 3, 'Excluded', '2025-06-30 14:04');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (234, 234, '94524 Taylor Lights', NULL, 'Matthewberg', 'OK', '37576', 'USA', 'Shipping', 3); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (234, 234, '2025-07-01', 365.76, 2993.77, 3, 'Failed', '2025-06-30 04:39:29');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (235, 'Debbie Allen', 'qestes@example.org', '(689)666-8373', '1989-04-21', 4, 'Failed', '2025-07-04 08:27:59');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (235, 'ACC000235', 235, 'Savings', '2024-05-26', 7358.85, 4, 'Excluded', '2025-07-03 14:20');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (235, 235, '7035 Black Court Suite 884', NULL, 'Christineland', 'NH', '94058', 'USA', 'Billing', 4); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (235, 235, '2025-06-22', -918.42, 4135.53, 4, 'Excluded', '2025-06-30 05:32:07');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (236, 'Courtney Villegas', 'williamdeleon@example.net', '974-842-9538', '1973-09-06', 3, 'Failed', '2025-07-01 15:00:08');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (236, 'ACC000236', 236, 'Checking', '2020-11-25', 1172.84, 3, 'Pending', '2025-07-03 21:08');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (236, 236, '758 Fleming Forks Suite 146', NULL, 'Mariaview', 'CO', '68286', 'USA', 'Home', 3); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (236, 236, '2025-06-12', -65.91, 1187.33, 3, 'Pending', '2025-06-30 19:27:31');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (237, 'Mary Grimes', 'ashleyanderson@example.org', '984.660.4174', '1971-04-23', 5, 'Processed', '2025-06-30 19:03:18');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (237, 'ACC000237', 237, 'Checking', '2021-11-02', 6763.5, 5, 'Failed', '2025-07-02 20:28');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (237, 237, '85618 Burns Knoll Suite 799', NULL, 'Lake Jennifer', 'IA', '18249', 'USA', 'Shipping', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (237, 237, '2025-06-21', -318.47, 161.97, 5, 'Failed', '2025-06-29 21:12:09');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (238, 'Samuel Mayo', 'bryankeller@example.net', '(737)226-8638', '1969-11-23', 3, 'Pending', '2025-06-30 14:27:46');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (238, 'ACC000238', 238, 'Checking', '2022-02-26', 4060.63, 3, 'Pending', '2025-06-30 08:34');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (238, 238, '66263 Johnson Hills', NULL, 'Justinbury', 'MN', '50979', 'USA', 'Home', 3); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (238, 238, '2025-06-18', 820.93, 4166.42, 3, 'Failed', '2025-07-03 03:59:23');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (239, 'Michael Bailey', 'portermichael@example.com', '001-787-986-6104x9148', '1952-09-14', 1, 'Failed', '2025-06-30 09:25:22');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (239, 'ACC000239', 239, 'Savings', '2020-07-15', 8606.42, 1, 'Excluded', '2025-06-30 10:09');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (239, 239, '177 David Lights', NULL, 'Kathrynburgh', 'MH', '10959', 'USA', 'Shipping', 1); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (239, 239, '2025-06-11', -594.04, 2962.26, 1, 'Failed', '2025-07-03 05:26:16');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (240, 'Lori Anderson', 'joanroberts@example.org', '(982)304-3482x9622', '1954-01-06', 5, 'Pending', '2025-07-03 12:04:17');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (240, 'ACC000240', 240, 'Checking', '2025-03-18', 9467.26, 5, 'Failed', '2025-07-04 11:25');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (240, 240, '247 Glenn Overpass Apt. 023', NULL, 'Steinshire', 'LA', '39000', 'USA', 'Shipping', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (240, 240, '2025-06-27', 1819.11, 3242.37, 5, 'Excluded', '2025-06-30 04:15:51');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (241, 'Jon Park', 'wshepherd@example.org', '689.394.6931x18324', '2003-10-04', 5, 'Processed', '2025-06-30 19:15:17');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (241, 'ACC000241', 241, 'Loan', '2023-10-01', 7361.59, 5, 'Failed', '2025-07-01 10:56');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (241, 241, '2066 Weaver Greens Apt. 037', NULL, 'Smithview', 'MI', '91462', 'USA', 'Billing', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (241, 241, '2025-07-03', -42.1, 3509.5, 5, 'Processed', '2025-06-30 19:20:48');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (242, 'David Michael', 'carolynmeyers@example.com', '001-732-330-6759', '1999-05-27', 3, 'Processed', '2025-06-30 06:09:32');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (242, 'ACC000242', 242, 'Loan', '2024-06-10', 2010.47, 3, 'Pending', '2025-07-03 03:27');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (242, 242, '08982 Carter Haven', NULL, 'Port Tracy', 'NH', '76246', 'USA', 'Billing', 3); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (242, 242, '2025-06-15', -355.52, 4793.3, 3, 'Excluded', '2025-07-02 17:56:27');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (243, 'Kathryn Lopez MD', 'angela42@example.org', '781.288.1186', '1966-04-03', 5, 'Failed', '2025-07-01 22:42:36');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (243, 'ACC000243', 243, 'Savings', '2021-07-05', 5095.52, 5, 'Processed', '2025-07-02 03:10');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (243, 243, '353 Kenneth Courts Suite 919', NULL, 'South Amanda', 'VT', '19112', 'USA', 'Work', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (243, 243, '2025-06-17', 1723.48, 3584.84, 5, 'Pending', '2025-06-30 00:17:19');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (244, 'James Hodge', 'amy56@example.com', '712-369-4625x4711', '1952-06-14', 3, 'Failed', '2025-07-01 07:07:14');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (244, 'ACC000244', 244, 'Checking', '2023-11-13', 6422.29, 3, 'Processed', '2025-07-04 13:32');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (244, 244, '7184 Garcia Ports', NULL, 'Tracymouth', 'NV', '06070', 'USA', 'Work', 3); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (244, 244, '2025-06-17', -478.33, 2273.7, 3, 'Processed', '2025-06-29 21:36:46');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (245, 'John Klein DDS', 'qsnyder@example.com', '(526)898-3352x702', '1954-12-15', 1, 'Pending', '2025-07-02 13:52:46');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (245, 'ACC000245', 245, 'Savings', '2022-10-05', 7928.54, 1, 'Processed', '2025-07-04 12:19');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (245, 245, '616 Davis Light', NULL, 'Wolfville', 'CT', '05033', 'USA', 'Billing', 1); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (245, 245, '2025-07-02', -712.66, 2716.35, 1, 'Processed', '2025-07-03 03:52:51');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (246, 'Jordan Wade', 'ashleybird@example.net', '932-610-4959x34404', '1967-07-23', 3, 'Pending', '2025-06-30 07:27:45');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (246, 'ACC000246', 246, 'Loan', '2023-12-06', 1890.08, 3, 'Pending', '2025-07-03 18:54');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (246, 246, '04433 Anderson Bypass Apt. 582', NULL, 'Lake Kathy', 'KY', '03469', 'USA', 'Billing', 3); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (246, 246, '2025-06-29', 971.88, 333.55, 3, 'Failed', '2025-07-02 00:28:49');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (247, 'Kimberly Anderson', 'oali@example.org', '680.809.4747x5306', '1977-12-26', 3, 'Processed', '2025-06-30 10:32:10');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (247, 'ACC000247', 247, 'Savings', '2023-06-17', 7134.74, 3, 'Processed', '2025-06-30 07:52');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (247, 247, '5523 Garcia Ports Apt. 769', NULL, 'Port Laurieberg', 'CO', '18499', 'USA', 'Billing', 3); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (247, 247, '2025-06-23', -253.95, 4406.92, 3, 'Pending', '2025-07-02 10:55:20');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (248, 'Lauren Reid DDS', 'nathan21@example.com', '(214)266-5067x9673', '1959-12-23', 4, 'Processed', '2025-07-03 08:46:30');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (248, 'ACC000248', 248, 'Loan', '2022-11-04', 5436.28, 4, 'Pending', '2025-06-30 10:33');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (248, 248, '34200 Jose Mills Apt. 013', NULL, 'Villarrealburgh', 'IA', '72275', 'USA', 'Work', 4); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (248, 248, '2025-06-18', 1153.91, 606.97, 4, 'Excluded', '2025-06-30 05:49:15');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (249, 'Timothy Carr', 'gmelton@example.net', '(557)251-3210x414', '1952-08-29', 3, 'Pending', '2025-07-01 02:55:31');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (249, 'ACC000249', 249, 'Loan', '2021-12-16', 2089.34, 3, 'Processed', '2025-06-30 04:29');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (249, 249, '04157 Silva Prairie', NULL, 'West Anthony', 'NM', '65771', 'USA', 'Work', 3); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (249, 249, '2025-06-14', 285.12, 1588.2, 3, 'Pending', '2025-07-04 04:30:36');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (250, 'Adrienne Osborne', 'kimberlysparks@example.org', '(906)990-8760x60162', '1956-01-22', 2, 'Processed', '2025-07-01 02:09:24');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (250, 'ACC000250', 250, 'Savings', '2024-06-19', 2172.0, 2, 'Processed', '2025-07-03 11:27');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (250, 250, '6413 Michael Viaduct', NULL, 'Martinezshire', 'CA', '51536', 'USA', 'Billing', 2); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (250, 250, '2025-06-15', 387.22, 2263.26, 2, 'Failed', '2025-07-04 01:27:23');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (251, 'Cassandra Cain', 'jose61@example.org', '(372)784-1955', '1961-11-02', 3, 'Excluded', '2025-07-02 01:45:16');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (251, 'ACC000251', 251, 'Checking', '2023-11-23', 7625.72, 3, 'Failed', '2025-07-02 18:20');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (251, 251, '59662 Kyle Crescent Apt. 364', NULL, 'Jacksonchester', 'PR', '72411', 'USA', 'Home', 3); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (251, 251, '2025-06-28', 1526.11, 1718.47, 3, 'Excluded', '2025-07-02 00:23:59');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (252, 'Kathryn Riley', 'stephen38@example.org', '+1-903-555-6432x608', '1973-12-26', 5, 'Processed', '2025-07-01 18:41:16');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (252, 'ACC000252', 252, 'Savings', '2021-08-14', 1045.94, 5, 'Failed', '2025-07-02 19:05');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (252, 252, '8395 Jessica Ford Apt. 233', NULL, 'North Christopher', 'AL', '74170', 'USA', 'Home', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (252, 252, '2025-07-01', 72.79, 598.42, 5, 'Pending', '2025-07-01 20:56:55');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (253, 'Cameron Scott', 'mgross@example.com', '(650)462-2251x81905', '2004-11-23', 1, 'Pending', '2025-07-01 06:02:47');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (253, 'ACC000253', 253, 'Checking', '2023-04-06', 3752.8, 1, 'Failed', '2025-07-03 09:05');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (253, 253, '3419 Alexis Mission Suite 987', NULL, 'East Larry', 'CT', '05464', 'USA', 'Shipping', 1); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (253, 253, '2025-06-04', 1617.2, 4191.58, 1, 'Pending', '2025-07-04 06:15:42');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (254, 'Hannah Carter', 'amywright@example.com', '289.513.5261x88688', '1986-12-30', 5, 'Processed', '2025-07-03 17:18:53');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (254, 'ACC000254', 254, 'Checking', '2024-02-26', 8347.47, 5, 'Pending', '2025-07-02 05:17');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (254, 254, '493 Williams Forks Apt. 023', NULL, 'West Danielmouth', 'MI', '32193', 'USA', 'Shipping', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (254, 254, '2025-07-01', 375.13, 4953.95, 5, 'Excluded', '2025-06-30 20:12:35');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (255, 'Joshua Ewing', 'johnsonlinda@example.com', '+1-717-348-6924', '1958-09-25', 4, 'Excluded', '2025-06-29 13:52:03');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (255, 'ACC000255', 255, 'Savings', '2022-11-10', 4587.39, 4, 'Pending', '2025-07-02 12:53');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (255, 255, '693 Robert Vista', NULL, 'Wisemouth', 'MD', '48695', 'USA', 'Home', 4); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (255, 255, '2025-06-16', 471.86, 2605.62, 4, 'Excluded', '2025-07-01 10:42:53');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (256, 'James Owens', 'edwardsmegan@example.com', '509-354-5025', '1988-08-29', 2, 'Failed', '2025-07-03 04:26:48');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (256, 'ACC000256', 256, 'Checking', '2021-08-27', 6167.12, 2, 'Excluded', '2025-07-01 20:30');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (256, 256, '658 Samantha Shoals Suite 957', NULL, 'New Scott', 'IL', '80098', 'USA', 'Home', 2); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (256, 256, '2025-06-17', -524.49, 2434.46, 2, 'Pending', '2025-06-30 08:09:57');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (257, 'Adam Montes', 'rhill@example.net', '(990)848-3374x302', '1972-12-05', 3, 'Failed', '2025-07-03 23:29:54');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (257, 'ACC000257', 257, 'Loan', '2021-03-20', 5320.93, 3, 'Failed', '2025-07-01 07:44');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (257, 257, '67234 Jessica Dam', NULL, 'Hudsonborough', 'AS', '29320', 'USA', 'Billing', 3); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (257, 257, '2025-06-13', 806.65, 3604.44, 3, 'Failed', '2025-06-30 13:57:08');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (258, 'Michael Melendez', 'shannon81@example.net', '+1-661-470-7299x6131', '1981-04-01', 5, 'Failed', '2025-06-29 13:51:06');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (258, 'ACC000258', 258, 'Loan', '2025-05-12', 9548.82, 5, 'Failed', '2025-06-29 21:10');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (258, 258, '77869 Rogers Junction', NULL, 'Nicholasberg', 'FL', '42248', 'USA', 'Shipping', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (258, 258, '2025-06-06', 274.42, 1534.85, 5, 'Processed', '2025-07-04 10:58:00');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (259, 'Joseph Bowers', 'francisco75@example.net', '887.332.8569x52563', '1959-06-23', 1, 'Pending', '2025-07-04 07:25:07');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (259, 'ACC000259', 259, 'Loan', '2025-04-06', 7251.26, 1, 'Excluded', '2025-06-30 23:21');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (259, 259, '75051 Alexander Court', NULL, 'Gutierrezland', 'MO', '45974', 'USA', 'Billing', 1); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (259, 259, '2025-06-04', 1346.56, 4515.24, 1, 'Failed', '2025-07-01 02:36:07');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (260, 'Anthony Walker', 'millersean@example.org', '(330)770-7835', '1974-10-06', 1, 'Processed', '2025-06-30 10:01:03');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (260, 'ACC000260', 260, 'Loan', '2025-05-20', 747.49, 1, 'Pending', '2025-07-01 17:31');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (260, 260, '45826 Hull Cliffs', NULL, 'East Melissaville', 'TX', '91112', 'USA', 'Shipping', 1); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (260, 260, '2025-06-16', -652.27, 2528.49, 1, 'Processed', '2025-06-30 17:31:45');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (261, 'Adriana Alvarado', 'misty15@example.com', '001-731-912-1469x3059', '1966-12-03', 1, 'Excluded', '2025-07-04 04:51:57');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (261, 'ACC000261', 261, 'Checking', '2024-01-14', 4987.39, 1, 'Failed', '2025-06-29 18:23');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (261, 261, '8745 Jones Hill Apt. 517', NULL, 'Lake Vicki', 'IL', '28103', 'USA', 'Billing', 1); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (261, 261, '2025-06-12', 959.23, 4450.57, 1, 'Failed', '2025-07-02 16:27:12');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (262, 'Joseph Herrera', 'denise10@example.net', '756-919-9323x9450', '2006-03-18', 3, 'Processed', '2025-07-02 08:06:03');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (262, 'ACC000262', 262, 'Loan', '2024-02-01', 7190.18, 3, 'Pending', '2025-07-02 15:09');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (262, 262, '61340 Tracy Road Suite 946', NULL, 'Lake Jessicamouth', 'KS', '60870', 'USA', 'Work', 3); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (262, 262, '2025-06-27', 365.05, 3597.44, 3, 'Failed', '2025-07-02 00:18:01');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (263, 'Roy Moore', 'jesse47@example.net', '(362)220-9455x164', '1998-02-14', 3, 'Processed', '2025-07-03 23:41:04');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (263, 'ACC000263', 263, 'Savings', '2024-01-30', 224.67, 3, 'Processed', '2025-07-02 06:06');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (263, 263, '4965 Blake Alley', NULL, 'North Alec', 'AK', '17333', 'USA', 'Billing', 3); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (263, 263, '2025-06-29', 975.61, 197.15, 3, 'Excluded', '2025-07-04 05:46:27');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (264, 'Eric Woods', 'imartinez@example.net', '(808)532-6918', '1998-12-14', 3, 'Excluded', '2025-06-30 00:33:24');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (264, 'ACC000264', 264, 'Checking', '2024-12-26', 3641.64, 3, 'Excluded', '2025-07-02 02:47');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (264, 264, '8107 Jones Canyon Apt. 853', NULL, 'South Kevin', 'CA', '52716', 'USA', 'Shipping', 3); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (264, 264, '2025-06-06', 1476.44, 3068.23, 3, 'Failed', '2025-07-02 06:50:23');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (265, 'Matthew Munoz', 'stephanie94@example.com', '+1-659-937-6893x66748', '1986-07-26', 2, 'Failed', '2025-06-30 13:50:19');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (265, 'ACC000265', 265, 'Checking', '2022-10-24', 5851.25, 2, 'Failed', '2025-06-30 17:57');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (265, 265, '4673 Collins Brooks Apt. 640', NULL, 'North Christopherfurt', 'AR', '54377', 'USA', 'Home', 2); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (265, 265, '2025-06-28', 934.79, 2521.99, 2, 'Processed', '2025-07-03 04:50:43');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (266, 'Erin Brooks', 'smithmeghan@example.net', '+1-616-651-1686', '1993-11-25', 4, 'Pending', '2025-07-01 23:41:15');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (266, 'ACC000266', 266, 'Savings', '2023-09-18', 6293.89, 4, 'Excluded', '2025-06-29 23:59');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (266, 266, '47264 Morrison Hill', NULL, 'Valerieview', 'MN', '18757', 'USA', 'Home', 4); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (266, 266, '2025-06-14', -263.34, 2575.44, 4, 'Processed', '2025-07-01 03:34:17');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (267, 'Debra Martinez', 'tammybaker@example.com', '578.611.8692x469', '1980-12-22', 2, 'Pending', '2025-07-01 19:20:20');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (267, 'ACC000267', 267, 'Savings', '2024-06-10', 7759.6, 2, 'Pending', '2025-06-30 20:57');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (267, 267, '633 Benson Junctions', NULL, 'Jasonton', 'OH', '64189', 'USA', 'Billing', 2); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (267, 267, '2025-06-10', 415.34, 1520.98, 2, 'Failed', '2025-06-30 23:53:48');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (268, 'Kevin Robinson', 'catherinemorgan@example.com', '663-308-5436x884', '2001-07-05', 3, 'Pending', '2025-07-02 17:36:40');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (268, 'ACC000268', 268, 'Checking', '2023-04-29', 3165.29, 3, 'Excluded', '2025-07-03 23:56');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (268, 268, '91004 Vanessa Mission Apt. 953', NULL, 'Smithmouth', 'MA', '98345', 'USA', 'Shipping', 3); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (268, 268, '2025-06-08', 1795.05, 3050.52, 3, 'Pending', '2025-07-03 02:26:56');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (269, 'Joshua Collins', 'khenry@example.com', '(455)961-9673x12796', '1990-07-02', 1, 'Pending', '2025-07-02 13:05:37');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (269, 'ACC000269', 269, 'Checking', '2022-06-09', 8904.97, 1, 'Processed', '2025-06-30 03:47');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (269, 269, '0232 Timothy Dale', NULL, 'Holmesbury', 'WV', '27432', 'USA', 'Shipping', 1); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (269, 269, '2025-06-11', 387.98, 784.1, 1, 'Pending', '2025-07-03 20:22:57');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (270, 'Shawn Davis', 'jared68@example.org', '596.412.0951x8772', '1953-08-30', 3, 'Pending', '2025-07-04 09:21:19');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (270, 'ACC000270', 270, 'Savings', '2021-06-06', 5836.47, 3, 'Pending', '2025-07-02 11:01');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (270, 270, '07840 John Roads', NULL, 'East Tammychester', 'VA', '97466', 'USA', 'Shipping', 3); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (270, 270, '2025-06-21', 1052.33, 4103.48, 3, 'Excluded', '2025-07-01 13:37:32');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (271, 'Chad Cooper', 'johnshaw@example.net', '781-413-1605x0133', '1984-09-05', 3, 'Processed', '2025-07-04 04:44:48');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (271, 'ACC000271', 271, 'Loan', '2022-08-27', 2717.92, 3, 'Failed', '2025-07-02 09:26');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (271, 271, '6203 Richard Passage Apt. 097', NULL, 'Joshuahaven', 'DC', '05356', 'USA', 'Shipping', 3); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (271, 271, '2025-06-17', 254.52, 1126.85, 3, 'Excluded', '2025-07-03 05:22:40');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (272, 'Kevin Vega', 'coreycarroll@example.com', '001-276-974-1137x2540', '1982-10-07', 3, 'Processed', '2025-07-02 06:09:09');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (272, 'ACC000272', 272, 'Savings', '2020-11-19', 7032.64, 3, 'Pending', '2025-07-02 17:49');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (272, 272, '65605 Alicia Camp Apt. 891', NULL, 'Port Henry', 'OK', '53191', 'USA', 'Shipping', 3); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (272, 272, '2025-06-27', 1333.88, 4284.37, 3, 'Failed', '2025-06-30 01:42:11');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (273, 'Gregory Baker', 'michaelhouse@example.com', '+1-713-635-6535x634', '1997-02-20', 5, 'Excluded', '2025-06-30 03:12:31');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (273, 'ACC000273', 273, 'Savings', '2024-11-20', 6255.27, 5, 'Excluded', '2025-07-03 06:43');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (273, 273, '30540 Tiffany Pike', NULL, 'Yanghaven', 'WY', '75498', 'USA', 'Billing', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (273, 273, '2025-06-25', 1209.56, 689.39, 5, 'Processed', '2025-07-03 20:44:53');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (274, 'Yvonne Brewer', 'heather33@example.net', '678.840.0261x324', '1986-06-06', 5, 'Processed', '2025-07-01 05:06:10');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (274, 'ACC000274', 274, 'Savings', '2022-02-15', 5608.41, 5, 'Failed', '2025-07-01 15:37');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (274, 274, '31722 Kennedy Station Apt. 039', NULL, 'Ayersland', 'MO', '54292', 'USA', 'Billing', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (274, 274, '2025-06-10', 558.58, 2624.68, 5, 'Pending', '2025-07-02 12:22:16');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (275, 'Aaron Chapman', 'christopher85@example.net', '237-256-4738x94035', '1980-05-22', 2, 'Excluded', '2025-07-04 12:26:31');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (275, 'ACC000275', 275, 'Loan', '2022-09-05', 8428.91, 2, 'Pending', '2025-06-29 16:59');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (275, 275, '27708 Amanda Valley Suite 489', NULL, 'South Richardfort', 'AL', '93131', 'USA', 'Billing', 2); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (275, 275, '2025-06-06', 1540.41, 2888.14, 2, 'Pending', '2025-06-30 08:28:38');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (276, 'Tina Cooper', 'johndudley@example.com', '439-812-3880x6614', '1990-04-29', 2, 'Pending', '2025-07-03 16:21:41');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (276, 'ACC000276', 276, 'Savings', '2021-06-05', 4747.72, 2, 'Processed', '2025-07-01 18:01');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (276, 276, '249 White Port', NULL, 'New Kellyton', 'WA', '21322', 'USA', 'Home', 2); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (276, 276, '2025-06-26', 124.39, 4376.23, 2, 'Excluded', '2025-07-01 18:49:33');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (277, 'Samuel Savage', 'wrightmallory@example.com', '001-323-505-4397x65188', '1997-10-24', 3, 'Processed', '2025-07-03 19:30:22');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (277, 'ACC000277', 277, 'Loan', '2024-07-22', 628.53, 3, 'Excluded', '2025-07-03 15:32');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (277, 277, '8857 Robinson Keys Suite 617', NULL, 'Vangside', 'MT', '80456', 'USA', 'Work', 3); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (277, 277, '2025-06-14', 145.79, 796.65, 3, 'Failed', '2025-07-03 09:09:27');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (278, 'Mario Cole', 'rebecca56@example.com', '2012903005', '1949-12-25', 2, 'Failed', '2025-07-04 11:32:52');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (278, 'ACC000278', 278, 'Savings', '2021-04-11', 9481.44, 2, 'Pending', '2025-07-01 17:57');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (278, 278, '86811 Adkins Groves', NULL, 'Sandersbury', 'DE', '74627', 'USA', 'Work', 2); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (278, 278, '2025-06-23', 1923.85, 4095.7, 2, 'Failed', '2025-06-30 00:33:38');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (279, 'Ricky Whitaker', 'brian50@example.com', '2688663749', '1988-05-19', 3, 'Processed', '2025-07-03 07:29:36');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (279, 'ACC000279', 279, 'Savings', '2023-02-05', 9351.65, 3, 'Processed', '2025-07-04 09:14');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (279, 279, '3911 Moore Divide Suite 092', NULL, 'Reyeston', 'SC', '99093', 'USA', 'Shipping', 3); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (279, 279, '2025-06-23', -140.41, 2279.08, 3, 'Failed', '2025-07-03 19:57:32');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (280, 'Matthew Moody', 'zwells@example.org', '713-728-4463x929', '1962-03-01', 3, 'Processed', '2025-07-04 04:12:42');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (280, 'ACC000280', 280, 'Savings', '2023-11-19', 5655.11, 3, 'Processed', '2025-07-02 20:47');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (280, 280, '3081 Kim Cove Suite 088', NULL, 'West Sharonburgh', 'MN', '44319', 'USA', 'Home', 3); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (280, 280, '2025-06-24', -495.69, 756.91, 3, 'Pending', '2025-06-30 09:31:43');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (281, 'Karen Torres', 'kendra62@example.net', '001-307-513-9448x0050', '1964-09-29', 1, 'Failed', '2025-07-01 19:48:37');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (281, 'ACC000281', 281, 'Savings', '2023-05-03', 7941.25, 1, 'Excluded', '2025-06-30 22:44');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (281, 281, '956 Emily Inlet Apt. 214', NULL, 'Port Raymond', 'NY', '72535', 'USA', 'Home', 1); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (281, 281, '2025-06-28', 66.42, 2641.76, 1, 'Failed', '2025-07-03 00:51:37');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (282, 'Kyle Jimenez', 'zfrench@example.net', '001-985-853-2571', '1949-10-01', 4, 'Excluded', '2025-07-04 07:33:20');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (282, 'ACC000282', 282, 'Loan', '2021-03-13', 1754.24, 4, 'Failed', '2025-07-02 01:15');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (282, 282, '811 Anthony Unions', NULL, 'Lake Anna', 'FM', '34715', 'USA', 'Home', 4); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (282, 282, '2025-06-08', 1813.14, 2917.28, 4, 'Pending', '2025-06-30 20:19:16');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (283, 'Kyle Stafford', 'mccannbrenda@example.net', '558-394-7814', '1995-10-01', 2, 'Processed', '2025-07-01 04:22:48');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (283, 'ACC000283', 283, 'Savings', '2020-10-31', 267.95, 2, 'Processed', '2025-06-30 23:00');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (283, 283, '412 Avila Corner', NULL, 'Jenningshaven', 'ND', '99174', 'USA', 'Shipping', 2); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (283, 283, '2025-07-02', 965.99, 3365.58, 2, 'Excluded', '2025-06-30 23:55:54');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (284, 'Michael Cunningham', 'jonathan20@example.org', '929.743.4572', '1964-03-15', 5, 'Pending', '2025-07-04 05:57:32');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (284, 'ACC000284', 284, 'Loan', '2021-05-10', 3107.96, 5, 'Processed', '2025-06-29 17:07');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (284, 284, '426 David Drives', NULL, 'New Elizabeth', 'CT', '29829', 'USA', 'Work', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (284, 284, '2025-06-13', -52.04, 688.11, 5, 'Excluded', '2025-07-02 09:24:05');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (285, 'Samantha Steele', 'grahamsandra@example.org', '237-393-0607', '1967-01-03', 2, 'Pending', '2025-07-03 03:36:31');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (285, 'ACC000285', 285, 'Loan', '2024-03-05', 630.57, 2, 'Processed', '2025-07-03 16:01');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (285, 285, '020 Richard Fort', NULL, 'North Stacyshire', 'MA', '51294', 'USA', 'Shipping', 2); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (285, 285, '2025-06-27', -72.79, 1255.57, 2, 'Processed', '2025-06-30 05:25:57');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (286, 'Lydia Wheeler', 'jennifer96@example.org', '(394)480-7679', '1956-03-11', 5, 'Failed', '2025-07-04 07:48:16');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (286, 'ACC000286', 286, 'Loan', '2020-07-30', 9933.91, 5, 'Pending', '2025-07-02 22:39');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (286, 286, '417 Fischer Way Apt. 671', NULL, 'Richmondberg', 'AL', '64417', 'USA', 'Home', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (286, 286, '2025-06-17', 1440.32, 573.51, 5, 'Processed', '2025-07-01 02:07:22');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (287, 'Jacqueline Byrd', 'ramirezsarah@example.org', '612.259.4842', '1991-12-02', 2, 'Failed', '2025-07-03 19:51:08');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (287, 'ACC000287', 287, 'Savings', '2022-04-01', 486.39, 2, 'Pending', '2025-07-04 12:53');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (287, 287, '4560 Craig Inlet', NULL, 'Gonzalezton', 'ND', '09837', 'USA', 'Billing', 2); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (287, 287, '2025-06-05', 834.89, 4738.52, 2, 'Failed', '2025-06-30 00:41:07');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (288, 'Steven Griffith', 'timothy51@example.net', '349-401-1981', '2006-10-10', 2, 'Processed', '2025-06-30 08:31:44');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (288, 'ACC000288', 288, 'Savings', '2022-12-30', 6180.78, 2, 'Excluded', '2025-07-02 12:04');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (288, 288, '944 Anderson Glens Suite 309', NULL, 'New Kimberlyport', 'AZ', '10989', 'USA', 'Work', 2); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (288, 288, '2025-07-01', 1977.85, 2442.57, 2, 'Excluded', '2025-06-30 14:06:31');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (289, 'Sonya Garcia', 'gilbertjose@example.com', '001-787-454-7120x9559', '1960-10-13', 5, 'Excluded', '2025-07-03 06:31:34');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (289, 'ACC000289', 289, 'Loan', '2022-03-26', 4484.97, 5, 'Processed', '2025-07-02 20:48');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (289, 289, '88939 Gates Plain', NULL, 'South Margaretmouth', 'KS', '03536', 'USA', 'Work', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (289, 289, '2025-06-04', 592.16, 2204.78, 5, 'Pending', '2025-07-01 02:08:27');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (290, 'Jason Smith', 'daniel51@example.com', '(547)560-0452x380', '1955-01-28', 4, 'Failed', '2025-07-02 21:11:51');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (290, 'ACC000290', 290, 'Checking', '2025-01-05', 7533.01, 4, 'Failed', '2025-07-03 13:38');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (290, 290, '5591 Smith Ports', NULL, 'Tracyhaven', 'MN', '10138', 'USA', 'Billing', 4); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (290, 290, '2025-06-28', 853.72, 2939.18, 4, 'Pending', '2025-07-01 04:55:20');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (291, 'Shirley Davis', 'woodsnicholas@example.org', '+1-526-770-9692x4679', '1999-05-02', 3, 'Processed', '2025-07-04 02:16:57');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (291, 'ACC000291', 291, 'Checking', '2023-07-03', 2591.85, 3, 'Pending', '2025-07-04 00:06');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (291, 291, '3126 Ruiz Lake Apt. 779', NULL, 'Lake Glennburgh', 'IA', '44044', 'USA', 'Billing', 3); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (291, 291, '2025-06-12', 1029.03, 3967.28, 3, 'Processed', '2025-07-02 10:23:22');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (292, 'Kevin Wood', 'marthadavis@example.org', '+1-389-204-8055x4728', '1970-06-27', 1, 'Pending', '2025-07-02 01:35:10');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (292, 'ACC000292', 292, 'Savings', '2025-04-29', 9452.42, 1, 'Pending', '2025-07-03 13:55');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (292, 292, '0900 Patrick Summit Suite 366', NULL, 'Ginahaven', 'OK', '99795', 'USA', 'Shipping', 1); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (292, 292, '2025-06-07', -753.19, 4812.99, 1, 'Failed', '2025-06-30 13:30:55');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (293, 'Matthew Gonzalez', 'kimberlywiley@example.com', '232.630.3184x343', '1984-04-21', 4, 'Failed', '2025-07-03 11:54:30');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (293, 'ACC000293', 293, 'Checking', '2023-04-07', 5976.9, 4, 'Pending', '2025-07-02 15:07');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (293, 293, '45430 Maria Extensions Apt. 448', NULL, 'Wilsonview', 'MO', '38894', 'USA', 'Work', 4); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (293, 293, '2025-06-08', 1734.84, 3743.13, 4, 'Failed', '2025-07-04 06:51:55');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (294, 'Mikayla Reed DDS', 'harold12@example.org', '(318)380-7422', '1969-07-14', 1, 'Pending', '2025-06-30 21:37:43');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (294, 'ACC000294', 294, 'Loan', '2022-08-15', 7640.48, 1, 'Excluded', '2025-07-02 11:12');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (294, 294, '951 Watson Mountain', NULL, 'Thomasport', 'NC', '43981', 'USA', 'Home', 1); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (294, 294, '2025-06-20', 1489.72, 1466.29, 1, 'Processed', '2025-06-29 16:22:56');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (295, 'Erik Hanson DDS', 'brittanymullins@example.com', '(484)757-0743', '1982-07-26', 5, 'Failed', '2025-07-04 11:45:51');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (295, 'ACC000295', 295, 'Checking', '2024-06-27', 5236.94, 5, 'Excluded', '2025-07-02 05:58');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (295, 295, '059 Luis Plaza Apt. 204', NULL, 'Burkemouth', 'FL', '68434', 'USA', 'Shipping', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (295, 295, '2025-06-14', 821.36, 2022.8, 5, 'Excluded', '2025-07-03 23:57:15');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (296, 'Debra Lee', 'ojuarez@example.net', '+1-972-377-0353x7688', '1971-06-18', 5, 'Failed', '2025-06-30 04:12:10');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (296, 'ACC000296', 296, 'Loan', '2023-06-16', 5838.25, 5, 'Excluded', '2025-07-03 08:27');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (296, 296, '58355 Jo Mountains Suite 697', NULL, 'New Jason', 'PW', '66761', 'USA', 'Work', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (296, 296, '2025-06-11', -103.01, 1466.23, 5, 'Failed', '2025-07-02 14:32:28');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (297, 'Alexander Nelson', 'katherine61@example.org', '001-223-520-4231', '1980-04-17', 4, 'Pending', '2025-07-03 19:32:08');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (297, 'ACC000297', 297, 'Savings', '2020-11-19', 8693.73, 4, 'Excluded', '2025-07-02 05:02');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (297, 297, '18263 Bryan Wells', NULL, 'Hensleyview', 'MO', '67305', 'USA', 'Work', 4); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (297, 297, '2025-07-02', 1132.78, 1310.91, 4, 'Excluded', '2025-07-01 21:45:18');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (298, 'Michael Blankenship', 'emata@example.org', '770-665-5692x767', '1973-11-05', 3, 'Pending', '2025-07-01 20:09:52');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (298, 'ACC000298', 298, 'Loan', '2023-09-16', 4202.69, 3, 'Excluded', '2025-06-29 20:02');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (298, 298, '28231 Campbell Camp', NULL, 'Ramoston', 'MT', '22522', 'USA', 'Billing', 3); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (298, 298, '2025-06-11', 1822.96, 4310.66, 3, 'Failed', '2025-07-03 06:08:42');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (299, 'Craig Porter', 'danielclayton@example.net', '802-537-5091x821', '1965-03-14', 4, 'Failed', '2025-07-03 11:55:31');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (299, 'ACC000299', 299, 'Loan', '2022-07-08', 5226.23, 4, 'Pending', '2025-07-01 14:17');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (299, 299, '2016 Maria Plain Suite 741', NULL, 'South Lindsay', 'MS', '61691', 'USA', 'Work', 4); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (299, 299, '2025-07-02', 817.34, 764.82, 4, 'Failed', '2025-06-30 13:07:08');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (300, 'Danielle Hamilton', 'hodgesrobin@example.org', '(277)560-2179', '1957-02-08', 2, 'Processed', '2025-07-04 12:29:49');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (300, 'ACC000300', 300, 'Loan', '2022-08-02', 3947.17, 2, 'Pending', '2025-07-01 12:21');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (300, 300, '284 Jeffrey Stravenue Apt. 116', NULL, 'Caldwellburgh', 'HI', '18747', 'USA', 'Work', 2); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (300, 300, '2025-06-21', -462.97, 2377.98, 2, 'Processed', '2025-07-01 23:22:19');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (301, 'Tonya Young', 'lisa98@example.com', '317-818-8723', '1976-01-14', 5, 'Excluded', '2025-06-30 18:01:43');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (301, 'ACC000301', 301, 'Loan', '2020-09-11', 9715.8, 5, 'Processed', '2025-07-03 22:52');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (301, 301, '23414 Macias Knoll Suite 781', NULL, 'Robertberg', 'GU', '67203', 'USA', 'Billing', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (301, 301, '2025-07-02', -380.86, 421.36, 5, 'Pending', '2025-06-30 00:33:54');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (302, 'Michael Harmon', 'coreyjohnson@example.org', '001-929-816-0032x49435', '1997-03-14', 2, 'Excluded', '2025-07-04 04:23:50');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (302, 'ACC000302', 302, 'Loan', '2023-03-07', 9672.04, 2, 'Processed', '2025-07-03 07:43');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (302, 302, '390 Johnson Summit Apt. 084', NULL, 'East Johnhaven', 'OH', '93214', 'USA', 'Billing', 2); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (302, 302, '2025-06-09', -443.59, 136.06, 2, 'Excluded', '2025-07-02 13:33:44');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (303, 'Kim Hopkins', 'tracy72@example.net', '924-855-1391', '1950-04-01', 1, 'Failed', '2025-07-04 09:47:58');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (303, 'ACC000303', 303, 'Checking', '2021-07-07', 8810.69, 1, 'Processed', '2025-07-02 07:23');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (303, 303, '0658 Kristen Drive', NULL, 'Barnesburgh', 'PW', '15304', 'USA', 'Work', 1); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (303, 303, '2025-06-12', 1663.07, 4320.21, 1, 'Processed', '2025-07-04 13:00:39');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (304, 'Caleb Jackson', 'wilsoncory@example.org', '001-545-570-8452x66732', '1956-01-18', 2, 'Excluded', '2025-07-01 21:08:58');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (304, 'ACC000304', 304, 'Savings', '2024-12-10', 599.55, 2, 'Failed', '2025-07-02 17:17');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (304, 304, '67153 Mark Mills', NULL, 'New Robintown', 'TX', '97525', 'USA', 'Billing', 2); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (304, 304, '2025-06-20', 1260.12, 634.64, 2, 'Pending', '2025-06-29 23:19:06');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (305, 'Kevin Lutz', 'keithmurphy@example.net', '3306189637', '1986-10-02', 5, 'Pending', '2025-07-01 02:23:20');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (305, 'ACC000305', 305, 'Checking', '2024-03-31', 8652.97, 5, 'Excluded', '2025-06-30 16:58');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (305, 305, '4802 Nancy Hill', NULL, 'Davidsonchester', 'UT', '44623', 'USA', 'Home', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (305, 305, '2025-06-23', 759.87, 2108.81, 5, 'Pending', '2025-07-04 04:43:52');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (306, 'James Soto', 'wmarquez@example.org', '(320)496-1758', '1985-07-31', 3, 'Excluded', '2025-07-04 06:34:26');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (306, 'ACC000306', 306, 'Savings', '2020-08-20', 6640.8, 3, 'Failed', '2025-07-01 04:06');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (306, 306, '213 Alexander Heights', NULL, 'North Tina', 'LA', '78694', 'USA', 'Shipping', 3); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (306, 306, '2025-06-08', -651.79, 2021.07, 3, 'Failed', '2025-07-03 16:38:17');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (307, 'Jonathon Rodgers', 'ruizjoshua@example.com', '235-745-3188x2387', '1969-11-27', 4, 'Pending', '2025-07-03 19:11:26');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (307, 'ACC000307', 307, 'Savings', '2023-10-30', 1069.12, 4, 'Failed', '2025-07-02 10:32');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (307, 307, '854 Hawkins Prairie', NULL, 'Jenniferborough', 'RI', '70876', 'USA', 'Shipping', 4); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (307, 307, '2025-06-15', 1663.45, 902.0, 4, 'Excluded', '2025-07-03 12:23:06');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (308, 'Kevin Jones', 'hensleyryan@example.net', '636.884.5953x6010', '1952-08-14', 5, 'Excluded', '2025-06-30 16:39:50');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (308, 'ACC000308', 308, 'Checking', '2022-11-11', 8201.54, 5, 'Failed', '2025-07-03 20:39');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (308, 308, '852 Rebekah Villages Apt. 928', NULL, 'Andersonfort', 'AR', '71927', 'USA', 'Billing', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (308, 308, '2025-06-15', -429.27, 762.29, 5, 'Pending', '2025-07-04 10:39:43');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (309, 'Karen Wallace', 'michellekramer@example.org', '3634588310', '1978-06-17', 4, 'Failed', '2025-07-02 02:59:48');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (309, 'ACC000309', 309, 'Savings', '2022-06-16', 7125.88, 4, 'Failed', '2025-07-01 11:59');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (309, 309, '9558 David Landing Suite 386', NULL, 'East Michelleburgh', 'SC', '61490', 'USA', 'Billing', 4); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (309, 309, '2025-06-06', 1295.43, 4133.77, 4, 'Pending', '2025-06-30 23:11:16');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (310, 'Jeremiah Green', 'kellymann@example.net', '455-368-3276x8232', '2005-04-02', 1, 'Pending', '2025-06-30 21:04:04');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (310, 'ACC000310', 310, 'Savings', '2023-12-12', 7110.26, 1, 'Failed', '2025-07-02 15:11');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (310, 310, '918 Tiffany Gardens Suite 330', NULL, 'Terryshire', 'HI', '77512', 'USA', 'Home', 1); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (310, 310, '2025-06-30', 1922.9, 3672.65, 1, 'Pending', '2025-07-03 12:28:37');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (311, 'Cole Anderson', 'salazarchristopher@example.com', '646.544.7640x658', '1966-12-21', 5, 'Excluded', '2025-07-02 14:11:11');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (311, 'ACC000311', 311, 'Checking', '2024-06-29', 1713.46, 5, 'Processed', '2025-07-01 04:31');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (311, 311, '784 Sanchez Expressway Suite 874', NULL, 'Patrickton', 'TX', '00649', 'USA', 'Billing', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (311, 311, '2025-06-30', 510.01, 2526.54, 5, 'Pending', '2025-07-02 02:17:23');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (312, 'Kiara Dickson', 'clevy@example.net', '(264)921-5803x20677', '2001-01-09', 1, 'Excluded', '2025-07-01 02:49:24');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (312, 'ACC000312', 312, 'Savings', '2023-11-16', 6988.11, 1, 'Processed', '2025-06-30 06:30');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (312, 312, '05189 Spence Mill', NULL, 'West Christopher', 'LA', '76548', 'USA', 'Home', 1); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (312, 312, '2025-06-20', 198.14, 4804.17, 1, 'Processed', '2025-07-03 17:22:10');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (313, 'Wendy Cunningham', 'randallbyrd@example.org', '4522169660', '1987-06-08', 2, 'Pending', '2025-07-02 10:06:39');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (313, 'ACC000313', 313, 'Loan', '2020-12-12', 8779.36, 2, 'Excluded', '2025-07-04 07:55');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (313, 313, '78818 Debra Pass', NULL, 'Lake Nicoleberg', 'TX', '47434', 'USA', 'Home', 2); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (313, 313, '2025-06-10', 1730.71, 103.75, 2, 'Processed', '2025-07-02 16:54:58');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (314, 'Luis Lopez', 'sweeneypaul@example.org', '001-912-935-7807x89801', '1968-08-12', 1, 'Pending', '2025-07-02 20:48:45');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (314, 'ACC000314', 314, 'Checking', '2022-05-05', 3504.29, 1, 'Excluded', '2025-07-03 03:37');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (314, 314, '18581 Jennifer Drive Suite 274', NULL, 'East Stephanie', 'SD', '74129', 'USA', 'Work', 1); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (314, 314, '2025-06-22', 1694.97, 3870.45, 1, 'Pending', '2025-06-30 03:16:22');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (315, 'Angela Smith', 'uporter@example.com', '883.892.8509x426', '1958-12-16', 5, 'Processed', '2025-06-30 09:26:45');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (315, 'ACC000315', 315, 'Checking', '2022-09-14', 1722.44, 5, 'Failed', '2025-07-03 19:13');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (315, 315, '99033 Brian Turnpike', NULL, 'North Anthony', 'PW', '79948', 'USA', 'Shipping', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (315, 315, '2025-06-15', 1923.89, 4074.39, 5, 'Processed', '2025-06-30 17:02:59');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (316, 'Joshua Zavala', 'ibates@example.net', '(899)716-5674x814', '1984-12-17', 5, 'Pending', '2025-07-03 06:09:43');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (316, 'ACC000316', 316, 'Checking', '2020-10-13', 7242.6, 5, 'Excluded', '2025-07-02 01:08');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (316, 316, '6081 Garza Ways', NULL, 'Maloneshire', 'DE', '68248', 'USA', 'Work', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (316, 316, '2025-06-05', 534.41, 3853.03, 5, 'Processed', '2025-06-30 21:51:56');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (317, 'Seth Huang', 'qdunn@example.com', '8684905260', '1997-04-26', 4, 'Failed', '2025-07-02 18:15:33');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (317, 'ACC000317', 317, 'Loan', '2023-03-05', 1590.35, 4, 'Excluded', '2025-07-01 00:51');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (317, 317, '101 Mikayla Trace', NULL, 'South Anthonychester', 'AS', '68059', 'USA', 'Billing', 4); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (317, 317, '2025-06-22', 399.62, 331.69, 4, 'Processed', '2025-07-03 04:00:01');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (318, 'Christy Newton', 'anthonymorse@example.com', '+1-388-728-6589', '1967-08-15', 5, 'Excluded', '2025-07-01 18:27:41');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (318, 'ACC000318', 318, 'Savings', '2023-12-31', 742.19, 5, 'Pending', '2025-06-29 23:17');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (318, 318, '73267 Paul Islands', NULL, 'Stewartborough', 'MT', '47554', 'USA', 'Shipping', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (318, 318, '2025-06-30', 369.77, 264.93, 5, 'Processed', '2025-06-29 23:08:39');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (319, 'Kathryn Jackson', 'leemartin@example.org', '574.814.1443', '1991-11-27', 1, 'Excluded', '2025-06-29 14:14:04');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (319, 'ACC000319', 319, 'Loan', '2020-07-06', 2608.75, 1, 'Pending', '2025-06-30 16:05');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (319, 319, '84606 Jeffery Parks Suite 927', NULL, 'Lake Jesus', 'MS', '87080', 'USA', 'Home', 1); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (319, 319, '2025-07-02', 1806.24, 3644.61, 1, 'Pending', '2025-06-30 17:38:26');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (320, 'Daniel Gordon', 'christina32@example.net', '(293)363-9313', '1975-09-21', 5, 'Failed', '2025-06-30 15:31:05');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (320, 'ACC000320', 320, 'Savings', '2024-02-16', 8851.56, 5, 'Failed', '2025-07-01 11:02');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (320, 320, '48937 Johnson Stream Apt. 586', NULL, 'New Kyle', 'PA', '20751', 'USA', 'Home', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (320, 320, '2025-06-26', 1458.9, 1006.11, 5, 'Pending', '2025-06-30 10:10:09');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (321, 'Amanda Williams', 'jennafrazier@example.com', '857.312.8182', '1989-04-30', 5, 'Excluded', '2025-07-01 03:32:38');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (321, 'ACC000321', 321, 'Checking', '2022-09-30', 1149.38, 5, 'Failed', '2025-06-30 18:58');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (321, 321, '163 Michael Ports', NULL, 'West Brandonville', 'MT', '11539', 'USA', 'Work', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (321, 321, '2025-07-02', 208.39, 360.09, 5, 'Processed', '2025-07-02 09:20:45');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (322, 'Roy Bates', 'xroberts@example.net', '001-848-764-3604x1162', '1956-01-21', 4, 'Processed', '2025-06-29 19:38:19');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (322, 'ACC000322', 322, 'Savings', '2024-02-16', 5539.24, 4, 'Failed', '2025-07-01 03:18');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (322, 322, '777 Leonard Lane Apt. 563', NULL, 'Gregorytown', 'UT', '69329', 'USA', 'Home', 4); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (322, 322, '2025-06-10', 1727.07, 1206.55, 4, 'Processed', '2025-07-01 10:23:24');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (323, 'Nicholas Scott', 'jamieparker@example.com', '(483)292-8841', '1978-12-22', 5, 'Excluded', '2025-07-02 20:24:05');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (323, 'ACC000323', 323, 'Checking', '2022-06-06', 9325.11, 5, 'Excluded', '2025-07-02 03:52');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (323, 323, '51091 Michael Estate', NULL, 'West Christopherton', 'TN', '70962', 'USA', 'Home', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (323, 323, '2025-06-24', 182.1, 3873.69, 5, 'Pending', '2025-07-03 23:30:23');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (324, 'Marcus Cooper', 'ihunter@example.com', '443-515-6254', '1981-09-15', 4, 'Pending', '2025-06-30 08:23:31');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (324, 'ACC000324', 324, 'Savings', '2021-02-10', 424.28, 4, 'Excluded', '2025-06-30 03:04');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (324, 324, '02142 Donna Plain', NULL, 'Nicoleville', 'WY', '85879', 'USA', 'Home', 4); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (324, 324, '2025-06-10', -281.03, 3855.05, 4, 'Failed', '2025-06-30 13:59:07');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (325, 'Sarah Dominguez', 'kimmeadows@example.net', '730-660-3574x1671', '1992-10-01', 4, 'Processed', '2025-06-29 18:20:54');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (325, 'ACC000325', 325, 'Savings', '2024-08-17', 5600.34, 4, 'Excluded', '2025-07-04 12:02');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (325, 325, '21871 Hays Plains Apt. 956', NULL, 'Lake Courtney', 'IN', '71491', 'USA', 'Billing', 4); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (325, 325, '2025-07-02', 147.2, 2980.2, 4, 'Processed', '2025-07-02 09:18:04');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (326, 'Stephen Colon', 'yvettemaldonado@example.org', '627.552.4966x71585', '1962-08-25', 3, 'Processed', '2025-07-02 03:45:07');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (326, 'ACC000326', 326, 'Checking', '2021-04-17', 5510.75, 3, 'Pending', '2025-06-29 23:58');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (326, 326, '33842 Harper Extensions Apt. 272', NULL, 'Amandastad', 'FL', '14691', 'USA', 'Billing', 3); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (326, 326, '2025-06-13', -128.63, 2339.96, 3, 'Pending', '2025-07-01 17:07:12');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (327, 'Emily Morrow', 'warddana@example.net', '(891)286-1034x8930', '1994-11-18', 3, 'Pending', '2025-07-01 19:25:16');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (327, 'ACC000327', 327, 'Checking', '2024-07-04', 4900.81, 3, 'Excluded', '2025-07-01 01:40');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (327, 327, '20505 James Plaza Apt. 558', NULL, 'Williamsburgh', 'PW', '39843', 'USA', 'Shipping', 3); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (327, 327, '2025-06-28', 1123.95, 3040.61, 3, 'Pending', '2025-07-03 22:07:39');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (328, 'Dale Wang', 'matthewdouglas@example.net', '001-899-768-5681', '1974-10-30', 3, 'Failed', '2025-07-01 17:31:17');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (328, 'ACC000328', 328, 'Checking', '2021-09-26', 7151.17, 3, 'Processed', '2025-06-29 20:57');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (328, 328, '3170 Cheryl Harbors', NULL, 'North Ryanview', 'UT', '14186', 'USA', 'Billing', 3); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (328, 328, '2025-06-11', -103.67, 4253.3, 3, 'Pending', '2025-07-03 07:35:58');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (329, 'Allison Christensen', 'pkelly@example.com', '+1-593-251-4371', '1960-07-03', 1, 'Processed', '2025-07-02 17:24:40');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (329, 'ACC000329', 329, 'Savings', '2022-06-04', 6873.53, 1, 'Failed', '2025-06-30 22:28');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (329, 329, '240 Deborah Corners Suite 495', NULL, 'West Edward', 'IN', '67991', 'USA', 'Home', 1); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (329, 329, '2025-06-16', -364.27, 3825.59, 1, 'Failed', '2025-07-03 03:36:08');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (330, 'Stephen Wolfe', 'jennifer85@example.net', '500.507.8241', '1986-03-31', 2, 'Processed', '2025-07-04 09:51:13');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (330, 'ACC000330', 330, 'Checking', '2024-07-30', 6990.98, 2, 'Excluded', '2025-07-03 23:39');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (330, 330, '620 Joseph Lodge Suite 895', NULL, 'Lutzberg', 'VI', '25126', 'USA', 'Work', 2); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (330, 330, '2025-07-03', 1362.87, 2300.67, 2, 'Failed', '2025-07-01 08:48:12');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (331, 'Christopher Mayer', 'sharptodd@example.org', '+1-450-669-1404x08891', '1962-02-18', 3, 'Pending', '2025-07-02 17:58:52');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (331, 'ACC000331', 331, 'Loan', '2023-09-20', 5274.09, 3, 'Pending', '2025-07-01 07:04');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (331, 331, '3009 Shelley Green', NULL, 'North Johnville', 'NE', '61102', 'USA', 'Home', 3); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (331, 331, '2025-06-24', 1102.97, 192.87, 3, 'Excluded', '2025-07-04 06:01:28');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (332, 'John Garrison', 'keith54@example.org', '001-461-990-7323x6893', '1953-09-21', 4, 'Processed', '2025-06-30 23:35:58');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (332, 'ACC000332', 332, 'Savings', '2023-06-28', 3230.82, 4, 'Excluded', '2025-07-04 13:56');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (332, 332, '8409 Jackson Ridges', NULL, 'South Matthew', 'WI', '43801', 'USA', 'Work', 4); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (332, 332, '2025-06-14', 95.38, 2877.84, 4, 'Excluded', '2025-07-02 08:45:57');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (333, 'Marc Hines', 'mclark@example.com', '(578)587-2012', '2001-10-02', 4, 'Processed', '2025-07-01 19:38:55');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (333, 'ACC000333', 333, 'Loan', '2023-05-21', 579.71, 4, 'Pending', '2025-07-03 11:03');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (333, 333, '424 Mccullough Ranch', NULL, 'Michaelmouth', 'FL', '96657', 'USA', 'Home', 4); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (333, 333, '2025-06-26', 394.4, 429.74, 4, 'Failed', '2025-06-29 15:00:49');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (334, 'James Roy', 'bennettandrea@example.com', '333-219-7069', '1954-11-15', 3, 'Pending', '2025-06-30 05:42:52');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (334, 'ACC000334', 334, 'Loan', '2021-10-30', 6784.15, 3, 'Processed', '2025-07-01 17:48');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (334, 334, '13517 Jason Ways Suite 627', NULL, 'West Debra', 'UT', '27953', 'USA', 'Shipping', 3); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (334, 334, '2025-06-12', -627.78, 4962.73, 3, 'Failed', '2025-07-03 02:33:50');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (335, 'William Ross', 'deborah36@example.org', '615.809.1671', '1992-03-03', 4, 'Failed', '2025-07-03 15:06:40');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (335, 'ACC000335', 335, 'Loan', '2023-02-02', 9411.75, 4, 'Pending', '2025-07-02 18:13');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (335, 335, '929 Marcus Run', NULL, 'Lake Anatown', 'AK', '95735', 'USA', 'Shipping', 4); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (335, 335, '2025-06-29', 1892.08, 4225.11, 4, 'Failed', '2025-06-29 19:38:03');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (336, 'Michael Jackson', 'thomasjacobs@example.com', '001-435-323-6116x1407', '1985-07-06', 3, 'Failed', '2025-07-01 10:05:14');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (336, 'ACC000336', 336, 'Savings', '2020-12-18', 8858.95, 3, 'Failed', '2025-06-30 07:41');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (336, 336, '415 Ashley Haven Suite 429', NULL, 'Lake Joseph', 'PA', '45778', 'USA', 'Work', 3); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (336, 336, '2025-06-08', -804.59, 4923.26, 3, 'Excluded', '2025-07-02 23:55:54');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (337, 'Steven Mack', 'susanjenkins@example.org', '001-840-882-1557', '1953-08-25', 2, 'Processed', '2025-07-01 21:23:21');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (337, 'ACC000337', 337, 'Checking', '2022-05-07', 3372.47, 2, 'Pending', '2025-06-30 12:36');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (337, 337, '650 Hart Road Suite 251', NULL, 'North Michelle', 'IL', '54620', 'USA', 'Work', 2); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (337, 337, '2025-06-27', -907.89, 3966.97, 2, 'Excluded', '2025-07-03 12:49:29');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (338, 'Cody Le', 'bryceblack@example.net', '274.698.7353x760', '2004-10-18', 1, 'Excluded', '2025-07-03 03:03:53');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (338, 'ACC000338', 338, 'Savings', '2025-05-30', 3979.15, 1, 'Processed', '2025-07-02 23:33');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (338, 338, '878 Richard Cliffs', NULL, 'Kimshire', 'NJ', '73311', 'USA', 'Home', 1); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (338, 338, '2025-06-12', 1470.93, 2434.44, 1, 'Excluded', '2025-07-02 15:50:22');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (339, 'Karen Hudson', 'richard97@example.com', '+1-217-209-1620x26357', '1997-02-23', 4, 'Excluded', '2025-07-01 23:07:17');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (339, 'ACC000339', 339, 'Loan', '2023-10-21', 5351.5, 4, 'Processed', '2025-06-29 14:09');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (339, 339, '36674 Gregory Summit Suite 313', NULL, 'New Jefferyville', 'ID', '29809', 'USA', 'Shipping', 4); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (339, 339, '2025-06-20', -562.22, 789.03, 4, 'Excluded', '2025-07-03 03:53:46');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (340, 'Tara Henry', 'daryl77@example.net', '2779385998', '1970-07-03', 2, 'Processed', '2025-06-30 14:19:21');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (340, 'ACC000340', 340, 'Savings', '2023-09-09', 6483.33, 2, 'Pending', '2025-06-30 12:05');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (340, 340, '227 Wells Dale Apt. 214', NULL, 'Palmerstad', 'OR', '80330', 'USA', 'Home', 2); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (340, 340, '2025-06-18', -276.73, 2452.46, 2, 'Failed', '2025-07-04 11:03:01');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (341, 'Linda Allen', 'haasshannon@example.com', '555.413.8536x877', '1972-06-16', 3, 'Excluded', '2025-07-04 00:16:08');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (341, 'ACC000341', 341, 'Checking', '2021-10-16', 5705.65, 3, 'Processed', '2025-07-01 06:08');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (341, 341, '64604 Jamie Streets Apt. 488', NULL, 'New Christopher', 'TX', '03401', 'USA', 'Billing', 3); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (341, 341, '2025-06-09', -47.93, 1263.57, 3, 'Pending', '2025-07-04 02:00:06');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (342, 'Amber Harris', 'tanya29@example.org', '001-631-498-0293x6842', '1979-08-16', 4, 'Processed', '2025-07-02 16:58:20');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (342, 'ACC000342', 342, 'Checking', '2021-03-21', 2452.25, 4, 'Pending', '2025-07-03 04:02');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (342, 342, '3657 Audrey Lakes Apt. 437', NULL, 'East Margaretmouth', 'ME', '83170', 'USA', 'Shipping', 4); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (342, 342, '2025-06-10', -859.22, 4122.54, 4, 'Failed', '2025-07-04 03:32:29');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (343, 'Levi Graham', 'rritter@example.net', '001-750-836-9307x668', '1986-03-19', 2, 'Processed', '2025-07-03 00:59:19');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (343, 'ACC000343', 343, 'Checking', '2021-07-30', 4203.05, 2, 'Excluded', '2025-06-30 12:21');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (343, 343, '9321 Andrew Grove', NULL, 'South Jeffrey', 'VT', '05352', 'USA', 'Home', 2); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (343, 343, '2025-06-08', -273.53, 3766.46, 2, 'Excluded', '2025-07-02 21:35:12');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (344, 'Marie Brooks', 'westjudy@example.net', '(307)743-0678x4265', '2003-04-13', 4, 'Failed', '2025-06-30 06:28:56');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (344, 'ACC000344', 344, 'Checking', '2024-03-25', 7312.2, 4, 'Processed', '2025-07-02 17:42');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (344, 344, '0019 Erika Gardens Suite 877', NULL, 'Kennedyhaven', 'IN', '63425', 'USA', 'Billing', 4); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (344, 344, '2025-06-29', 914.79, 298.68, 4, 'Processed', '2025-07-04 12:29:00');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (345, 'Sean Elliott', 'josephholder@example.com', '001-691-580-4074x8361', '1988-09-07', 1, 'Failed', '2025-07-03 22:25:17');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (345, 'ACC000345', 345, 'Loan', '2025-02-20', 2379.61, 1, 'Processed', '2025-07-02 02:04');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (345, 345, '2916 Sanchez Brooks Apt. 148', NULL, 'Gregmouth', 'NV', '46321', 'USA', 'Billing', 1); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (345, 345, '2025-06-04', 930.77, 1279.45, 1, 'Excluded', '2025-07-01 18:56:04');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (346, 'Anita Russo', 'tracywhitney@example.org', '(875)315-1944x9109', '1992-08-31', 5, 'Excluded', '2025-07-02 17:06:23');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (346, 'ACC000346', 346, 'Loan', '2023-07-05', 1859.77, 5, 'Processed', '2025-07-02 07:48');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (346, 346, '5886 Mann Stream', NULL, 'Andersonberg', 'NE', '24003', 'USA', 'Work', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (346, 346, '2025-06-08', 1402.31, 1300.82, 5, 'Failed', '2025-07-03 10:46:11');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (347, 'Megan Dixon', 'meganmitchell@example.net', '322-917-2598x4518', '1956-04-27', 3, 'Failed', '2025-07-01 04:37:20');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (347, 'ACC000347', 347, 'Loan', '2022-12-04', 1131.39, 3, 'Pending', '2025-06-29 19:31');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (347, 347, '89565 Montoya Centers', NULL, 'East Jennifer', 'ID', '04866', 'USA', 'Home', 3); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (347, 347, '2025-06-27', 721.12, 3240.11, 3, 'Failed', '2025-07-01 05:55:56');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (348, 'Joseph Flores', 'lopeztara@example.com', '940-535-4054', '1989-01-28', 4, 'Pending', '2025-07-02 06:39:45');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (348, 'ACC000348', 348, 'Savings', '2023-02-04', 4255.34, 4, 'Excluded', '2025-06-30 15:03');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (348, 348, '5329 Kimberly Junction', NULL, 'Martinview', 'AL', '18949', 'USA', 'Home', 4); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (348, 348, '2025-07-03', 866.23, 2238.41, 4, 'Failed', '2025-07-04 12:06:40');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (349, 'Megan Taylor', 'tammy41@example.com', '2975078199', '1971-12-24', 1, 'Pending', '2025-07-03 05:51:39');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (349, 'ACC000349', 349, 'Checking', '2024-09-14', 286.04, 1, 'Pending', '2025-07-01 22:26');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (349, 349, '3463 Fox Port Apt. 047', NULL, 'Henryshire', 'NM', '64599', 'USA', 'Work', 1); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (349, 349, '2025-06-14', 1973.52, 922.47, 1, 'Failed', '2025-06-30 23:08:20');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (350, 'Philip Long', 'terrance81@example.com', '693.273.2687', '1994-02-05', 1, 'Excluded', '2025-07-01 12:23:44');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (350, 'ACC000350', 350, 'Checking', '2021-06-28', 1464.89, 1, 'Processed', '2025-07-04 05:05');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (350, 350, '01746 Dominguez Inlet Suite 495', NULL, 'New Melvin', 'MN', '13731', 'USA', 'Work', 1); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (350, 350, '2025-06-28', -454.63, 2852.72, 1, 'Processed', '2025-07-02 19:00:32');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (351, 'Jonathan Lewis', 'cookemichael@example.net', '001-959-997-6583', '1978-04-10', 2, 'Excluded', '2025-07-03 23:12:22');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (351, 'ACC000351', 351, 'Checking', '2021-09-15', 1745.33, 2, 'Excluded', '2025-07-02 07:46');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (351, 351, '2124 Smith Greens', NULL, 'Perezport', 'GA', '93117', 'USA', 'Work', 2); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (351, 351, '2025-06-05', -546.85, 4393.61, 2, 'Failed', '2025-07-02 05:05:53');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (352, 'Darryl Zavala', 'thuynh@example.com', '468-516-5269x910', '1977-09-24', 3, 'Processed', '2025-07-03 22:55:24');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (352, 'ACC000352', 352, 'Checking', '2020-08-23', 9070.55, 3, 'Pending', '2025-06-30 06:27');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (352, 352, '345 Barron Bypass', NULL, 'North Samuel', 'FM', '36150', 'USA', 'Shipping', 3); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (352, 352, '2025-06-10', 1770.04, 2941.83, 3, 'Processed', '2025-07-02 01:19:59');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (353, 'Angel Barry', 'ahernandez@example.org', '001-700-977-5845', '1971-11-09', 4, 'Processed', '2025-06-30 18:15:14');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (353, 'ACC000353', 353, 'Loan', '2024-09-19', 7175.32, 4, 'Pending', '2025-07-04 07:08');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (353, 353, '00982 Robles Mountains', NULL, 'Emilyfort', 'MH', '80512', 'USA', 'Work', 4); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (353, 353, '2025-06-11', -400.24, 4900.03, 4, 'Processed', '2025-07-04 05:51:03');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (354, 'Carrie Swanson', 'lisadunn@example.com', '213.923.4179', '1994-04-30', 4, 'Excluded', '2025-06-29 16:20:33');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (354, 'ACC000354', 354, 'Loan', '2021-01-08', 1368.23, 4, 'Pending', '2025-06-30 22:28');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (354, 354, '9487 Renee Hills', NULL, 'Anthonyville', 'AL', '50994', 'USA', 'Billing', 4); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (354, 354, '2025-06-15', 297.47, 2192.88, 4, 'Excluded', '2025-07-01 22:49:05');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (355, 'Brenda Moore', 'ashleywhite@example.org', '+1-994-356-1010x74948', '1989-10-14', 2, 'Excluded', '2025-06-30 13:32:25');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (355, 'ACC000355', 355, 'Checking', '2020-07-23', 197.72, 2, 'Excluded', '2025-07-02 14:17');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (355, 355, '69671 Jamie Mission Apt. 166', NULL, 'Ashleyshire', 'FM', '76426', 'USA', 'Work', 2); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (355, 355, '2025-06-15', -240.96, 4207.3, 2, 'Excluded', '2025-06-29 18:00:01');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (356, 'Brian Randall', 'patriciadunn@example.org', '729.748.0440x555', '1980-03-27', 4, 'Excluded', '2025-07-02 19:14:16');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (356, 'ACC000356', 356, 'Savings', '2023-03-28', 3700.84, 4, 'Failed', '2025-07-01 20:57');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (356, 356, '08323 Foley Cove Suite 728', NULL, 'Stephanieberg', 'OR', '84935', 'USA', 'Home', 4); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (356, 356, '2025-06-13', 644.67, 1568.58, 4, 'Failed', '2025-07-02 20:39:14');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (357, 'Victoria Johnson', 'deborah16@example.net', '552.793.3071', '1964-08-25', 4, 'Failed', '2025-06-30 07:23:42');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (357, 'ACC000357', 357, 'Checking', '2022-11-11', 1424.67, 4, 'Excluded', '2025-07-02 22:33');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (357, 357, '8629 Robinson Squares Suite 838', NULL, 'North Steven', 'ID', '85721', 'USA', 'Work', 4); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (357, 357, '2025-06-28', -995.61, 935.53, 4, 'Failed', '2025-07-04 05:47:25');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (358, 'Timothy Nguyen', 'bergertracy@example.org', '+1-271-844-9550x16258', '1995-08-01', 4, 'Failed', '2025-07-02 19:56:13');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (358, 'ACC000358', 358, 'Checking', '2022-05-24', 5434.3, 4, 'Failed', '2025-07-03 15:41');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (358, 358, '7509 Sara Gardens', NULL, 'East Ashley', 'MT', '00945', 'USA', 'Home', 4); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (358, 358, '2025-06-26', -492.58, 1765.62, 4, 'Processed', '2025-07-03 09:24:29');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (359, 'Megan Thompson', 'torrestaylor@example.org', '895-593-4224', '1955-03-28', 2, 'Processed', '2025-07-03 03:49:14');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (359, 'ACC000359', 359, 'Savings', '2022-08-13', 6854.49, 2, 'Excluded', '2025-07-03 22:28');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (359, 359, '6303 Benjamin Haven', NULL, 'North Stephaniestad', 'NH', '50352', 'USA', 'Billing', 2); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (359, 359, '2025-06-29', 316.68, 666.71, 2, 'Pending', '2025-06-30 11:46:14');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (360, 'Tammy Oconnor', 'lucasteresa@example.org', '001-630-928-7958x027', '1966-10-15', 3, 'Pending', '2025-07-04 08:27:42');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (360, 'ACC000360', 360, 'Savings', '2020-11-25', 945.39, 3, 'Pending', '2025-07-03 11:12');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (360, 360, '02348 Burton Cliff Apt. 103', NULL, 'Clarkefurt', 'AS', '10909', 'USA', 'Work', 3); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (360, 360, '2025-06-30', 839.73, 3684.29, 3, 'Pending', '2025-06-30 18:59:12');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (361, 'Jessica Le', 'melodysavage@example.com', '233.441.5729', '1997-04-10', 4, 'Failed', '2025-07-02 12:00:18');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (361, 'ACC000361', 361, 'Savings', '2021-11-08', 418.45, 4, 'Processed', '2025-07-03 22:07');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (361, 361, '45500 White Squares', NULL, 'Anthonyside', 'PA', '97679', 'USA', 'Home', 4); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (361, 361, '2025-07-02', 1403.03, 3338.04, 4, 'Processed', '2025-07-04 12:04:33');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (362, 'Daniel Berry', 'lisathomas@example.org', '659-555-5830x06332', '1969-05-01', 2, 'Excluded', '2025-07-03 07:31:29');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (362, 'ACC000362', 362, 'Loan', '2020-11-09', 5364.47, 2, 'Excluded', '2025-07-02 22:23');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (362, 362, '9791 Villanueva Path Suite 809', NULL, 'West Kyle', 'OR', '62362', 'USA', 'Shipping', 2); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (362, 362, '2025-06-07', 1077.23, 4399.82, 2, 'Excluded', '2025-07-01 02:43:02');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (363, 'Colton Palmer', 'taylorjose@example.org', '464.965.9331x22684', '1992-10-21', 2, 'Excluded', '2025-07-02 17:20:21');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (363, 'ACC000363', 363, 'Loan', '2022-03-15', 7390.79, 2, 'Failed', '2025-07-03 23:14');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (363, 363, '5630 Sullivan Forks', NULL, 'Danielbury', 'AK', '39212', 'USA', 'Billing', 2); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (363, 363, '2025-06-10', 171.25, 948.66, 2, 'Processed', '2025-06-30 01:54:03');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (364, 'Amy Lowe', 'williambarry@example.net', '501-635-7722x02464', '2002-09-16', 1, 'Pending', '2025-07-04 00:35:13');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (364, 'ACC000364', 364, 'Savings', '2022-10-19', 1933.06, 1, 'Processed', '2025-07-01 11:07');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (364, 364, '1548 Lawrence Glens', NULL, 'New Lisa', 'PW', '14764', 'USA', 'Billing', 1); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (364, 364, '2025-06-24', -130.56, 566.33, 1, 'Pending', '2025-07-01 12:11:05');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (365, 'Joshua White', 'david49@example.org', '447-264-1166x9189', '1995-01-14', 4, 'Excluded', '2025-07-02 18:01:49');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (365, 'ACC000365', 365, 'Savings', '2022-01-07', 6233.71, 4, 'Processed', '2025-07-02 04:26');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (365, 365, '0481 Yesenia Garden Suite 938', NULL, 'Allenberg', 'HI', '61972', 'USA', 'Shipping', 4); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (365, 365, '2025-06-14', -75.09, 154.22, 4, 'Pending', '2025-06-29 22:16:59');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (366, 'Jason Hampton', 'erinjohnson@example.com', '436.954.9110x03642', '1999-09-09', 3, 'Excluded', '2025-07-01 04:06:42');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (366, 'ACC000366', 366, 'Checking', '2023-09-02', 9923.12, 3, 'Processed', '2025-06-29 23:24');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (366, 366, '48086 Riley Row', NULL, 'North Donaldmouth', 'FM', '05363', 'USA', 'Home', 3); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (366, 366, '2025-06-16', 332.66, 4031.63, 3, 'Pending', '2025-07-01 09:04:11');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (367, 'Sandra Howe', 'iclark@example.com', '758-741-3081x374', '1975-02-28', 5, 'Processed', '2025-07-02 21:22:19');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (367, 'ACC000367', 367, 'Checking', '2021-02-28', 6535.77, 5, 'Processed', '2025-07-01 11:20');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (367, 367, '28458 Cathy Streets', NULL, 'East Kirstenstad', 'FM', '33227', 'USA', 'Shipping', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (367, 367, '2025-06-08', 1053.3, 33.49, 5, 'Processed', '2025-06-30 18:17:23');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (368, 'Dean Johnson', 'gloriawilliams@example.com', '596-631-6928x3048', '1998-09-28', 4, 'Processed', '2025-06-30 14:48:24');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (368, 'ACC000368', 368, 'Savings', '2023-09-09', 4873.37, 4, 'Pending', '2025-07-03 17:24');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (368, 368, '944 Michael Club Suite 265', NULL, 'Port Joelberg', 'ID', '81166', 'USA', 'Work', 4); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (368, 368, '2025-06-19', -793.16, 3793.0, 4, 'Excluded', '2025-07-02 23:43:43');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (369, 'Eric Hogan', 'logan54@example.org', '397.441.3001x82715', '2002-03-12', 5, 'Excluded', '2025-07-03 14:16:49');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (369, 'ACC000369', 369, 'Loan', '2025-02-14', 7228.41, 5, 'Failed', '2025-07-03 01:56');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (369, 369, '79977 Haas Ford Apt. 949', NULL, 'Hernandezmouth', 'MN', '86703', 'USA', 'Shipping', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (369, 369, '2025-06-19', -253.54, 1040.27, 5, 'Failed', '2025-07-01 15:07:15');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (370, 'Andrea Henderson', 'michael40@example.org', '001-491-911-6017x384', '1957-09-05', 3, 'Pending', '2025-06-29 15:54:55');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (370, 'ACC000370', 370, 'Savings', '2021-12-03', 8338.97, 3, 'Failed', '2025-07-03 14:10');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (370, 370, '53935 Melissa Station Apt. 014', NULL, 'Amberhaven', 'WV', '50046', 'USA', 'Shipping', 3); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (370, 370, '2025-06-14', -997.98, 2002.05, 3, 'Failed', '2025-07-03 08:46:08');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (371, 'Daniel Harper', 'jgamble@example.com', '(726)933-0594x11907', '1984-11-07', 3, 'Processed', '2025-07-02 11:23:18');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (371, 'ACC000371', 371, 'Savings', '2021-05-29', 1270.98, 3, 'Excluded', '2025-07-02 02:04');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (371, 371, '850 Cooper Ford Suite 336', NULL, 'Tonytown', 'HI', '65060', 'USA', 'Work', 3); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (371, 371, '2025-06-04', -75.08, 4154.23, 3, 'Excluded', '2025-07-03 08:10:07');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (372, 'Diana Franklin', 'stephaniethompson@example.org', '+1-925-439-8377', '1990-01-14', 1, 'Processed', '2025-07-02 08:02:45');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (372, 'ACC000372', 372, 'Checking', '2023-07-18', 6298.18, 1, 'Pending', '2025-07-04 09:26');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (372, 372, '1638 Shannon Union Apt. 066', NULL, 'Ashleymouth', 'RI', '63675', 'USA', 'Work', 1); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (372, 372, '2025-06-27', 130.1, 1576.48, 1, 'Excluded', '2025-07-01 08:01:28');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (373, 'Heather Edwards', 'xjordan@example.org', '(710)349-5620x93862', '1957-07-02', 5, 'Processed', '2025-07-01 11:48:22');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (373, 'ACC000373', 373, 'Savings', '2024-10-14', 456.13, 5, 'Processed', '2025-06-30 07:15');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (373, 373, '948 Kari Ferry Suite 761', NULL, 'West Samanthaville', 'KY', '08154', 'USA', 'Billing', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (373, 373, '2025-06-10', 1413.72, 1965.53, 5, 'Pending', '2025-07-01 15:58:54');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (374, 'Julie Ashley', 'hsexton@example.com', '(456)862-4143x9110', '1982-03-17', 5, 'Excluded', '2025-07-04 11:56:21');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (374, 'ACC000374', 374, 'Savings', '2023-08-14', 3854.67, 5, 'Pending', '2025-07-01 05:01');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (374, 374, '96661 Mullins Vista', NULL, 'East Jacobchester', 'DC', '88962', 'USA', 'Billing', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (374, 374, '2025-06-14', 927.71, 3258.0, 5, 'Pending', '2025-07-03 01:20:09');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (375, 'Dorothy Love', 'cjohnson@example.com', '(275)532-5467x333', '1993-12-05', 2, 'Processed', '2025-06-29 16:51:36');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (375, 'ACC000375', 375, 'Checking', '2021-09-26', 5648.43, 2, 'Processed', '2025-07-02 05:37');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (375, 375, '127 Shannon Pine Suite 254', NULL, 'Port Christopherfurt', 'AZ', '27822', 'USA', 'Home', 2); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (375, 375, '2025-06-23', 1212.83, 3815.91, 2, 'Excluded', '2025-07-03 02:25:57');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (376, 'David Jones', 'shall@example.net', '460-773-7927', '2001-09-15', 4, 'Failed', '2025-06-30 05:05:59');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (376, 'ACC000376', 376, 'Loan', '2021-04-29', 2275.53, 4, 'Failed', '2025-06-30 07:28');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (376, 376, '9278 Stephen Throughway Suite 564', NULL, 'West Barbara', 'SD', '67516', 'USA', 'Billing', 4); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (376, 376, '2025-06-25', -629.03, 4012.5, 4, 'Excluded', '2025-07-02 20:04:01');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (377, 'Kimberly Sherman', 'charlesthomas@example.com', '921.773.9469x508', '1976-02-27', 5, 'Processed', '2025-07-03 13:53:04');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (377, 'ACC000377', 377, 'Checking', '2022-07-26', 2786.41, 5, 'Failed', '2025-06-30 17:34');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (377, 377, '521 Glenda Summit', NULL, 'Wiseland', 'MS', '33400', 'USA', 'Billing', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (377, 377, '2025-06-21', -379.86, 4284.23, 5, 'Failed', '2025-07-01 03:08:53');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (378, 'Philip Scott', 'igray@example.com', '480.464.9489x680', '2001-08-17', 2, 'Excluded', '2025-06-29 20:01:04');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (378, 'ACC000378', 378, 'Loan', '2022-03-02', 4876.29, 2, 'Pending', '2025-07-04 12:58');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (378, 378, '91524 Cooper Falls', NULL, 'East Stefaniemouth', 'FL', '45462', 'USA', 'Billing', 2); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (378, 378, '2025-06-08', 272.54, 937.65, 2, 'Pending', '2025-06-29 17:53:57');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (379, 'Laurie Johnson', 'kristenwilliamson@example.org', '+1-644-915-6186x345', '1959-09-11', 2, 'Pending', '2025-07-04 03:42:03');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (379, 'ACC000379', 379, 'Loan', '2022-07-25', 578.99, 2, 'Processed', '2025-06-30 04:33');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (379, 379, '8594 Keller Dam', NULL, 'North William', 'WI', '83032', 'USA', 'Work', 2); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (379, 379, '2025-06-17', -585.65, 2898.6, 2, 'Pending', '2025-07-01 14:08:35');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (380, 'Michelle Buchanan', 'clarkejessica@example.net', '(889)748-4411', '1961-02-04', 1, 'Processed', '2025-06-29 17:33:21');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (380, 'ACC000380', 380, 'Savings', '2024-03-02', 9078.92, 1, 'Pending', '2025-07-01 22:26');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (380, 380, '39793 Steven Pines', NULL, 'Port Michael', 'OH', '99641', 'USA', 'Billing', 1); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (380, 380, '2025-06-29', -322.45, 1031.36, 1, 'Excluded', '2025-07-03 06:56:59');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (381, 'Wendy Berry', 'cochranashley@example.net', '792-621-2769', '1975-02-15', 5, 'Processed', '2025-06-30 23:18:37');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (381, 'ACC000381', 381, 'Loan', '2021-01-11', 7072.31, 5, 'Excluded', '2025-07-03 21:10');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (381, 381, '5422 Todd Well Apt. 922', NULL, 'East Hannah', 'WV', '25677', 'USA', 'Billing', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (381, 381, '2025-06-28', -923.2, 2215.78, 5, 'Excluded', '2025-07-01 15:42:44');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (382, 'Edward Nixon', 'adrian52@example.com', '757.267.7765x6046', '1979-12-12', 2, 'Excluded', '2025-06-30 01:40:04');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (382, 'ACC000382', 382, 'Loan', '2020-09-17', 7307.05, 2, 'Excluded', '2025-06-30 05:34');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (382, 382, '991 Hayden Street Suite 748', NULL, 'Tammyside', 'PW', '05906', 'USA', 'Work', 2); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (382, 382, '2025-06-26', -70.81, 4050.89, 2, 'Excluded', '2025-07-03 23:16:24');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (383, 'Frederick Cooke', 'holdercynthia@example.com', '001-547-440-0129x726', '1974-01-30', 3, 'Excluded', '2025-06-30 05:22:52');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (383, 'ACC000383', 383, 'Savings', '2025-01-23', 3061.9, 3, 'Excluded', '2025-07-01 22:38');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (383, 383, '2938 Charles Summit', NULL, 'Lisaborough', 'FM', '11674', 'USA', 'Shipping', 3); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (383, 383, '2025-06-17', -281.73, 4059.35, 3, 'Excluded', '2025-06-30 14:54:52');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (384, 'Alexis Thomas', 'travisblack@example.org', '6645789211', '1985-10-16', 3, 'Excluded', '2025-06-29 21:52:14');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (384, 'ACC000384', 384, 'Savings', '2023-12-07', 4434.61, 3, 'Pending', '2025-07-04 12:34');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (384, 384, '104 Christina Port Apt. 317', NULL, 'Lake Richard', 'WA', '11584', 'USA', 'Home', 3); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (384, 384, '2025-06-09', 301.6, 4191.61, 3, 'Excluded', '2025-07-01 17:11:50');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (385, 'Mr. Richard Ortiz', 'monique51@example.com', '339.530.9417x47149', '1978-04-11', 5, 'Pending', '2025-06-30 02:37:06');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (385, 'ACC000385', 385, 'Loan', '2023-01-07', 7041.18, 5, 'Failed', '2025-06-30 18:46');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (385, 385, '718 Julie Knoll', NULL, 'Murphychester', 'NJ', '16254', 'USA', 'Home', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (385, 385, '2025-06-29', -85.68, 695.94, 5, 'Failed', '2025-07-01 21:17:06');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (386, 'Tara Brown', 'jennifer71@example.net', '4068321831', '1998-02-05', 5, 'Pending', '2025-06-30 07:59:46');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (386, 'ACC000386', 386, 'Checking', '2023-09-21', 3349.47, 5, 'Excluded', '2025-07-01 16:23');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (386, 386, '22301 Arnold Summit Apt. 073', NULL, 'Lewisborough', 'ND', '02704', 'USA', 'Shipping', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (386, 386, '2025-07-03', 1630.55, 4066.39, 5, 'Failed', '2025-07-01 07:58:33');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (387, 'Jennifer Perez', 'kyle10@example.com', '525-285-8373x38299', '1955-11-03', 4, 'Processed', '2025-06-29 19:14:34');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (387, 'ACC000387', 387, 'Loan', '2021-04-03', 9371.82, 4, 'Processed', '2025-07-02 10:20');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (387, 387, '814 Strickland Manor Apt. 451', NULL, 'Jasonfurt', 'HI', '21141', 'USA', 'Shipping', 4); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (387, 387, '2025-06-26', -276.13, 3626.73, 4, 'Failed', '2025-06-30 16:15:43');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (388, 'Dr. Megan Simpson', 'kellylewis@example.org', '(441)468-1097', '1979-10-14', 1, 'Pending', '2025-06-29 15:57:09');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (388, 'ACC000388', 388, 'Savings', '2021-05-10', 4775.17, 1, 'Processed', '2025-07-02 06:21');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (388, 388, '3367 Sanchez Port Apt. 434', NULL, 'Thomasborough', 'AL', '80388', 'USA', 'Work', 1); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (388, 388, '2025-06-14', -11.5, 1618.92, 1, 'Excluded', '2025-07-02 02:53:15');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (389, 'Sara Flores', 'jameshardy@example.net', '2738604221', '1987-04-13', 2, 'Failed', '2025-06-30 03:57:44');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (389, 'ACC000389', 389, 'Loan', '2020-08-13', 7054.37, 2, 'Failed', '2025-07-03 21:46');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (389, 389, '46562 Kathryn Highway Suite 368', NULL, 'Catherineberg', 'TX', '28297', 'USA', 'Work', 2); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (389, 389, '2025-07-03', 1330.79, 131.01, 2, 'Excluded', '2025-07-04 11:59:33');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (390, 'Michelle Tapia', 'johnsongeorge@example.org', '001-762-383-7707', '1982-08-24', 1, 'Excluded', '2025-06-30 16:46:34');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (390, 'ACC000390', 390, 'Savings', '2025-03-13', 4745.13, 1, 'Excluded', '2025-07-02 13:19');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (390, 390, '453 Laurie Shore Suite 980', NULL, 'West Claudiaburgh', 'LA', '75772', 'USA', 'Work', 1); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (390, 390, '2025-06-21', -658.54, 3819.33, 1, 'Processed', '2025-07-02 13:32:45');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (391, 'Nicholas Fisher', 'hmiller@example.org', '655-229-6042x5955', '1959-11-04', 4, 'Processed', '2025-07-02 13:11:04');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (391, 'ACC000391', 391, 'Loan', '2025-05-10', 7711.74, 4, 'Processed', '2025-07-01 16:24');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (391, 391, '092 Ferguson Summit Suite 854', NULL, 'West Lori', 'WV', '84227', 'USA', 'Home', 4); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (391, 391, '2025-06-16', 1060.12, 4241.29, 4, 'Pending', '2025-06-29 14:43:45');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (392, 'David Stephens', 'fpowell@example.org', '631.664.8526', '1965-02-28', 2, 'Excluded', '2025-07-03 13:52:15');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (392, 'ACC000392', 392, 'Loan', '2021-12-24', 9152.28, 2, 'Failed', '2025-06-29 15:18');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (392, 392, '5564 Sanchez Mall', NULL, 'New Amanda', 'MN', '77294', 'USA', 'Billing', 2); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (392, 392, '2025-06-19', -566.61, 791.79, 2, 'Failed', '2025-07-04 08:58:17');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (393, 'Seth Contreras', 'scott80@example.org', '(440)766-3514', '1989-02-04', 4, 'Failed', '2025-06-29 21:08:18');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (393, 'ACC000393', 393, 'Checking', '2023-11-07', 5314.08, 4, 'Pending', '2025-06-30 22:46');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (393, 393, '2465 Parker Junctions Apt. 927', NULL, 'Brendamouth', 'MD', '01531', 'USA', 'Work', 4); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (393, 393, '2025-06-10', 1341.16, 3575.23, 4, 'Pending', '2025-07-03 19:50:55');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (394, 'Geoffrey Mercado', 'randallwhitaker@example.com', '708-343-8365', '1953-12-22', 5, 'Pending', '2025-07-04 13:05:42');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (394, 'ACC000394', 394, 'Savings', '2023-03-15', 7534.61, 5, 'Processed', '2025-07-03 06:08');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (394, 394, '857 Meyer Junctions Suite 991', NULL, 'Lake Patrickton', 'WI', '32216', 'USA', 'Work', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (394, 394, '2025-06-08', 1520.15, 920.03, 5, 'Pending', '2025-07-04 06:54:26');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (395, 'John Stout', 'lmoody@example.net', '001-265-595-5865x5883', '2003-09-12', 2, 'Failed', '2025-07-03 00:22:25');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (395, 'ACC000395', 395, 'Loan', '2025-05-15', 7117.36, 2, 'Failed', '2025-07-01 02:40');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (395, 395, '3852 Margaret Port Suite 148', NULL, 'New Jamie', 'MT', '68582', 'USA', 'Shipping', 2); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (395, 395, '2025-06-30', 788.34, 3300.82, 2, 'Processed', '2025-06-29 22:43:46');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (396, 'Dawn Greene', 'dawncastillo@example.com', '204-603-7498', '1998-12-30', 2, 'Pending', '2025-06-29 23:50:46');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (396, 'ACC000396', 396, 'Loan', '2022-10-07', 6900.32, 2, 'Pending', '2025-07-01 01:41');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (396, 396, '3897 Nicholas Cliff Apt. 180', NULL, 'Kelseybury', 'PW', '50914', 'USA', 'Work', 2); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (396, 396, '2025-06-23', 223.22, 2032.73, 2, 'Excluded', '2025-06-29 14:26:57');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (397, 'Kathy Gill', 'steven34@example.org', '(855)955-8650x2148', '1988-07-18', 5, 'Excluded', '2025-07-02 01:56:21');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (397, 'ACC000397', 397, 'Savings', '2023-01-11', 1368.96, 5, 'Excluded', '2025-06-29 20:59');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (397, 397, '135 Thomas Trail', NULL, 'Martinezburgh', 'DC', '55945', 'USA', 'Work', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (397, 397, '2025-06-19', -450.82, 2081.69, 5, 'Pending', '2025-07-03 10:46:19');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (398, 'Jennifer Shaw', 'laurie46@example.com', '651-456-9071x74761', '1991-09-02', 3, 'Pending', '2025-07-04 00:21:32');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (398, 'ACC000398', 398, 'Checking', '2023-02-19', 6313.81, 3, 'Failed', '2025-07-01 06:40');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (398, 398, '5075 Johnson Land', NULL, 'North Dawn', 'NJ', '54887', 'USA', 'Billing', 3); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (398, 398, '2025-06-16', 969.64, 4186.75, 3, 'Processed', '2025-07-01 03:15:12');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (399, 'Matthew Vazquez', 'john00@example.org', '493.728.0408', '1964-01-13', 4, 'Pending', '2025-06-30 21:27:59');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (399, 'ACC000399', 399, 'Checking', '2024-03-27', 3248.2, 4, 'Excluded', '2025-07-03 22:42');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (399, 399, '4424 Jodi Lock', NULL, 'South Austinchester', 'UT', '80355', 'USA', 'Shipping', 4); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (399, 399, '2025-06-10', -783.82, 3044.27, 4, 'Failed', '2025-07-01 11:13:47');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (400, 'Luis Gould', 'zacharyharris@example.org', '671-526-6801x809', '1980-05-13', 1, 'Excluded', '2025-07-02 08:26:02');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (400, 'ACC000400', 400, 'Loan', '2023-11-14', 3193.24, 1, 'Processed', '2025-07-03 23:42');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (400, 400, '0303 Kimberly Mission', NULL, 'Powellland', 'MH', '17702', 'USA', 'Home', 1); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (400, 400, '2025-06-25', 852.37, 1432.41, 1, 'Pending', '2025-07-01 18:51:44');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (401, 'Christine Salinas', 'roberta13@example.com', '+1-838-411-3793', '1955-01-21', 2, 'Failed', '2025-06-30 01:10:25');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (401, 'ACC000401', 401, 'Checking', '2025-03-06', 9837.01, 2, 'Failed', '2025-07-03 20:18');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (401, 401, '828 Cooper Haven', NULL, 'Annborough', 'AK', '88137', 'USA', 'Work', 2); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (401, 401, '2025-06-06', 259.88, 485.94, 2, 'Processed', '2025-07-01 16:30:17');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (402, 'Juan Miller', 'ubrown@example.com', '001-484-414-4822', '1977-02-04', 1, 'Failed', '2025-06-30 04:04:02');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (402, 'ACC000402', 402, 'Checking', '2022-12-07', 2940.48, 1, 'Failed', '2025-07-02 22:30');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (402, 402, '13776 Ashley Viaduct Apt. 140', NULL, 'Alyssastad', 'OH', '50808', 'USA', 'Work', 1); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (402, 402, '2025-06-24', 256.34, 2610.05, 1, 'Pending', '2025-07-03 03:38:00');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (403, 'John Luna', 'hilljoseph@example.org', '(301)574-3382', '1980-05-10', 1, 'Processed', '2025-07-03 17:03:50');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (403, 'ACC000403', 403, 'Checking', '2023-10-03', 4684.64, 1, 'Failed', '2025-07-02 11:24');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (403, 403, '534 Smith Lock', NULL, 'West Eric', 'VT', '06186', 'USA', 'Shipping', 1); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (403, 403, '2025-06-10', -486.93, 2927.25, 1, 'Excluded', '2025-06-29 13:32:29');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (404, 'Julia Rogers', 'maxwelljames@example.org', '(768)521-7620x8108', '1977-10-05', 5, 'Processed', '2025-06-30 05:32:42');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (404, 'ACC000404', 404, 'Checking', '2022-02-26', 7378.12, 5, 'Excluded', '2025-06-30 02:55');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (404, 404, '24097 Leonard Square', NULL, 'Diazborough', 'CT', '09056', 'USA', 'Home', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (404, 404, '2025-07-01', 910.87, 2537.68, 5, 'Processed', '2025-07-01 08:33:38');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (405, 'Sarah Parrish', 'lewischristopher@example.net', '9256537392', '1965-06-25', 2, 'Processed', '2025-07-04 07:35:15');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (405, 'ACC000405', 405, 'Checking', '2024-11-20', 5754.39, 2, 'Processed', '2025-06-29 20:14');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (405, 405, '20373 Cody Walk', NULL, 'West Joshua', 'MP', '91304', 'USA', 'Work', 2); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (405, 405, '2025-06-19', -201.36, 3578.52, 2, 'Excluded', '2025-07-04 04:31:51');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (406, 'Corey Velez', 'boydkathryn@example.org', '706-253-8276', '1982-02-13', 2, 'Excluded', '2025-07-03 11:01:44');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (406, 'ACC000406', 406, 'Loan', '2022-10-25', 9322.91, 2, 'Failed', '2025-06-30 13:37');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (406, 406, '2278 Macias Terrace', NULL, 'Lindseystad', 'LA', '14247', 'USA', 'Shipping', 2); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (406, 406, '2025-06-04', 1611.92, 2297.25, 2, 'Excluded', '2025-06-30 02:31:53');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (407, 'Tracie Brown', 'rodriguezallen@example.com', '333.632.1070x748', '1951-06-11', 5, 'Pending', '2025-06-30 03:05:24');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (407, 'ACC000407', 407, 'Checking', '2021-05-06', 6132.07, 5, 'Processed', '2025-07-01 06:36');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (407, 407, '625 Clark Greens Apt. 555', NULL, 'Jessicaport', 'FM', '95791', 'USA', 'Billing', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (407, 407, '2025-06-10', -877.48, 4571.95, 5, 'Failed', '2025-06-29 23:22:31');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (408, 'Jennifer Hampton MD', 'rodriguezmichael@example.com', '(936)356-9915x163', '1959-08-28', 2, 'Excluded', '2025-07-01 15:49:44');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (408, 'ACC000408', 408, 'Savings', '2022-11-15', 707.03, 2, 'Processed', '2025-07-02 11:44');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (408, 408, '30377 Adam Parkway', NULL, 'Thomasburgh', 'DE', '72352', 'USA', 'Work', 2); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (408, 408, '2025-06-25', 1022.69, 1052.25, 2, 'Excluded', '2025-07-01 15:07:32');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (409, 'Ronald Torres', 'johnsstephen@example.com', '+1-989-359-1303x059', '1999-02-17', 1, 'Processed', '2025-07-03 04:36:24');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (409, 'ACC000409', 409, 'Loan', '2024-03-03', 1103.59, 1, 'Excluded', '2025-07-02 00:15');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (409, 409, '121 Flores Squares', NULL, 'Beltranfurt', 'CO', '79843', 'USA', 'Work', 1); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (409, 409, '2025-07-01', 1910.67, 3132.91, 1, 'Failed', '2025-06-30 07:56:16');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (410, 'Ann Adams', 'nelsonevan@example.com', '781-473-1074', '1972-08-24', 5, 'Excluded', '2025-07-02 15:21:51');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (410, 'ACC000410', 410, 'Savings', '2022-11-21', 6119.26, 5, 'Processed', '2025-07-02 03:47');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (410, 410, '20878 Amanda Canyon', NULL, 'Newmanmouth', 'FM', '28558', 'USA', 'Billing', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (410, 410, '2025-06-18', -501.83, 3570.22, 5, 'Pending', '2025-06-30 17:09:31');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (411, 'Christian Gillespie', 'zgonzalez@example.com', '001-688-967-8151x93978', '1955-12-29', 4, 'Processed', '2025-07-04 10:47:43');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (411, 'ACC000411', 411, 'Checking', '2023-10-09', 9191.59, 4, 'Excluded', '2025-07-03 01:40');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (411, 411, '280 Garza Forks Suite 743', NULL, 'East Erikfurt', 'OH', '61590', 'USA', 'Work', 4); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (411, 411, '2025-06-14', -80.81, 315.11, 4, 'Pending', '2025-07-03 05:20:55');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (412, 'Michelle Fuentes', 'omann@example.net', '001-448-242-7167x799', '1968-09-07', 3, 'Processed', '2025-07-01 22:35:18');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (412, 'ACC000412', 412, 'Savings', '2022-04-15', 210.51, 3, 'Processed', '2025-07-04 04:29');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (412, 412, '5408 Murphy Mountains', NULL, 'Coryfort', 'VA', '98680', 'USA', 'Home', 3); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (412, 412, '2025-06-24', -806.72, 646.59, 3, 'Failed', '2025-07-01 13:31:25');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (413, 'Kimberly Perry', 'jessica61@example.com', '303.615.3431', '1991-08-14', 5, 'Pending', '2025-06-30 02:04:19');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (413, 'ACC000413', 413, 'Loan', '2021-07-02', 679.01, 5, 'Excluded', '2025-06-30 03:15');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (413, 413, '41802 Duran Lights', NULL, 'Lake Kristin', 'TX', '43378', 'USA', 'Shipping', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (413, 413, '2025-06-25', 1162.96, 2018.98, 5, 'Processed', '2025-07-04 09:23:02');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (414, 'William Mcdaniel', 'christopher07@example.com', '+1-347-905-6433x0047', '1951-04-28', 3, 'Excluded', '2025-07-03 15:23:58');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (414, 'ACC000414', 414, 'Loan', '2021-03-17', 1213.39, 3, 'Excluded', '2025-07-01 13:43');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (414, 414, '220 Sanders Garden', NULL, 'North Marc', 'MO', '66767', 'USA', 'Home', 3); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (414, 414, '2025-06-04', 345.43, 3657.4, 3, 'Pending', '2025-07-01 08:05:22');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (415, 'Erika Black', 'sean25@example.com', '233-763-4529x52280', '1959-05-24', 3, 'Processed', '2025-06-30 20:24:11');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (415, 'ACC000415', 415, 'Savings', '2020-10-08', 7997.66, 3, 'Excluded', '2025-07-01 12:58');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (415, 415, '750 Emily Drives Apt. 289', NULL, 'Port Jenniferport', 'NC', '43272', 'USA', 'Work', 3); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (415, 415, '2025-06-04', 1050.11, 573.63, 3, 'Processed', '2025-07-03 01:03:52');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (416, 'Christine Wilson', 'epoole@example.org', '571-885-4163', '1968-02-20', 2, 'Pending', '2025-06-30 13:08:36');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (416, 'ACC000416', 416, 'Checking', '2022-05-16', 9926.3, 2, 'Processed', '2025-07-03 17:09');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (416, 416, '451 Gonzalez Passage Apt. 996', NULL, 'East Mary', 'VA', '73453', 'USA', 'Shipping', 2); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (416, 416, '2025-06-28', 524.21, 3685.37, 2, 'Processed', '2025-07-04 04:10:49');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (417, 'Karl Sullivan', 'staceysanchez@example.org', '+1-993-515-2315x27783', '1967-04-02', 3, 'Failed', '2025-07-01 11:32:18');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (417, 'ACC000417', 417, 'Savings', '2021-04-10', 7624.58, 3, 'Excluded', '2025-07-02 00:21');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (417, 417, '5806 Barbara Falls Suite 422', NULL, 'Lynnhaven', 'ID', '09460', 'USA', 'Billing', 3); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (417, 417, '2025-07-02', 253.92, 4138.96, 3, 'Failed', '2025-07-01 14:51:54');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (418, 'Kevin Holloway', 'tjohnson@example.net', '(578)202-2516x573', '1993-05-17', 1, 'Failed', '2025-07-04 01:48:40');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (418, 'ACC000418', 418, 'Checking', '2020-10-19', 2401.79, 1, 'Failed', '2025-07-02 00:22');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (418, 418, '874 Richardson Falls Suite 341', NULL, 'Clarktown', 'MS', '31220', 'USA', 'Home', 1); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (418, 418, '2025-06-18', 865.82, 4184.08, 1, 'Pending', '2025-07-03 19:09:07');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (419, 'Douglas Harris', 'timothycarter@example.net', '762-650-3778x330', '1960-04-29', 5, 'Pending', '2025-07-01 15:03:07');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (419, 'ACC000419', 419, 'Savings', '2022-11-15', 2617.97, 5, 'Failed', '2025-07-04 05:54');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (419, 419, '15634 Daisy Extensions Suite 768', NULL, 'North Elizabeth', 'WV', '15721', 'USA', 'Billing', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (419, 419, '2025-06-19', 1422.83, 659.11, 5, 'Failed', '2025-07-02 01:38:53');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (420, 'Jared Salas', 'virginia56@example.org', '(314)439-6011', '1992-10-02', 4, 'Pending', '2025-07-01 18:19:02');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (420, 'ACC000420', 420, 'Checking', '2023-12-18', 8210.43, 4, 'Excluded', '2025-07-04 05:42');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (420, 420, '133 Kimberly Avenue', NULL, 'East Fernandoland', 'DE', '20190', 'USA', 'Home', 4); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (420, 420, '2025-06-04', 1746.94, 197.24, 4, 'Processed', '2025-07-04 12:33:31');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (421, 'Courtney Warren', 'michelle32@example.net', '+1-874-592-3902', '1983-02-23', 3, 'Failed', '2025-07-03 11:35:25');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (421, 'ACC000421', 421, 'Loan', '2021-07-17', 4082.85, 3, 'Excluded', '2025-06-30 22:49');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (421, 421, '982 Jennings Shoal', NULL, 'West Kristen', 'OR', '50543', 'USA', 'Work', 3); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (421, 421, '2025-06-20', 12.18, 23.11, 3, 'Excluded', '2025-06-30 18:56:52');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (422, 'Bobby Lopez', 'martha49@example.com', '(584)279-8393', '1995-12-13', 5, 'Excluded', '2025-07-01 05:32:43');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (422, 'ACC000422', 422, 'Savings', '2025-05-08', 8752.97, 5, 'Pending', '2025-06-30 19:20');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (422, 422, '7849 William Well Apt. 650', NULL, 'West Jeremiahborough', 'NH', '37538', 'USA', 'Work', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (422, 422, '2025-06-27', 1434.65, 4982.88, 5, 'Excluded', '2025-07-03 17:59:16');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (423, 'Allison Smith', 'craig03@example.com', '677.648.7153x647', '1983-07-23', 1, 'Excluded', '2025-06-30 07:10:58');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (423, 'ACC000423', 423, 'Checking', '2024-01-10', 6051.1, 1, 'Processed', '2025-07-03 13:24');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (423, 423, '511 Tyler View Suite 249', NULL, 'East Daveville', 'TN', '23381', 'USA', 'Billing', 1); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (423, 423, '2025-06-23', -358.8, 4444.99, 1, 'Processed', '2025-07-03 16:53:00');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (424, 'Brian Turner', 'fordmatthew@example.net', '2822699416', '1963-12-27', 3, 'Excluded', '2025-07-02 10:24:50');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (424, 'ACC000424', 424, 'Loan', '2023-04-07', 2568.46, 3, 'Processed', '2025-06-30 00:00');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (424, 424, '6870 Pamela Spring', NULL, 'South Monicaview', 'LA', '20729', 'USA', 'Billing', 3); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (424, 424, '2025-06-04', -806.04, 648.18, 3, 'Processed', '2025-07-02 17:15:17');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (425, 'Alexander Jensen', 'bennettsean@example.net', '384.241.1607x19307', '1949-07-05', 2, 'Excluded', '2025-07-04 01:06:52');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (425, 'ACC000425', 425, 'Savings', '2024-09-08', 8980.61, 2, 'Failed', '2025-07-01 01:04');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (425, 425, '3079 Alison Squares Suite 517', NULL, 'Foxburgh', 'TN', '38833', 'USA', 'Billing', 2); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (425, 425, '2025-06-16', 485.65, 2739.02, 2, 'Failed', '2025-06-30 06:24:25');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (426, 'Brandi Wolfe', 'millerandrea@example.net', '430-573-2772', '1970-01-22', 3, 'Pending', '2025-07-04 09:22:48');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (426, 'ACC000426', 426, 'Loan', '2021-12-24', 5515.76, 3, 'Excluded', '2025-07-01 11:02');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (426, 426, '982 Dawn Trafficway Suite 772', NULL, 'Acevedoburgh', 'MS', '19163', 'USA', 'Home', 3); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (426, 426, '2025-06-26', -466.3, 1355.12, 3, 'Pending', '2025-06-30 20:20:44');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (427, 'Kelly Perez', 'halexander@example.com', '+1-853-202-0152x0085', '2003-12-20', 5, 'Failed', '2025-07-02 03:52:30');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (427, 'ACC000427', 427, 'Savings', '2020-08-06', 9410.97, 5, 'Excluded', '2025-06-29 19:04');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (427, 427, '2448 Anderson Oval', NULL, 'Lake Stacey', 'AL', '85127', 'USA', 'Billing', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (427, 427, '2025-06-27', -45.21, 3664.84, 5, 'Processed', '2025-06-30 10:23:37');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (428, 'Zachary Bell', 'thomas50@example.net', '3239955983', '2004-12-04', 5, 'Failed', '2025-07-01 20:01:17');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (428, 'ACC000428', 428, 'Checking', '2024-04-26', 2524.77, 5, 'Failed', '2025-07-02 22:48');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (428, 428, '2731 Carl Hills', NULL, 'Josephbury', 'VA', '52535', 'USA', 'Home', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (428, 428, '2025-06-21', -659.92, 979.54, 5, 'Pending', '2025-06-29 17:23:47');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (429, 'Travis Turner', 'barbarafischer@example.net', '272-449-9693x11453', '1957-08-21', 4, 'Pending', '2025-07-03 17:31:07');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (429, 'ACC000429', 429, 'Checking', '2021-01-06', 4909.71, 4, 'Excluded', '2025-06-29 19:51');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (429, 429, '7489 Diaz Rue', NULL, 'East Dana', 'DC', '05841', 'USA', 'Billing', 4); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (429, 429, '2025-06-29', -662.41, 712.25, 4, 'Pending', '2025-07-03 19:59:07');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (430, 'Cynthia Walker', 'cherylhess@example.net', '636-503-4906', '2006-09-02', 2, 'Excluded', '2025-07-02 18:29:13');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (430, 'ACC000430', 430, 'Savings', '2022-04-18', 1693.66, 2, 'Excluded', '2025-07-02 20:57');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (430, 430, '42918 Lambert Stravenue Suite 264', NULL, 'Carrilloshire', 'CT', '93222', 'USA', 'Work', 2); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (430, 430, '2025-07-01', 630.29, 1819.73, 2, 'Processed', '2025-07-03 23:49:15');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (431, 'Andrea Mack', 'ashleyperez@example.net', '(636)374-5413x810', '1983-11-27', 2, 'Processed', '2025-07-03 05:12:57');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (431, 'ACC000431', 431, 'Checking', '2024-06-01', 2665.26, 2, 'Excluded', '2025-07-03 00:36');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (431, 431, '7460 Roman Forest', NULL, 'Jeffreyton', 'NC', '66091', 'USA', 'Home', 2); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (431, 431, '2025-06-26', -600.62, 3647.41, 2, 'Processed', '2025-07-02 00:03:39');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (432, 'Shane Rogers', 'colemorgan@example.net', '696-439-8087x797', '1960-07-25', 2, 'Processed', '2025-07-01 15:12:51');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (432, 'ACC000432', 432, 'Loan', '2024-09-28', 682.45, 2, 'Failed', '2025-06-30 00:07');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (432, 432, '444 David Mission', NULL, 'Brownport', 'OR', '10265', 'USA', 'Shipping', 2); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (432, 432, '2025-06-26', 1560.43, 4515.25, 2, 'Pending', '2025-07-03 19:27:23');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (433, 'Heather Bishop', 'hbullock@example.net', '679.446.0590x54976', '2002-11-07', 5, 'Pending', '2025-07-01 10:22:53');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (433, 'ACC000433', 433, 'Checking', '2021-11-24', 2897.45, 5, 'Processed', '2025-07-01 02:38');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (433, 433, '82525 Maxwell Crossroad', NULL, 'Port Andrew', 'PR', '75156', 'USA', 'Billing', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (433, 433, '2025-06-20', 1871.31, 217.27, 5, 'Excluded', '2025-06-30 04:52:37');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (434, 'Angela Harris', 'mathewsryan@example.com', '+1-329-906-7829x15386', '1995-04-20', 1, 'Processed', '2025-07-03 13:39:27');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (434, 'ACC000434', 434, 'Checking', '2020-12-05', 4742.6, 1, 'Failed', '2025-07-03 20:02');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (434, 434, '7444 Patel Motorway Apt. 337', NULL, 'Patriciatown', 'KS', '70965', 'USA', 'Shipping', 1); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (434, 434, '2025-06-13', 608.78, 2926.33, 1, 'Failed', '2025-07-01 08:03:03');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (435, 'James Hall', 'loricurtis@example.org', '459-739-3123x647', '1982-06-10', 4, 'Failed', '2025-06-30 00:47:52');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (435, 'ACC000435', 435, 'Loan', '2023-09-13', 6250.98, 4, 'Excluded', '2025-07-01 11:55');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (435, 435, '53154 Ray Skyway', NULL, 'South Grant', 'AK', '42001', 'USA', 'Billing', 4); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (435, 435, '2025-07-03', 152.6, 4193.81, 4, 'Pending', '2025-07-01 23:42:28');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (436, 'Valerie Adams', 'sarahgreen@example.com', '6549435865', '1970-01-20', 3, 'Excluded', '2025-07-01 07:26:39');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (436, 'ACC000436', 436, 'Savings', '2021-05-02', 7504.53, 3, 'Excluded', '2025-07-04 07:05');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (436, 436, '8462 Carr Way', NULL, 'Lake Matthewton', 'SC', '39437', 'USA', 'Shipping', 3); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (436, 436, '2025-06-29', 1210.04, 846.23, 3, 'Failed', '2025-07-02 19:37:10');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (437, 'Cassidy Hall', 'nicholas87@example.org', '366-299-7907x328', '1965-07-04', 5, 'Failed', '2025-07-01 03:45:00');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (437, 'ACC000437', 437, 'Checking', '2021-12-07', 1982.51, 5, 'Failed', '2025-07-04 02:48');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (437, 437, '936 Baker Mill', NULL, 'North Lisa', 'CA', '85105', 'USA', 'Home', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (437, 437, '2025-06-08', 592.57, 3739.53, 5, 'Excluded', '2025-07-02 07:24:10');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (438, 'Charles Young', 'joseph97@example.org', '+1-410-202-9348x77027', '1957-08-10', 1, 'Processed', '2025-07-01 00:29:01');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (438, 'ACC000438', 438, 'Checking', '2022-09-30', 5831.94, 1, 'Excluded', '2025-07-01 15:05');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (438, 438, '3659 Stout Islands Suite 353', NULL, 'Danielview', 'OH', '50070', 'USA', 'Billing', 1); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (438, 438, '2025-06-14', 326.71, 346.98, 1, 'Processed', '2025-07-01 08:44:47');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (439, 'Laurie Hendrix', 'dgarcia@example.net', '+1-376-502-0816x6059', '1986-07-18', 5, 'Pending', '2025-07-01 07:14:39');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (439, 'ACC000439', 439, 'Savings', '2024-03-10', 9196.73, 5, 'Pending', '2025-07-02 16:07');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (439, 439, '164 Jose Extensions Apt. 278', NULL, 'South Julieview', 'DE', '92457', 'USA', 'Work', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (439, 439, '2025-06-13', -496.74, 1628.93, 5, 'Processed', '2025-06-30 21:31:03');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (440, 'Brandon White', 'kimkaren@example.net', '400.948.1384x36640', '2004-12-05', 1, 'Excluded', '2025-07-02 12:15:59');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (440, 'ACC000440', 440, 'Loan', '2023-06-24', 7704.32, 1, 'Failed', '2025-07-01 02:19');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (440, 440, '88949 Hayes Via', NULL, 'South Ashleyborough', 'CT', '11783', 'USA', 'Work', 1); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (440, 440, '2025-06-08', -963.32, 3696.86, 1, 'Processed', '2025-07-02 19:56:55');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (441, 'Veronica Powell', 'pamela35@example.org', '(989)251-7031', '1964-02-21', 2, 'Excluded', '2025-07-02 04:11:55');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (441, 'ACC000441', 441, 'Loan', '2024-09-15', 9715.99, 2, 'Processed', '2025-07-03 16:58');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (441, 441, '98217 Alicia Trail', NULL, 'South Mario', 'NV', '53984', 'USA', 'Shipping', 2); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (441, 441, '2025-06-26', 1351.13, 2286.75, 2, 'Excluded', '2025-07-02 12:27:44');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (442, 'Kristen Scott', 'michael27@example.net', '954.735.1738x812', '1957-01-07', 4, 'Excluded', '2025-07-02 13:38:44');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (442, 'ACC000442', 442, 'Savings', '2023-01-07', 6449.36, 4, 'Failed', '2025-06-29 18:21');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (442, 442, '1197 Robert Extensions', NULL, 'Erikborough', 'HI', '30448', 'USA', 'Home', 4); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (442, 442, '2025-06-07', 1501.81, 760.67, 4, 'Processed', '2025-07-03 10:31:56');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (443, 'Dale Mitchell', 'gutierrezalicia@example.com', '+1-478-411-0522', '1993-07-16', 2, 'Failed', '2025-07-03 06:19:51');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (443, 'ACC000443', 443, 'Loan', '2024-06-02', 4518.08, 2, 'Processed', '2025-06-30 09:05');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (443, 443, '0532 Stacy Stream', NULL, 'Martinburgh', 'MT', '13540', 'USA', 'Shipping', 2); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (443, 443, '2025-06-30', 198.62, 800.43, 2, 'Failed', '2025-06-30 03:02:29');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (444, 'Ariana Rubio', 'phunter@example.com', '+1-889-903-1022x87807', '1981-11-12', 3, 'Processed', '2025-07-02 16:39:22');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (444, 'ACC000444', 444, 'Checking', '2022-10-11', 6610.93, 3, 'Failed', '2025-07-03 22:22');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (444, 444, '0346 Courtney Haven Suite 815', NULL, 'Coleshire', 'MS', '68662', 'USA', 'Shipping', 3); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (444, 444, '2025-06-10', 1489.74, 4609.38, 3, 'Excluded', '2025-07-03 19:56:34');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (445, 'Jody Gomez DVM', 'jennifermckee@example.net', '+1-543-964-1366x127', '1983-08-01', 1, 'Excluded', '2025-07-03 17:28:15');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (445, 'ACC000445', 445, 'Savings', '2022-03-28', 2158.01, 1, 'Failed', '2025-07-04 02:39');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (445, 445, '63860 Jennifer Dam Suite 448', NULL, 'Fosterton', 'UT', '79927', 'USA', 'Home', 1); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (445, 445, '2025-06-09', -115.02, 1240.23, 1, 'Processed', '2025-07-04 07:32:59');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (446, 'Lance Jones', 'mmoore@example.net', '+1-385-436-5278x4878', '1950-05-10', 5, 'Pending', '2025-07-01 23:27:09');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (446, 'ACC000446', 446, 'Checking', '2023-07-29', 3301.94, 5, 'Failed', '2025-06-29 20:15');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (446, 446, '88015 Walls Mews Apt. 091', NULL, 'Hurstchester', 'NM', '31456', 'USA', 'Shipping', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (446, 446, '2025-06-25', -252.78, 3904.04, 5, 'Excluded', '2025-06-30 00:47:20');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (447, 'John Young', 'dawn14@example.org', '001-577-530-8682x037', '1972-04-16', 3, 'Pending', '2025-07-03 08:44:47');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (447, 'ACC000447', 447, 'Savings', '2024-06-27', 8333.5, 3, 'Failed', '2025-07-02 16:44');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (447, 447, '192 Thomas Lodge', NULL, 'Tylertown', 'NC', '79520', 'USA', 'Home', 3); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (447, 447, '2025-06-19', 916.42, 4178.06, 3, 'Processed', '2025-07-02 17:41:05');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (448, 'Deborah Williams', 'jamesturner@example.net', '691.804.8771', '1954-08-28', 5, 'Failed', '2025-07-04 11:16:44');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (448, 'ACC000448', 448, 'Savings', '2022-12-25', 2650.85, 5, 'Processed', '2025-06-29 16:12');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (448, 448, '67664 Tara Manors Suite 137', NULL, 'Port Heidifurt', 'TN', '83820', 'USA', 'Work', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (448, 448, '2025-06-23', -888.19, 3225.57, 5, 'Excluded', '2025-07-02 07:15:41');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (449, 'Rachel Gilmore', 'nicolejimenez@example.net', '(281)252-8855x9161', '1997-01-04', 1, 'Excluded', '2025-07-02 23:23:56');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (449, 'ACC000449', 449, 'Checking', '2025-05-20', 5146.36, 1, 'Excluded', '2025-07-04 06:18');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (449, 449, '392 Gross Plaza', NULL, 'North Matthew', 'ME', '53051', 'USA', 'Home', 1); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (449, 449, '2025-06-07', 1295.04, 4706.72, 1, 'Processed', '2025-06-29 21:51:37');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (450, 'John Garcia', 'lindsay14@example.org', '(647)514-2312', '2004-04-25', 4, 'Failed', '2025-07-01 12:09:55');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (450, 'ACC000450', 450, 'Loan', '2024-03-01', 4448.75, 4, 'Failed', '2025-07-04 00:29');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (450, 450, '46205 Angela Circles Apt. 310', NULL, 'New Robert', 'WA', '57392', 'USA', 'Work', 4); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (450, 450, '2025-06-30', 1203.98, 2287.36, 4, 'Excluded', '2025-07-01 15:12:05');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (451, 'Christopher Martin', 'mcarr@example.net', '+1-751-548-8814x1131', '1958-01-21', 5, 'Processed', '2025-07-02 18:32:13');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (451, 'ACC000451', 451, 'Savings', '2025-05-20', 4452.69, 5, 'Pending', '2025-07-01 16:15');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (451, 451, '7224 Waller Light Suite 229', NULL, 'West Adrienneville', 'DE', '54836', 'USA', 'Billing', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (451, 451, '2025-06-14', 788.8, 404.56, 5, 'Failed', '2025-07-02 07:40:49');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (452, 'Lisa Wright', 'pcisneros@example.net', '5533575156', '1968-10-13', 5, 'Failed', '2025-06-30 02:30:39');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (452, 'ACC000452', 452, 'Checking', '2021-06-21', 4161.85, 5, 'Processed', '2025-07-04 02:43');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (452, 452, '052 Lindsey Spur Apt. 674', NULL, 'Taylorville', 'NV', '55698', 'USA', 'Work', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (452, 452, '2025-07-03', -300.92, 1739.19, 5, 'Excluded', '2025-07-03 09:48:46');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (453, 'John Reeves', 'flemingbeth@example.org', '+1-286-357-0210x01718', '2004-03-03', 5, 'Pending', '2025-07-04 10:14:20');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (453, 'ACC000453', 453, 'Loan', '2021-04-05', 5603.32, 5, 'Pending', '2025-07-03 00:22');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (453, 453, '018 White Ville Apt. 286', NULL, 'East Victoria', 'OR', '31002', 'USA', 'Home', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (453, 453, '2025-06-22', 994.08, 3530.18, 5, 'Failed', '2025-07-04 10:44:03');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (454, 'Timothy Glover', 'ureese@example.org', '001-263-687-8504x03183', '1950-05-21', 5, 'Pending', '2025-07-01 00:39:28');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (454, 'ACC000454', 454, 'Savings', '2021-04-01', 6977.12, 5, 'Excluded', '2025-06-30 05:20');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (454, 454, '94513 Victoria Fall Apt. 528', NULL, 'Spencerland', 'VA', '32776', 'USA', 'Home', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (454, 454, '2025-06-17', 799.42, 1380.81, 5, 'Failed', '2025-07-04 03:25:47');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (455, 'Beth Schwartz', 'mary13@example.net', '9477954120', '1991-08-27', 4, 'Excluded', '2025-06-29 15:47:23');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (455, 'ACC000455', 455, 'Checking', '2024-03-18', 3346.1, 4, 'Excluded', '2025-07-01 07:07');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (455, 455, '4432 Julie Underpass Apt. 981', NULL, 'Aliciachester', 'NM', '17778', 'USA', 'Shipping', 4); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (455, 455, '2025-07-03', -417.09, 174.58, 4, 'Failed', '2025-07-01 02:08:24');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (456, 'Alyssa Wolf', 'nathancampbell@example.org', '919-227-0189', '2001-10-09', 1, 'Excluded', '2025-07-03 02:08:49');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (456, 'ACC000456', 456, 'Loan', '2022-11-21', 7283.44, 1, 'Excluded', '2025-07-01 19:54');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (456, 456, '01996 Matthew Heights', NULL, 'Fuentesport', 'TN', '54988', 'USA', 'Work', 1); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (456, 456, '2025-06-25', 730.03, 3289.06, 1, 'Excluded', '2025-07-04 06:10:51');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (457, 'Jeffrey Ford', 'pwhite@example.com', '646-471-9499', '1959-10-07', 2, 'Pending', '2025-06-29 15:39:26');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (457, 'ACC000457', 457, 'Loan', '2022-08-27', 4046.09, 2, 'Failed', '2025-07-01 10:37');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (457, 457, '183 Tammy Islands Apt. 934', NULL, 'North Debrahaven', 'VI', '77773', 'USA', 'Work', 2); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (457, 457, '2025-06-22', 1902.37, 3145.34, 2, 'Processed', '2025-07-03 03:18:38');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (458, 'Rhonda Barron', 'melanieleon@example.com', '(769)431-5738', '1975-08-15', 5, 'Pending', '2025-07-03 17:07:14');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (458, 'ACC000458', 458, 'Savings', '2022-06-09', 4406.94, 5, 'Failed', '2025-06-29 22:09');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (458, 458, '305 Brown Terrace', NULL, 'Katherineshire', 'GU', '10450', 'USA', 'Billing', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (458, 458, '2025-06-24', 397.74, 3331.84, 5, 'Failed', '2025-07-03 17:30:37');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (459, 'Lisa Sanchez', 'rowemike@example.org', '(653)669-7980x441', '1997-03-26', 4, 'Processed', '2025-06-30 09:22:11');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (459, 'ACC000459', 459, 'Savings', '2024-02-07', 5433.49, 4, 'Pending', '2025-06-30 23:11');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (459, 459, '601 Willis Inlet Apt. 477', NULL, 'Tommymouth', 'MA', '41769', 'USA', 'Work', 4); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (459, 459, '2025-06-28', 1017.1, 3052.35, 4, 'Pending', '2025-06-30 00:34:07');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (460, 'Daryl Watkins', 'ttorres@example.net', '716-371-3785x5090', '1967-12-06', 2, 'Processed', '2025-07-03 12:25:38');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (460, 'ACC000460', 460, 'Checking', '2022-11-20', 1571.8, 2, 'Excluded', '2025-07-02 10:01');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (460, 460, '9439 Jeffrey Forest', NULL, 'North Candace', 'SD', '16341', 'USA', 'Shipping', 2); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (460, 460, '2025-06-18', -28.51, 1841.2, 2, 'Processed', '2025-06-30 14:27:03');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (461, 'Angela Lucas', 'austinburton@example.net', '671.863.8455x1455', '1958-09-18', 4, 'Pending', '2025-07-01 11:24:05');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (461, 'ACC000461', 461, 'Loan', '2023-12-27', 5877.94, 4, 'Pending', '2025-07-03 12:35');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (461, 461, '578 Jessica Mountain', NULL, 'Port Kayla', 'PR', '27339', 'USA', 'Billing', 4); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (461, 461, '2025-06-30', 129.06, 1423.71, 4, 'Processed', '2025-07-01 23:50:01');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (462, 'Dean Mckee', 'cheryl13@example.org', '+1-757-952-3157', '1989-04-30', 3, 'Processed', '2025-07-04 03:46:35');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (462, 'ACC000462', 462, 'Savings', '2025-05-06', 5242.42, 3, 'Processed', '2025-06-30 04:29');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (462, 462, '1758 Nichols Crossing Apt. 775', NULL, 'New Ericchester', 'SC', '42570', 'USA', 'Billing', 3); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (462, 462, '2025-06-09', 1361.45, 462.29, 3, 'Pending', '2025-07-01 07:19:25');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (463, 'Michael Taylor', 'barbara30@example.org', '001-883-822-1629x7926', '1980-04-25', 5, 'Pending', '2025-07-02 01:22:42');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (463, 'ACC000463', 463, 'Savings', '2021-01-07', 3098.89, 5, 'Pending', '2025-07-01 14:23');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (463, 463, '2627 Harold Heights', NULL, 'Greenmouth', 'AK', '03257', 'USA', 'Billing', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (463, 463, '2025-06-19', 1732.68, 1501.0, 5, 'Pending', '2025-06-30 03:53:02');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (464, 'Kim Brown', 'xmorales@example.org', '967-278-8019x309', '1994-09-09', 2, 'Processed', '2025-07-04 05:17:37');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (464, 'ACC000464', 464, 'Savings', '2023-04-04', 698.88, 2, 'Pending', '2025-07-02 10:14');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (464, 464, '291 Andrea Drives Suite 291', NULL, 'Gonzalezbury', 'IA', '52435', 'USA', 'Shipping', 2); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (464, 464, '2025-06-25', -409.55, 2439.69, 2, 'Failed', '2025-07-02 04:56:51');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (465, 'Richard Garcia', 'anthonybishop@example.net', '(253)695-5107', '1949-09-07', 4, 'Processed', '2025-07-01 06:39:55');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (465, 'ACC000465', 465, 'Loan', '2024-12-27', 9435.28, 4, 'Processed', '2025-07-03 18:22');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (465, 465, '27334 Denise Spurs Suite 757', NULL, 'North Ericside', 'PA', '80908', 'USA', 'Billing', 4); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (465, 465, '2025-06-26', -153.47, 392.17, 4, 'Excluded', '2025-06-30 23:13:07');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (466, 'Julia Horton', 'joseph26@example.org', '+1-652-936-6524x72651', '1979-09-07', 3, 'Pending', '2025-07-02 23:13:20');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (466, 'ACC000466', 466, 'Loan', '2021-12-16', 2973.88, 3, 'Pending', '2025-07-03 06:58');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (466, 466, '2031 Lawrence Village Suite 427', NULL, 'North Richard', 'UT', '88431', 'USA', 'Home', 3); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (466, 466, '2025-07-03', -592.59, 2554.62, 3, 'Processed', '2025-07-02 07:49:17');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (467, 'Tyler Bailey', 'mccoyrobert@example.com', '8573870300', '1969-06-28', 1, 'Failed', '2025-07-03 12:58:02');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (467, 'ACC000467', 467, 'Loan', '2025-04-13', 925.24, 1, 'Excluded', '2025-07-02 00:21');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (467, 467, '4545 Richards Plains Suite 713', NULL, 'Rebeccaview', 'VT', '81144', 'USA', 'Billing', 1); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (467, 467, '2025-06-13', -448.08, 3642.47, 1, 'Pending', '2025-07-04 02:47:45');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (468, 'Christopher Terry', 'javierolson@example.org', '+1-691-217-9994x3701', '2004-06-13', 5, 'Excluded', '2025-06-30 00:46:03');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (468, 'ACC000468', 468, 'Checking', '2021-08-30', 6857.61, 5, 'Processed', '2025-07-03 11:50');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (468, 468, '3038 Wilson Ramp Apt. 829', NULL, 'East Jamiemouth', 'MT', '19455', 'USA', 'Work', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (468, 468, '2025-06-16', 604.4, 3672.56, 5, 'Failed', '2025-07-01 19:52:33');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (469, 'Vincent Whitehead', 'jaimeclayton@example.com', '(781)773-4073x0246', '1959-02-09', 3, 'Pending', '2025-07-04 12:39:15');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (469, 'ACC000469', 469, 'Savings', '2023-08-03', 9555.87, 3, 'Processed', '2025-07-04 01:55');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (469, 469, '703 Wilson Ports Suite 197', NULL, 'North Kyle', 'ID', '04716', 'USA', 'Billing', 3); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (469, 469, '2025-06-05', -988.46, 1666.25, 3, 'Processed', '2025-06-29 22:42:26');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (470, 'Nathan Williams', 'alicia40@example.net', '001-538-954-2921x451', '1958-09-23', 1, 'Processed', '2025-07-04 01:54:59');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (470, 'ACC000470', 470, 'Loan', '2023-11-19', 744.34, 1, 'Pending', '2025-07-01 17:16');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (470, 470, '62226 Samantha Roads', NULL, 'Frederickbury', 'MI', '89134', 'USA', 'Home', 1); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (470, 470, '2025-06-04', 841.8, 2535.7, 1, 'Failed', '2025-07-02 18:23:00');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (471, 'Laura Peters', 'brownkyle@example.org', '670-604-5648', '1981-06-27', 2, 'Failed', '2025-07-01 22:57:30');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (471, 'ACC000471', 471, 'Savings', '2024-01-23', 891.37, 2, 'Pending', '2025-07-04 11:46');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (471, 471, '9306 Luke Port', NULL, 'Port Troy', 'AK', '90446', 'USA', 'Work', 2); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (471, 471, '2025-06-29', -101.16, 2342.88, 2, 'Excluded', '2025-07-03 13:42:19');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (472, 'Lauren Bell', 'joel81@example.org', '923.497.9972x008', '1979-03-15', 5, 'Processed', '2025-06-29 14:17:48');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (472, 'ACC000472', 472, 'Loan', '2025-05-05', 1581.01, 5, 'Excluded', '2025-06-30 06:08');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (472, 472, '99695 Evans Square Apt. 517', NULL, 'East Ashleyfurt', 'NV', '76037', 'USA', 'Work', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (472, 472, '2025-06-11', 263.43, 2846.15, 5, 'Excluded', '2025-06-30 21:47:53');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (473, 'Caroline Butler', 'devin86@example.net', '(747)483-8590', '1962-05-06', 5, 'Processed', '2025-07-03 05:34:34');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (473, 'ACC000473', 473, 'Checking', '2020-08-05', 7381.6, 5, 'Failed', '2025-06-29 23:37');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (473, 473, '6751 Lewis Cove', NULL, 'North Jessica', 'NM', '56230', 'USA', 'Home', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (473, 473, '2025-06-08', -308.44, 2074.59, 5, 'Excluded', '2025-07-01 10:37:32');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (474, 'David Perez', 'joseph05@example.net', '001-793-877-7375x4131', '1973-12-07', 2, 'Failed', '2025-06-30 00:15:03');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (474, 'ACC000474', 474, 'Checking', '2021-12-09', 8171.04, 2, 'Excluded', '2025-06-30 20:03');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (474, 474, '027 James Loaf Apt. 678', NULL, 'Sarahchester', 'NM', '33132', 'USA', 'Shipping', 2); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (474, 474, '2025-06-25', 641.39, 3390.13, 2, 'Excluded', '2025-07-01 17:56:16');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (475, 'Lisa Tucker', 'rodriguezjill@example.org', '+1-863-351-1205x0613', '1990-03-24', 5, 'Pending', '2025-06-30 11:24:21');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (475, 'ACC000475', 475, 'Savings', '2022-09-01', 4526.79, 5, 'Failed', '2025-07-02 21:31');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (475, 475, '755 Walters Springs Apt. 419', NULL, 'North Adrian', 'HI', '62612', 'USA', 'Work', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (475, 475, '2025-06-24', 458.4, 325.87, 5, 'Failed', '2025-07-01 08:57:12');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (476, 'Tanya Johnson', 'cody04@example.org', '001-629-422-7102x09295', '1967-12-03', 5, 'Processed', '2025-07-03 20:22:35');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (476, 'ACC000476', 476, 'Loan', '2024-07-17', 6114.49, 5, 'Excluded', '2025-07-02 22:48');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (476, 476, '714 Ingram Ford Suite 439', NULL, 'Port Kelly', 'PW', '52736', 'USA', 'Home', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (476, 476, '2025-07-01', 818.43, 3332.62, 5, 'Excluded', '2025-06-29 23:14:19');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (477, 'David Roberts', 'kenneth88@example.org', '843-243-8969x23572', '1992-03-06', 2, 'Failed', '2025-07-01 19:23:11');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (477, 'ACC000477', 477, 'Loan', '2022-06-13', 8237.2, 2, 'Pending', '2025-07-02 04:29');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (477, 477, '6511 Lawrence Walk', NULL, 'Patriciaview', 'MA', '31721', 'USA', 'Work', 2); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (477, 477, '2025-06-14', -158.79, 361.03, 2, 'Processed', '2025-07-02 15:18:47');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (478, 'Daniel Martinez', 'cochrananthony@example.org', '+1-351-722-9188x6109', '2003-07-10', 5, 'Pending', '2025-06-30 18:29:02');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (478, 'ACC000478', 478, 'Savings', '2023-04-02', 2637.11, 5, 'Pending', '2025-07-02 06:23');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (478, 478, '1711 Bell Cliff Suite 154', NULL, 'Morganburgh', 'KS', '90360', 'USA', 'Work', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (478, 478, '2025-06-23', 1909.17, 1184.08, 5, 'Excluded', '2025-07-02 09:22:47');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (479, 'Joshua Vazquez', 'churchjames@example.com', '394.720.4640', '1997-04-22', 2, 'Pending', '2025-07-01 11:29:31');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (479, 'ACC000479', 479, 'Checking', '2021-02-04', 6157.25, 2, 'Failed', '2025-07-01 23:12');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (479, 479, '40453 Fields Well Suite 734', NULL, 'Hamiltonborough', 'PA', '34284', 'USA', 'Shipping', 2); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (479, 479, '2025-06-18', 981.49, 1652.49, 2, 'Processed', '2025-07-02 12:16:11');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (480, 'Jose Clark', 'fmiller@example.org', '+1-333-647-4996x161', '1995-07-10', 2, 'Failed', '2025-07-02 21:23:05');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (480, 'ACC000480', 480, 'Loan', '2022-08-31', 479.74, 2, 'Pending', '2025-07-03 13:19');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (480, 480, '823 Ibarra Well Apt. 561', NULL, 'Lake Richard', 'LA', '50929', 'USA', 'Shipping', 2); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (480, 480, '2025-07-03', 973.17, 1552.72, 2, 'Excluded', '2025-07-02 12:18:05');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (481, 'Kristy Johnson', 'whunt@example.org', '+1-672-759-0721x859', '1971-10-07', 1, 'Processed', '2025-07-04 08:12:25');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (481, 'ACC000481', 481, 'Savings', '2024-11-08', 432.62, 1, 'Processed', '2025-06-29 17:25');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (481, 481, '29694 Leah Fords', NULL, 'Lake Johnburgh', 'ND', '42164', 'USA', 'Home', 1); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (481, 481, '2025-07-03', 545.06, 4133.46, 1, 'Excluded', '2025-06-30 18:43:47');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (482, 'Jennifer Monroe', 'brittney12@example.com', '(899)522-1038x6465', '1971-02-15', 3, 'Failed', '2025-07-03 02:15:05');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (482, 'ACC000482', 482, 'Checking', '2024-06-19', 7868.85, 3, 'Failed', '2025-07-01 14:38');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (482, 482, '82987 Adams Fort Suite 697', NULL, 'Woodsport', 'NV', '69156', 'USA', 'Work', 3); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (482, 482, '2025-06-23', 1850.14, 837.54, 3, 'Failed', '2025-07-03 09:55:26');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (483, 'Kayla Smith', 'timothy22@example.net', '382-402-4040x06154', '1955-12-22', 5, 'Processed', '2025-07-01 01:20:49');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (483, 'ACC000483', 483, 'Loan', '2022-05-24', 3083.28, 5, 'Excluded', '2025-07-02 16:16');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (483, 483, '55976 Cook Lights', NULL, 'Randyfurt', 'DC', '65031', 'USA', 'Shipping', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (483, 483, '2025-06-10', -689.49, 2217.62, 5, 'Pending', '2025-07-01 11:36:37');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (484, 'John Greer', 'coopertimothy@example.org', '208-909-2979', '1958-08-24', 1, 'Failed', '2025-07-03 15:24:13');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (484, 'ACC000484', 484, 'Loan', '2023-12-19', 1584.12, 1, 'Pending', '2025-07-04 00:08');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (484, 484, '37451 Christy Alley', NULL, 'South George', 'IL', '31289', 'USA', 'Home', 1); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (484, 484, '2025-06-27', 312.28, 3784.59, 1, 'Failed', '2025-07-02 14:37:42');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (485, 'Dawn Foster', 'nglass@example.com', '3159250498', '1962-07-03', 1, 'Excluded', '2025-07-01 12:59:17');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (485, 'ACC000485', 485, 'Savings', '2020-07-24', 1662.59, 1, 'Processed', '2025-06-30 14:11');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (485, 485, '8282 Howard Highway Suite 634', NULL, 'North Gregory', 'NE', '55970', 'USA', 'Billing', 1); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (485, 485, '2025-07-03', -208.92, 491.18, 1, 'Excluded', '2025-07-03 08:50:04');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (486, 'Sheila Benitez', 'leekristine@example.com', '001-755-213-2728x909', '2007-01-07', 5, 'Processed', '2025-07-01 09:06:21');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (486, 'ACC000486', 486, 'Savings', '2022-07-16', 7693.28, 5, 'Pending', '2025-06-29 20:30');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (486, 486, '7891 Marcus Heights', NULL, 'Diazhaven', 'AR', '91912', 'USA', 'Billing', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (486, 486, '2025-06-12', 1105.53, 790.88, 5, 'Failed', '2025-07-04 11:21:21');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (487, 'James Hall', 'jeffrey94@example.net', '693-687-7670', '2005-04-17', 2, 'Processed', '2025-07-03 10:24:44');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (487, 'ACC000487', 487, 'Checking', '2024-05-30', 2399.78, 2, 'Pending', '2025-07-04 05:24');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (487, 487, '0337 Jones Springs Suite 730', NULL, 'Port Richard', 'WV', '25791', 'USA', 'Shipping', 2); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (487, 487, '2025-06-30', -371.24, 3987.19, 2, 'Excluded', '2025-07-03 16:18:47');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (488, 'Valerie Banks', 'cvalentine@example.net', '(772)240-5420', '2000-03-23', 5, 'Processed', '2025-07-03 09:26:33');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (488, 'ACC000488', 488, 'Loan', '2020-09-01', 3250.76, 5, 'Pending', '2025-06-30 10:12');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (488, 488, '5783 Kara Shores Apt. 333', NULL, 'Jenniferfort', 'WV', '92817', 'USA', 'Shipping', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (488, 488, '2025-06-06', 666.43, 2053.42, 5, 'Excluded', '2025-07-02 07:55:21');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (489, 'Dana Simmons', 'elarsen@example.com', '+1-752-426-4592', '1987-08-04', 5, 'Failed', '2025-07-01 05:34:02');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (489, 'ACC000489', 489, 'Checking', '2024-08-30', 7045.42, 5, 'Pending', '2025-06-30 12:22');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (489, 489, '0320 Nancy Terrace Suite 381', NULL, 'Butlershire', 'CO', '52335', 'USA', 'Home', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (489, 489, '2025-06-13', 485.29, 3850.75, 5, 'Processed', '2025-07-02 11:39:28');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (490, 'Joseph Rodriguez', 'scottandrew@example.com', '001-542-591-1934x480', '1966-02-04', 5, 'Failed', '2025-07-02 20:42:24');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (490, 'ACC000490', 490, 'Checking', '2020-08-12', 1041.63, 5, 'Failed', '2025-07-02 02:32');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (490, 490, '5990 Turner Forges', NULL, 'Garyside', 'FM', '07953', 'USA', 'Billing', 5); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (490, 490, '2025-06-23', -767.57, 3458.93, 5, 'Failed', '2025-07-03 04:55:59');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (491, 'Kimberly Grant', 'carolgarner@example.net', '939.911.5946', '1983-02-04', 1, 'Processed', '2025-07-01 23:50:40');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (491, 'ACC000491', 491, 'Loan', '2022-02-18', 2607.47, 1, 'Processed', '2025-07-04 11:27');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (491, 491, '50245 Kelly Keys Apt. 345', NULL, 'Shannonville', 'ME', '65930', 'USA', 'Billing', 1); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (491, 491, '2025-06-18', 452.7, 1549.25, 1, 'Pending', '2025-07-01 12:08:38');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (492, 'Erica Bolton', 'bettybean@example.net', '5027678581', '1994-04-30', 1, 'Failed', '2025-06-30 08:49:48');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (492, 'ACC000492', 492, 'Checking', '2021-02-02', 4510.89, 1, 'Processed', '2025-07-02 07:52');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (492, 492, '608 Ashley Circles Apt. 776', NULL, 'Sherylstad', 'NY', '51735', 'USA', 'Shipping', 1); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (492, 492, '2025-06-07', 1981.81, 4874.07, 1, 'Failed', '2025-07-04 03:12:53');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (493, 'Michelle Smith', 'john24@example.com', '(798)564-7969x5057', '1973-08-17', 1, 'Failed', '2025-07-01 22:16:17');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (493, 'ACC000493', 493, 'Loan', '2023-09-25', 5357.67, 1, 'Failed', '2025-06-30 22:30');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (493, 493, '3205 Glenn Via', NULL, 'South Dillonburgh', 'DC', '49247', 'USA', 'Shipping', 1); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (493, 493, '2025-06-23', 1510.58, 2535.55, 1, 'Pending', '2025-06-29 23:32:32');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (494, 'Melissa Rollins', 'kimberlycarter@example.org', '(591)658-8128', '1983-05-30', 1, 'Failed', '2025-06-29 15:46:55');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (494, 'ACC000494', 494, 'Savings', '2022-07-27', 9283.71, 1, 'Pending', '2025-07-03 10:45');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (494, 494, '528 Kim Ferry Suite 803', NULL, 'Sandersville', 'NY', '80839', 'USA', 'Billing', 1); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (494, 494, '2025-06-16', -32.52, 4211.91, 1, 'Excluded', '2025-07-01 05:28:54');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (495, 'Brian Anderson', 'mariebrandt@example.com', '001-698-483-6390', '2007-05-14', 1, 'Pending', '2025-07-03 06:41:21');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (495, 'ACC000495', 495, 'Loan', '2021-02-16', 2884.45, 1, 'Excluded', '2025-06-29 18:32');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (495, 495, '6469 Courtney Vista', NULL, 'North Mistyland', 'MT', '50038', 'USA', 'Billing', 1); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (495, 495, '2025-06-25', -32.45, 400.43, 1, 'Failed', '2025-07-03 03:03:37');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (496, 'William Lynn', 'elliottallen@example.org', '001-275-859-1136', '1997-11-07', 3, 'Excluded', '2025-07-02 13:08:24');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (496, 'ACC000496', 496, 'Savings', '2024-04-01', 3629.98, 3, 'Processed', '2025-06-29 19:53');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (496, 496, '689 Evan Heights Apt. 364', NULL, 'Lake Adamborough', 'WI', '29132', 'USA', 'Billing', 3); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (496, 496, '2025-06-24', 1898.12, 3921.86, 3, 'Excluded', '2025-06-30 14:13:38');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (497, 'Christy Day', 'herrerakristopher@example.net', '987.446.0765', '1961-09-17', 3, 'Pending', '2025-07-04 07:02:36');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (497, 'ACC000497', 497, 'Loan', '2024-05-08', 3816.98, 3, 'Processed', '2025-06-29 20:58');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (497, 497, '523 Sanders Union Suite 910', NULL, 'Port Marcusfurt', 'ME', '03495', 'USA', 'Work', 3); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (497, 497, '2025-06-16', -378.54, 3720.44, 3, 'Failed', '2025-06-29 20:48:57');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (498, 'Cole Johnson', 'jessicagonzalez@example.net', '+1-259-851-5088', '1965-11-20', 4, 'Excluded', '2025-07-03 10:25:27');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (498, 'ACC000498', 498, 'Checking', '2021-02-18', 9882.5, 4, 'Failed', '2025-06-29 15:43');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (498, 498, '92292 Allen Junction', NULL, 'Josephville', 'NE', '51204', 'USA', 'Billing', 4); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (498, 498, '2025-06-20', 337.05, 4170.53, 4, 'Excluded', '2025-06-30 03:51:08');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (499, 'Luke Perez', 'samanthajohnson@example.org', '(353)501-8127', '1952-11-18', 1, 'Processed', '2025-06-30 11:26:23');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (499, 'ACC000499', 499, 'Savings', '2021-05-03', 5543.95, 1, 'Failed', '2025-07-02 12:12');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (499, 499, '846 Olivia Lodge Apt. 424', NULL, 'Bakerton', 'ID', '40319', 'USA', 'Shipping', 1); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (499, 499, '2025-06-08', 1012.89, 3744.15, 1, 'Processed', '2025-07-03 08:41:50');

INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (500, 'Martin Dunn', 'mmack@example.net', '(524)642-5552x971', '1965-10-18', 4, 'Failed', '2025-06-30 01:53:11');

INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES (500, 'ACC000500', 500, 'Loan', '2023-09-21', 7965.19, 4, 'Excluded', '2025-07-01 01:38');

INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES (500, 500, '5973 Gutierrez Motorway Suite 069', NULL, 'South Beverly', 'CA', '13120', 'USA', 'Work', 4); 

INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES (500, 500, '2025-06-17', -703.75, 2237.13, 4, 'Excluded', '2025-07-02 19:55:54');