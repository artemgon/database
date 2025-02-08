create database Hospital;
go
create table CountryCode
(
    CountryCodeID int primary key identity(1,1),
    CountryCode varchar(50) check(CountryCode like '[0-9]%') not null,
    CountryName varchar(50) check(CountryName like '[A-Z]%') not null,
);
go
create table Doctors
(
    DoctorID int primary key identity(1,1),
    DoctorName nvarchar(max) not null check (DoctorName like '[A-Z]%'and DoctorName <> ''),
    CountryCodeID int foreign key references CountryCode(CountryCodeID),
    DoctorPhone char(10) not null check (DoctorPhone like '[0-9]%'),
    DoctorPremium money not null check (DoctorPremium > 0) default 0,
    DoctorSalary money not null check (DoctorSalary >= 0),
    DoctorSurname nvarchar(max) not null check (DoctorSurname like '[A-Z]%' and DoctorSurname <> ''),
);
go
create table Diseases
(
    DiseaseID int primary key identity(1,1),
    DiseaseName nvarchar(100) not null check (DiseaseName <> '') unique,
    DiseaseSeverity int not null check (DiseaseSeverity >= 1) default 1,
);
go
create table Departments
(
    DepartmentID int primary key identity(1,1),
    DepartmentBuilding int not null check (DepartmentBuilding like '[1-5]%'),
    DepartmentFinancing money not null check (DepartmentFinancing >= 0) default 0,
    DepartmentFloor int not null check (DepartmentFloor >= 1),
    DepartmentName nvarchar(100) not null check (DepartmentName <> '') unique,
);
go
create table Wards
(
    WardID int primary key identity(1,1),
    WardBuilding int not null check (WardBuilding like '[1-5]%'),
    WardFloor int not null check (WardFloor >= 1),
    WardName nvarchar(20) not null check (WardName <> '') unique,
);
go
create table Examinations
(
    ExaminationID int primary key identity(1,1),
    ExaminationName nvarchar(100) not null check (ExaminationName <> '') unique,
    ExaminationDay int not null check (ExaminationDay >= 1 and ExaminationDay <= 7),
    ExaminationStartTime time not null check (ExaminationStartTime >= '08:00:00' and ExaminationStartTime <= '18:00:00'),
    ExaminationEndTime time not null check (ExaminationEndTime > ExaminationStartTime and ExaminationEndTime <= '18:00:00'),
);
go
select * from Wards;

select DoctorSurname, DoctorPhone from Doctors;

select distinct WardFloor from Wards;

select DiseaseName as 'Disease Name', DiseaseSeverity as 'Disease Severity' from Diseases;

select d.DoctorName, w.wardName, de.DepartmentName
from Doctors d
join Wards w on d.CountryCodeID = w.WardID
join Departments de on w.WardBuilding = de.DepartmentBuilding;

select DepartmentName
from Departments
where DepartmentFinancing = 5 and DepartmentFinancing < 30000;

select DepartmentName
from Departments
where DepartmentBuilding = 3 and DepartmentFinancing between 12000 and 15000;

select WardName
from Wards
where WardBuilding in (4, 5) and WardFloor = 1;

select DepartmentName, DepartmentBuilding, DepartmentFinancing
from Departments
where DepartmentBuilding in (3, 6) and (DepartmentFinancing > 11000 or DepartmentFinancing < 25000);

select DoctorSurname
from Doctors
where DoctorSalary + Doctors.DoctorPremium > 1500;

select DoctorSurname
from Doctors
where DoctorSalary / 2 > DoctorPremium * 3;

select distinct ExaminationName
from Examinations
where ExaminationDay in (1, 2, 3) and ExaminationStartTime >= '12:00:00' and ExaminationEndTime <= '15:00:00';