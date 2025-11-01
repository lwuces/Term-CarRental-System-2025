USE CarRentalDB;
GO

INSERT INTO Branch (Name) VALUES 
('Bangkhen'), 
('Siam'), 
('Phuket');
GO

INSERT INTO CarType (TypeName) VALUES 
('Sedan 4 Doors'), 
('SUV'), 
('Hatchback 5 Doors'),
('EV');
GO

INSERT INTO Customer (FirstName, LastName, Email, Tel, Password, IsAdmin) VALUES
('Somsak', 'Jaidee', 'somsak.j@email.com', '081-123-4567', '1234', 0),
('Somsri', 'Meedee', 'somsri.m@email.com', '089-876-5432', '5678', 0),
('Admin', 'User', 'admin@gmail.com', '000-000-0000', '1234', 1);
GO

INSERT INTO Car (LicensePlate, Model, TypeID, BranchID, Status, Gear, EngineCC, DailyRate) 
VALUES
('1AB-1111', 'Toyota Yaris', 3, 1, 'Available', 'Auto', 1200, 750.00),
('1AB-2222', 'Honda City', 1, 1, 'Available', 'Auto', 1500, 900.00),
('1AB-3333', 'Honda CR-V', 2, 1, 'Available', 'Auto', 1500, 1400.00),
('2CD-4444', 'Toyota Corolla Cross', 2, 2, 'Available', 'Auto', 1800, 1500.00),
('2CD-5555', 'Mazda 2', 3, 2, 'Available', 'Manual', 1500, 750.00),
('2CD-6666', 'Tesla Model 3', 4, 2, 'Rented', 'Auto', 0, 1800.00),
('3EF-7777', 'Toyota Fortuner', 2, 3, 'Available', 'Auto', 2400, 1700.00),
('3EF-8888', 'MG ZS EV', 4, 3, 'Available', 'Auto', 0, 1600.00);
GO

INSERT INTO Rental (CustomerID, CarID, StartDate, ExpectedReturnDate, ActualReturnDate, RentalBranchID, TotalFee)
VALUES 
(1, 1, '2025-10-01', '2025-10-03', '2025-10-03', 1, 1500.00);
GO

INSERT INTO Rental (CustomerID, CarID, StartDate, ExpectedReturnDate, RentalBranchID, TotalFee)
VALUES 
(2, 6, '2025-10-29', '2025-11-05', 2, 12600.00);
GO