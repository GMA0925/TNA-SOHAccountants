-- SQL Script to Check and Fix Employees Table Schema
-- Run this to see current structure and add missing columns

-- Step 1: Check current Employees table structure
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Employees'
ORDER BY ORDINAL_POSITION;

-- Step 2: Add missing columns if they don't exist

-- Check and add Phone column
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Employees' AND COLUMN_NAME = 'Phone')
BEGIN
    ALTER TABLE Employees ADD Phone VARCHAR(20) NULL;
    PRINT 'Added Phone column';
END;

-- Check and add Email column
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Employees' AND COLUMN_NAME = 'Email')
BEGIN
    ALTER TABLE Employees ADD Email VARCHAR(255) NULL;
    PRINT 'Added Email column';
END;

-- Check and add DateOfBirth column
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Employees' AND COLUMN_NAME = 'DateOfBirth')
BEGIN
    ALTER TABLE Employees ADD DateOfBirth DATETIME NULL;
    PRINT 'Added DateOfBirth column';
END;

-- Check and add Gender column
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Employees' AND COLUMN_NAME = 'Gender')
BEGIN
    ALTER TABLE Employees ADD Gender VARCHAR(1) NULL;
    PRINT 'Added Gender column';
END;

-- Check and add Address column
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Employees' AND COLUMN_NAME = 'Address')
BEGIN
    ALTER TABLE Employees ADD Address VARCHAR(255) NULL;
    PRINT 'Added Address column';
END;

-- Check and add City column
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Employees' AND COLUMN_NAME = 'City')
BEGIN
    ALTER TABLE Employees ADD City VARCHAR(50) NULL;
    PRINT 'Added City column';
END;

-- Check and add State column
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Employees' AND COLUMN_NAME = 'State')
BEGIN
    ALTER TABLE Employees ADD State VARCHAR(50) NULL;
    PRINT 'Added State column';
END;

-- Check and add PostalCode column
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Employees' AND COLUMN_NAME = 'PostalCode')
BEGIN
    ALTER TABLE Employees ADD PostalCode VARCHAR(20) NULL;
    PRINT 'Added PostalCode column';
END;

-- Check and add EmergencyContactName column
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Employees' AND COLUMN_NAME = 'EmergencyContactName')
BEGIN
    ALTER TABLE Employees ADD EmergencyContactName VARCHAR(200) NULL;
    PRINT 'Added EmergencyContactName column';
END;

-- Check and add EmergencyContactPhone column
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Employees' AND COLUMN_NAME = 'EmergencyContactPhone')
BEGIN
    ALTER TABLE Employees ADD EmergencyContactPhone VARCHAR(20) NULL;
    PRINT 'Added EmergencyContactPhone column';
END;

-- Check and add DateOfJoin column
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Employees' AND COLUMN_NAME = 'DateOfJoin')
BEGIN
    ALTER TABLE Employees ADD DateOfJoin DATETIME NULL;
    PRINT 'Added DateOfJoin column';
END;

-- Check and add Position column
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Employees' AND COLUMN_NAME = 'Position')
BEGIN
    ALTER TABLE Employees ADD Position VARCHAR(100) NULL;
    PRINT 'Added Position column';
END;

-- Check and add Status column
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Employees' AND COLUMN_NAME = 'Status')
BEGIN
    ALTER TABLE Employees ADD Status VARCHAR(50) NULL;
    PRINT 'Added Status column';
END;

-- Check and add ManagerID column
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Employees' AND COLUMN_NAME = 'ManagerID')
BEGIN
    ALTER TABLE Employees ADD ManagerID VARCHAR(50) NULL;
    PRINT 'Added ManagerID column';
END;

-- Check and add ModifiedDate column (for audit trail)
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Employees' AND COLUMN_NAME = 'ModifiedDate')
BEGIN
    ALTER TABLE Employees ADD ModifiedDate DATETIME NULL DEFAULT GETDATE();
    PRINT 'Added ModifiedDate column';
END;

-- Step 3: Verify final structure
PRINT '';
PRINT 'Final Employees table structure:';
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Employees'
ORDER BY ORDINAL_POSITION;

