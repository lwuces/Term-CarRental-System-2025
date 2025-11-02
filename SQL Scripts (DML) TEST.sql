USE CarRentalDB;
GO

INSERT INTO Branch (Name) VALUES 
('Bangkhen'), 
('Siam'), 
('Phuket'),
('Don Mueang'),
('Suvarnabhumi');
GO

INSERT INTO CarType (TypeName) VALUES 
('Eco Car'),   
('Sedan'),        
('Hatchback'),      
('SUV'),             
('EV'),                 
('Luxury'),              
('Van'),                 
('Pickup Truck');        
GO

INSERT INTO Customer (FirstName, LastName, Email, Tel, Password, IsAdmin) VALUES
('Admin', 'User', 'admin@gmail.com', '000-000-0000', '1234', 1);
GO

DECLARE @i INT = 1;
WHILE @i <= 200
BEGIN
    INSERT INTO Customer (FirstName, LastName, Email, Tel, Password, IsAdmin)
    VALUES
    (
        'User',                                
        CAST(@i AS VARCHAR(10)),               
        'user' + CAST(@i AS VARCHAR(10)) + '@email.com', 
        '0800000' + FORMAT(@i, '000'),      
        '1234',                               
        0                                
    );
    SET @i = @i + 1;
END
GO

DECLARE @c INT = 1;
WHILE @c <= 200
BEGIN

    DECLARE @CurrentTypeID INT = (@c % 8) + 1;     
    DECLARE @CurrentBranchID INT = (@c % 5) + 1; 
    
    DECLARE @ModelName VARCHAR(100);
    DECLARE @Rate DECIMAL(10, 2);
    DECLARE @Engine INT;
    DECLARE @Gear VARCHAR(10) = 'Auto';

    IF @CurrentTypeID = 1 
        BEGIN SET @ModelName = 'Toyota Yaris'; SET @Rate = 750; SET @Engine = 1200; END
    ELSE IF @CurrentTypeID = 2 
        BEGIN SET @ModelName = 'Honda Civic'; SET @Rate = 1100; SET @Engine = 1500; END
    ELSE IF @CurrentTypeID = 3 
        BEGIN SET @ModelName = 'Mazda 2'; SET @Rate = 900; SET @Engine = 1500; END
    ELSE IF @CurrentTypeID = 4 
        BEGIN SET @ModelName = 'Toyota Fortuner'; SET @Rate = 1700; SET @Engine = 2400; END
    ELSE IF @CurrentTypeID = 5 
        BEGIN SET @ModelName = 'Tesla Model 3'; SET @Rate = 1800; SET @Engine = 0; END
    ELSE IF @CurrentTypeID = 6 
        BEGIN SET @ModelName = 'Mercedes-Benz C-Class'; SET @Rate = 3000; SET @Engine = 2000; END
    ELSE IF @CurrentTypeID = 7 
        BEGIN SET @ModelName = 'Toyota Alphard'; SET @Rate = 4000; SET @Engine = 2500; END
    ELSE 
        BEGIN SET @ModelName = 'Isuzu D-Max'; SET @Rate = 1000; SET @Engine = 1900; END

    IF @CurrentTypeID = 8 AND @c % 2 = 0
        BEGIN SET @Gear = 'Manual'; END

    INSERT INTO Car (LicensePlate, Model, TypeID, BranchID, Status, Gear, EngineCC, DailyRate)
    VALUES
    (
        'CAR-' + FORMAT(@c, '000'), 
        @ModelName,
        @CurrentTypeID,
        @CurrentBranchID,
        'Available',               
        @Gear,
        @Engine,
        @Rate
    );
    
    SET @c = @c + 1;
END
GO

DECLARE @r_past INT = 1;
WHILE @r_past <= 150
BEGIN
    DECLARE @PastCarID INT = @r_past + 50;
    DECLARE @PastCustID INT = (@r_past % 200) + 2; 
    DECLARE @PastBranchID INT = (SELECT BranchID FROM Car WHERE CarID = @PastCarID);
    DECLARE @PastRate DECIMAL(10, 2) = (SELECT DailyRate FROM Car WHERE CarID = @PastCarID);
    
    DECLARE @PastStartDate DATE = DATEADD(day, -(@r_past + 60), GETDATE()); 
    DECLARE @PastReturnDate DATE = DATEADD(day, 5, @PastStartDate);
    
    INSERT INTO Rental 
        (CustomerID, CarID, StartDate, ExpectedReturnDate, ActualReturnDate, RentalBranchID, TotalFee, LateFee)
    VALUES
    (
        @PastCustID,
        @PastCarID,
        @PastStartDate,
        @PastReturnDate,
        @PastReturnDate,
        @PastBranchID,
        @PastRate * 5,  
        0           
    );
    
    SET @r_past = @r_past + 1;
END
GO

DECLARE @r_active INT = 1;
WHILE @r_active <= 50
BEGIN
    DECLARE @ActiveCarID INT = @r_active; 
    DECLARE @ActiveCustID INT = (@r_active % 200) + 2; 
    DECLARE @ActiveBranchID INT = (SELECT BranchID FROM Car WHERE CarID = @ActiveCarID);
    DECLARE @ActiveRate DECIMAL(10, 2) = (SELECT DailyRate FROM Car WHERE CarID = @ActiveCarID);

    DECLARE @ActiveStartDate DATE = DATEADD(day, -2, GETDATE()); 
    DECLARE @ActiveReturnDate DATE = DATEADD(day, 3, GETDATE()); 
    
    INSERT INTO Rental 
        (CustomerID, CarID, StartDate, ExpectedReturnDate, ActualReturnDate, RentalBranchID, TotalFee, LateFee)
    VALUES
    (
        @ActiveCustID,
        @ActiveCarID,
        @ActiveStartDate,
        @ActiveReturnDate,
        NULL,             
        @ActiveBranchID,
        @ActiveRate * 5, 
        NULL             
    );
    
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
