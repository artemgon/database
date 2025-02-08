-- Create the Hospital database
    create database Hospital;
    go

    -- Create the CountryCode table
    create table CountryCode
    (
        CountryCodeID int primary key identity(1,1), -- Primary key with auto-increment
        CountryCode varchar(50) check(CountryCode like '[0-9]%') not null, -- Country code must start with a digit
        CountryName varchar(50) check(CountryName like '[A-Z]%') not null, -- Country name must start with an uppercase letter
    );
    go

    -- Create the Doctors table
    create table Doctors
    (
        DoctorID int primary key identity(1,1), -- Primary key with auto-increment
        DoctorName nvarchar(max) not null check (DoctorName like '[A-Z]%'and DoctorName <> ''), -- Doctor name must start with an uppercase letter and not be empty
        CountryCodeID int foreign key references CountryCode(CountryCodeID), -- Foreign key referencing CountryCode table
        DoctorPhone char(10) not null check (DoctorPhone like '[0-9]%'), -- Doctor phone must be 10 digits
        DoctorPremium money not null check (DoctorPremium > 0) default 0, -- Doctor premium must be greater than 0
        DoctorSalary money not null check (DoctorSalary >= 0), -- Doctor salary must be non-negative
        DoctorSurname nvarchar(max) not null check (DoctorSurname like '[A-Z]%' and DoctorSurname <> ''), -- Doctor surname must start with an uppercase letter and not be empty
    );
    go

    -- Create the Diseases table
    create table Diseases
    (
        DiseaseID int primary key identity(1,1), -- Primary key with auto-increment
        DiseaseName nvarchar(100) not null check (DiseaseName <> '') unique, -- Disease name must be unique and not empty
        DiseaseSeverity int not null check (DiseaseSeverity >= 1) default 1, -- Disease severity must be at least 1
    );
    go

    -- Create the Departments table
    create table Departments
    (
        DepartmentID int primary key identity(1,1), -- Primary key with auto-increment
        DepartmentBuilding int not null check (DepartmentBuilding like '[1-5]%'), -- Department building must be between 1 and 5
        DepartmentFinancing money not null check (DepartmentFinancing >= 0) default 0, -- Department financing must be non-negative
        DepartmentFloor int not null check (DepartmentFloor >= 1), -- Department floor must be at least 1
        DepartmentName nvarchar(100) not null check (DepartmentName <> '') unique, -- Department name must be unique and not empty
    );
    go

    -- Create the Wards table
    create table Wards
    (
        WardID int primary key identity(1,1), -- Primary key with auto-increment
        WardBuilding int not null check (WardBuilding like '[1-5]%'), -- Ward building must be between 1 and 5
        WardFloor int not null check (WardFloor >= 1), -- Ward floor must be at least 1
        WardName nvarchar(20) not null check (WardName <> '') unique, -- Ward name must be unique and not empty
    );
    go

    -- Create the Examinations table
    create table Examinations
    (
        ExaminationID int primary key identity(1,1), -- Primary key with auto-increment
        ExaminationName nvarchar(100) not null check (ExaminationName <> '') unique, -- Examination name must be unique and not empty
        ExaminationDay int not null check (ExaminationDay >= 1 and ExaminationDay <= 7), -- Examination day must be between 1 and 7
        ExaminationStartTime time not null check (ExaminationStartTime >= '08:00:00' and ExaminationStartTime <= '18:00:00'), -- Examination start time must be between 08:00 and 18:00
        ExaminationEndTime time not null check (ExaminationEndTime > ExaminationStartTime and ExaminationEndTime <= '18:00:00'), -- Examination end time must be after start time and before 18:00
    );
    go

    -- Select all records from the Wards table
    select * from Wards;

    -- Select the surnames and phone numbers of doctors
    select DoctorSurname, DoctorPhone from Doctors;

    -- Select distinct ward floors from the Wards table
    select distinct WardFloor from Wards;

    -- Select disease names and severities with aliases
    select DiseaseName as 'Disease Name', DiseaseSeverity as 'Disease Severity' from Diseases;

    -- Select doctor names, ward names, and department names using table aliases
    select d.DoctorName, w.wardName, de.DepartmentName
    from Doctors d
    join Wards w on d.CountryCodeID = w.WardID
    join Departments de on w.WardBuilding = de.DepartmentBuilding;

    -- Select department names in building 5 with financing less than 30000
    select DepartmentName
    from Departments
    where DepartmentFinancing = 5 and DepartmentFinancing < 30000;

    -- Select department names in building 3 with financing between 12000 and 15000
    select DepartmentName
    from Departments
    where DepartmentBuilding = 3 and DepartmentFinancing between 12000 and 15000;

    -- Select ward names in buildings 4 and 5 on the 1st floor
    select WardName
    from Wards
    where WardBuilding in (4, 5) and WardFloor = 1;

    -- Select department names, buildings, and financing in buildings 3 or 6 with financing less than 11000 or more than 25000
    select DepartmentName, DepartmentBuilding, DepartmentFinancing
    from Departments
    where DepartmentBuilding in (3, 6) and (DepartmentFinancing > 11000 or DepartmentFinancing < 25000);

    -- Select doctor surnames with salary plus premium greater than 1500
    select DoctorSurname
    from Doctors
    where DoctorSalary + Doctors.DoctorPremium > 1500;

    -- Select doctor surnames with half salary greater than three times the premium
    select DoctorSurname
    from Doctors
    where DoctorSalary / 2 > DoctorPremium * 3;

    -- Select distinct examination names conducted in the first three days of the week from 12:00 to 15:00
    select distinct ExaminationName
    from Examinations
    where ExaminationDay in (1, 2, 3) and ExaminationStartTime >= '12:00:00' and ExaminationEndTime <= '15:00:00';