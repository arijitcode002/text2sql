import random

from faker import Faker
from datetime import datetime

fake=Faker()

batch_ids = [1, 2, 3, 4, 5]
sql_statements = []

#1. Schema (DDL)

ddl_statements = """

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
"""

sql_statements.append(ddl_statements)

# 2. BatchRuns

sql_statements.append("""
--BatchRuns
INSERT INTO BatchRuns (BatchDate, Status, RecordsProcessed, StartedAt, EndedAt, Notes) VALUES
('2025-06-17', 'Completed', 1500, '2025-06-17 01:00:00', '2025-06-17 01:30:00',''),
('2025-06-18', 'Completed', 1625, '2025-06-18 01:00:00', '2025-06-18 01:28:10',''),
('2025-06-19', 'Completed', 1580, '2025-06-19 01:00:00', '2025-06-19 01:32:45',''),
('2025-06-20', 'Completed', 1600, '2025-06-20 01:00:00', '2025-06-20 01:29:30',''),
('2025-06-21', 'Completed', 1550, '2025-06-21 01:00:00', '2025-06-21 01:31:15','');
""")

#3. 500 Customers, Accounts, Addresses, Transactions

for i in range(1, 501):
    cust_name = fake.name().replace("", "")
    email = fake.email()
    phone = fake.phone_number().replace("", "")
    dob = fake.date_of_birth(minimum_age=18, maximum_age=75).strftime('%Y-%m-%d')
    batch_id = random.choice(batch_ids)
    status = random.choice(['Pending', 'Processed', 'Failed', 'Excluded'])
    sync_time = fake.date_time_between(start_date='-5d', end_date='now').strftime('%Y-%m-%d %H:%M:%S')
    sql_statements.append(f"""
INSERT INTO Customers (CustomerId, CustomerName, Email, PhoneNumber, DateOfBirth, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES ({i}, '{cust_name}', '{email}', '{phone}', '{dob}', {batch_id}, '{status}', '{sync_time}');""")

    acc_num = f"ACC{str(i).zfill(6)}"
    acc_type = random.choice(['Savings', 'Checking', 'Loan'])
    open_date = fake.date_between(start_date='-5y', end_date='-30d').strftime('%Y-%m-%d')
    balance = round(random.uniform(100, 10000), 2)
    acc_status = random.choice(['Pending', 'Processed', 'Failed', 'Excluded'])
    acc_sync_time = fake.date_time_between(start_date='-5d', end_date='now').strftime('%Y-%m-%d %H:%S')
    sql_statements.append(f"""
INSERT INTO Accounts (AccountId, AccountNumber, CustomerId, AccountType, OpeningDate, CurrentBalance, BatchId, BatchStatus, ExternalsyncTimestamp) 
VALUES ({i}, '{acc_num}', {i}, '{acc_type}', '{open_date}', {balance}, {batch_id}, '{acc_status}', '{acc_sync_time}');""")

    city = fake.city().replace("'", "''")
    state = fake.state_abbr()
    zip_code = fake.postcode()
    address1 = fake.street_address().replace("'", "''")
    country = "USA"
    addr_type = random.choice(['Home', 'Work', 'Billing', 'Shipping'])
    sql_statements.append(f"""
INSERT INTO CustomerAddresses (AddressId, CustomerId, AddressLine1, Addressline2, City, State, PostalCode, Country, AddressType, BatchId)
VALUES ({i}, {i}, '{address1}', NULL, '{city}', '{state}', '{zip_code}', '{country}', '{addr_type}', {batch_id}); """)

    txn_date = fake.date_between(start_date='-30d', end_date='today').strftime('%Y-%m-%d')
    amount = round(random.uniform(-1000, 2000), 2)
    loan_bal = round(random.uniform(0, 5000), 2)
    txn_status = random.choice(['Pending', 'Processed', 'Failed', 'Excluded'])
    txn_sync_time = fake.date_time_between(start_date='-5d', end_date='now').strftime('%Y-%m-%d %H:%M:%S')
    sql_statements.append(f"""
INSERT INTO Transactions (TransactionId, AccountId, Date, Amount, LoanBalance, BatchId, BatchStatus, ExternalSyncTimestamp) 
VALUES ({i}, {i}, '{txn_date}', {amount}, {loan_bal}, {batch_id}, '{txn_status}', '{txn_sync_time}');""")

#Write to file

with open("full data_dump_with_schema.sql", "w", encoding="utf-8") as f:
    f.write('\n'.join(sql_statements))

print(sql_statements)
print(" File 'full_data_dump_with_schema.sql created successfully.")