/*
================================================================================
 SQL Scripts (DML) 200+ Records (V2 - Expanded Car Types)
================================================================================
 รันสคริปต์นี้ "หลังจาก" รันไฟล์ DDL (CREATE TABLE) แล้ว
 (สคริปต์นี้ใช้ T-SQL dialect สำหรับ Microsoft SQL Server)
================================================================================
*/

USE CarRentalDB;
GO

--------------------------------------------------------------------------------
-- 1. ตาราง Look-up (ข้อมูลพื้นฐาน)
--------------------------------------------------------------------------------

-- เพิ่มสาขา (Branches)
-- (5 สาขา เพื่อให้ข้อมูลรถกระจายตัว)
INSERT INTO Branch (Name) VALUES 
('Bangkhen'), 
('Siam'), 
('Phuket'),
('Don Mueang'),
('Suvarnabhumi');
GO

-- (ปรับปรุง) เพิ่มประเภทรถ (Car Types) - 8 ประเภท
INSERT INTO CarType (TypeName) VALUES 
('Eco Car'),             -- 1. (เช่น Yaris, Almera)
('Sedan'),               -- 2. (เช่น Civic, Altis)
('Hatchback'),           -- 3. (เช่น Mazda 2, Yaris 5dr)
('SUV'),                 -- 4. (เช่น CR-V, Fortuner)
('EV'),                  -- 5. (เช่น Tesla, MG)
('Luxury'),              -- 6. (เช่น Benz, BMW)
('Van'),                 -- 7. (เช่น Alphard, H1)
('Pickup Truck');        -- 8. (เช่น Revo, D-Max)
GO


--------------------------------------------------------------------------------
-- 2. ตาราง Customer (201+ รายการ)
--------------------------------------------------------------------------------

-- (สำคัญ) เพิ่ม Admin เป็นคนแรก (จะได้รับ CustomerID = 1)
INSERT INTO Customer (FirstName, LastName, Email, Tel, Password, IsAdmin) VALUES
('Admin', 'User', 'admin@gmail.com', '000-000-0000', '1234', 1);
GO

-- (ใช้ Loop) เพิ่มลูกค้ทั่วไป 200 คน (จะได้รับ ID 2 ถึง 201)
DECLARE @i INT = 1;
WHILE @i <= 200
BEGIN
    INSERT INTO Customer (FirstName, LastName, Email, Tel, Password, IsAdmin)
    VALUES
    (
        'User',                                -- FirstName
        CAST(@i AS VARCHAR(10)),               -- LastName (เช่น '1', '2')
        'user' + CAST(@i AS VARCHAR(10)) + '@email.com', -- Email (Unique)
        '0800000' + FORMAT(@i, '000'),         -- Tel (Unique)
        '1234',                                -- Password
        0                                      -- IsAdmin = 0 (ลูกค้าทั่วไป)
    );
    SET @i = @i + 1;
END
GO


--------------------------------------------------------------------------------
-- 3. ตาราง Car (200+ รายการ)
--------------------------------------------------------------------------------

-- (ใช้ Loop) เพิ่มรถยนต์ 200 คัน
-- รถทั้งหมดจะถูกตั้งค่าเป็น 'Available' ก่อน
-- แล้วในขั้นตอนที่ 4 เราจะอัปเดต 50 คันให้เป็น 'Rented'
DECLARE @c INT = 1;
WHILE @c <= 200
BEGIN
    -- (ปรับปรุง) วน TypeID (1, 2, ... 8, 1, ...)
    DECLARE @CurrentTypeID INT = (@c % 8) + 1;     
    DECLARE @CurrentBranchID INT = (@c % 5) + 1;   -- วน BranchID (1, ... 5, 1, ...)
    
    DECLARE @ModelName VARCHAR(100);
    DECLARE @Rate DECIMAL(10, 2);
    DECLARE @Engine INT;
    DECLARE @Gear VARCHAR(10) = 'Auto';

    -- (ปรับปรุง) ตั้งค่า Model, Rate, Engine ตาม 8 ประเภทใหม่
    IF @CurrentTypeID = 1 -- Eco Car
        BEGIN SET @ModelName = 'Toyota Yaris'; SET @Rate = 750; SET @Engine = 1200; END
    ELSE IF @CurrentTypeID = 2 -- Sedan
        BEGIN SET @ModelName = 'Honda Civic'; SET @Rate = 1100; SET @Engine = 1500; END
    ELSE IF @CurrentTypeID = 3 -- Hatchback
        BEGIN SET @ModelName = 'Mazda 2'; SET @Rate = 900; SET @Engine = 1500; END
    ELSE IF @CurrentTypeID = 4 -- SUV
        BEGIN SET @ModelName = 'Toyota Fortuner'; SET @Rate = 1700; SET @Engine = 2400; END
    ELSE IF @CurrentTypeID = 5 -- EV
        BEGIN SET @ModelName = 'Tesla Model 3'; SET @Rate = 1800; SET @Engine = 0; END
    ELSE IF @CurrentTypeID = 6 -- Luxury
        BEGIN SET @ModelName = 'Mercedes-Benz C-Class'; SET @Rate = 3000; SET @Engine = 2000; END
    ELSE IF @CurrentTypeID = 7 -- Van
        BEGIN SET @ModelName = 'Toyota Alphard'; SET @Rate = 4000; SET @Engine = 2500; END
    ELSE -- Pickup Truck
        BEGIN SET @ModelName = 'Isuzu D-Max'; SET @Rate = 1000; SET @Engine = 1900; END
    
    -- (ปรับปรุง) สุ่มเกียร์ Manual ให้กับรถ Pickup
    IF @CurrentTypeID = 8 AND @c % 2 = 0
        BEGIN SET @Gear = 'Manual'; END

    INSERT INTO Car (LicensePlate, Model, TypeID, BranchID, Status, Gear, EngineCC, DailyRate)
    VALUES
    (
        'CAR-' + FORMAT(@c, '000'), -- LicensePlate (เช่น 'CAR-001')
        @ModelName,
        @CurrentTypeID,
        @CurrentBranchID,
        'Available',                -- Status (Default)
        @Gear,
        @Engine,
        @Rate
    );
    
    SET @c = @c + 1;
END
GO


--------------------------------------------------------------------------------
-- 4. ตาราง Rental (200+ รายการ)
--------------------------------------------------------------------------------

-- (โลจิกส่วนนี้ยังคงเดิม แต่จะดึง Rate ใหม่ที่หลากหลายขึ้นจากตาราง Car)

-- (ใช้ Loop) ส่วนที่ 1: เพิ่มประวัติการเช่า (ที่คืนแล้ว) 150 รายการ
-- จะใช้รถยนต์ ID 51 ถึง 200 (150 คันนี้จะยังมีสถานะ 'Available')
DECLARE @r_past INT = 1;
WHILE @r_past <= 150
BEGIN
    DECLARE @PastCarID INT = @r_past + 50; -- ใช้ CarID 51 ถึง 200
    DECLARE @PastCustID INT = (@r_past % 200) + 2; -- วน CustomerID 2 ถึง 201 (ข้าม Admin)
    DECLARE @PastBranchID INT = (SELECT BranchID FROM Car WHERE CarID = @PastCarID);
    DECLARE @PastRate DECIMAL(10, 2) = (SELECT DailyRate FROM Car WHERE CarID = @PastCarID); -- (ดึง Rate ใหม่)
    
    -- สร้างวันที่ย้อนหลังไป (เช่น 65 วันที่แล้ว, 64 วันที่แล้ว...)
    DECLARE @PastStartDate DATE = DATEADD(day, -(@r_past + 60), GETDATE()); 
    DECLARE @PastReturnDate DATE = DATEADD(day, 5, @PastStartDate); -- เช่า 5 วัน
    
    INSERT INTO Rental 
        (CustomerID, CarID, StartDate, ExpectedReturnDate, ActualReturnDate, RentalBranchID, TotalFee, LateFee)
    VALUES
    (
        @PastCustID,
        @PastCarID,
        @PastStartDate,
        @PastReturnDate,
        @PastReturnDate, -- คืนแล้ว (วันที่คืนจริง = วันที่คาดว่าจะคืน)
        @PastBranchID,
        @PastRate * 5,   -- TotalFee (จะหลากหลายตาม Rate ใหม่)
        0               -- LateFee = 0
    );
    
    SET @r_past = @r_past + 1;
END
GO


-- (ใช้ Loop) ส่วนที่ 2: เพิ่มรายการเช่าที่ "กำลังเช่าอยู่" (Active) 50 รายการ
-- จะใช้รถยนต์ ID 1 ถึง 50
DECLARE @r_active INT = 1;
WHILE @r_active <= 50
BEGIN
    DECLARE @ActiveCarID INT = @r_active; -- ใช้ CarID 1 ถึง 50
    DECLARE @ActiveCustID INT = (@r_active % 200) + 2; -- วน CustomerID 2 ถึง 201
    DECLARE @ActiveBranchID INT = (SELECT BranchID FROM Car WHERE CarID = @ActiveCarID);
    DECLARE @ActiveRate DECIMAL(10, 2) = (SELECT DailyRate FROM Car WHERE CarID = @ActiveCarID); -- (ดึง Rate ใหม่)
    
    -- สร้างรายการเช่าที่กำลังเกิดขึ้น (เช่น เริ่มเมื่อ 2 วันก่อน, คืนในอีก 3 วันข้างหน้า)
    DECLARE @ActiveStartDate DATE = DATEADD(day, -2, GETDATE()); 
    DECLARE @ActiveReturnDate DATE = DATEADD(day, 3, GETDATE()); -- เช่า 5 วัน
    
    -- 1. เพิ่มรายการเช่า
    INSERT INTO Rental 
        (CustomerID, CarID, StartDate, ExpectedReturnDate, ActualReturnDate, RentalBranchID, TotalFee, LateFee)
    VALUES
    (
        @ActiveCustID,
        @ActiveCarID,
        @ActiveStartDate,
        @ActiveReturnDate,
        NULL,             -- ยังไม่คืน (NULL)
        @ActiveBranchID,
        @ActiveRate * 5,  -- TotalFee (จะหลากหลายตาม Rate ใหม่)
        NULL              -- ยังไม่มีค่าปรับ
    );
    
    -- 2. (สำคัญ) อัปเดตสถานะรถคันนี้เป็น 'Rented'
    UPDATE Car 
    SET Status = 'Rented' 
    WHERE CarID = @ActiveCarID;
    
    SET @r_active = @r_active + 1;
END
GO

PRINT 'DML Script (V2 - Expanded Car Types) executed successfully.';
PRINT 'Total Customers: 201 (1 Admin, 200 Users)';
PRINT 'Total Cars: 200 (150 Available, 50 Rented)';
PRINT 'Total Rentals: 200 (150 Past, 50 Active)';
GO