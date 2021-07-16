-- drop schema employee;

create database employee;
use employee;

create table maintenance (
Main_ID varchar(5),
Salary numeric(6,1),
Main_Name varchar(30),
Main_Type varchar(20) not null,
Street varchar(10),
City varchar(30),
primary key (Main_ID),
check(Main_Type in ('Cleaner', 'Security', 'Electrician', 'Peon', 'Sample man'))
);

create table HR (
HR_ID varchar(5),
HR_Name varchar(30),
Salary numeric(6,1),
timing time,
primary key (HR_ID)
);

create table Doctor (
Doc_ID varchar(5),
Doc_Name varchar(30),
salary numeric(9,2),
age int not null,
degree_level varchar(10) not null,
years_exp int,
specialization varchar(30),
night_shift_start time,
night_shift_end time,
patients_attended int,
primary key (Doc_ID),
check (years_exp > 5)
);

create table junior_doc (
jun_ID varchar(5),
salary numeric(8,2),
jun_Name varchar(30),
qualifications varchar(30) not null,
years_exp int default 0,
night_shift_start time,
night_shift_end time,
primary key (jun_ID)
);

create table lab_tech (
tech_ID varchar(5),
tech_Name varchar(30),
salary numeric(8,2),
qualifications varchar(30) not null,
lab_type varchar(20) not null,
primary key (tech_ID)
);

create table lab_relation(
tech_ID varchar(5),
doc_ID varchar(5),
jun_ID varchar(5),
foreign key (tech_ID) references lab_tech(tech_ID),
foreign key (jun_ID) references junior_doc(jun_ID),
foreign key (doc_ID) references doctor(doc_ID)
);

create table jun_relation(
jun_ID varchar(5),
doc_ID varchar(5),
foreign key (jun_ID) references junior_doc(jun_ID),
foreign key (doc_ID) references doctor(doc_ID)
);

-- Base data for the maintenance table
insert into maintenance values('M3001', 5000, 'Anita Kumar', 'Cleaner', 'Dadabhai', 'Mumbai');
insert into maintenance values('M3002', 2500, 'Rajeev Gandhi', 'Electrician', 'Colaba', 'Mumbai');
insert into maintenance values('M3003', 1500, 'Mohit Kumar', 'Security', 'Peddar', 'Mumbai');
insert into maintenance values('M3004', 3200, 'Jain Singhla', 'Security', 'Bandra', 'Mumbai');
insert into maintenance values('M3005', 4500, 'Mathur Trivedi', 'Peon', 'Pali Hill', 'Mumbai');
insert into maintenance values('M3006', 1600, 'Abhijoy Mandel', 'Sample Man', 'Hill Road', 'Mumbai');
insert into maintenance values('M3007', 1520, 'Divya Bhaji', 'Cleaner', 'Linking Rd', 'Mumbai');

-- Base data for the HR table
insert into HR values('H2001', 'Shila Ali', 10000, '5:30');
insert into HR values('H2002', 'Ali Trivedi', 12000, '12:30');
insert into HR values('H2003', 'Trivedi Kumar', 11000, '13:30');
insert into HR values('H2004', 'Kumar Prajapati', 13000, '14:30');
insert into HR values('H2005', 'Prajapati Sahil', 14000, '9:00');
insert into HR values('H2006', 'Sahil Verma', 12000, '10:00');
insert into HR values('H2007', 'Verma Shah', 10000, '7:00');
insert into HR values('H2008', 'Shah Rukh Khan', 12000, '1:00');

-- Base data for the Doctor table
insert into doctor values ('D1001', 'Aditi Musunur', 2000000, 45, 'MBBS', 7, 'Pediatrics', '3:00', '6:00', 15);
insert into doctor values ('D1002', 'Barsati Sandipa', 3500000, 23, 'MD', 9, 'Internal Medicine', '19:30', '2:00' , 6);
insert into doctor values ('D1003', 'Dhritiman Salim', 2500000, 50, 'B.Med', 12, 'Radiology', '20:30', '00:00', 10);
insert into doctor values ('D1004', 'Hardeep Suksma', 2300000, 37, 'MBChB', 9, 'Brain Surgery', '18:45', '20:30', 7);
insert into doctor values ('D1005', 'Gopa Trilochana', 5600000, 39, 'MBBS', 6, 'Gynaecologist', '20:00', '1:00', 18);
insert into doctor values ('D1006', 'Alexander Thomas', 4500000, 39, 'B.Med', 8, 'Emergency Doctor', '21:30', '2:00', 20);
insert into doctor values ('D1007', 'Mohammad Hussain', 5600000, 45, 'MD', 9, 'Ophalmologist', '22:30', '4:00', 17);
insert into doctor values ('D1008', 'Alladin Gini', 8900000, 29, 'MBChB', 6, 'Pathologist', '23:30', '5:15', 24);
insert into doctor values ('D1009', 'Vijai Sritharan', 2300000, 35, 'MBBS', 7, 'Psychiatrist', '00:00', '7:45', 12);
insert into doctor values ('D1010', 'Avidosa Vaisaki', 7500000, 40, 'MD', 9, 'Urologist', '1:00', '6:45', 30);

-- Base data for the Junior doctor table
insert into junior_doc values('J1001', 120000, 'Priya Rahul', 'B.Med', 4, '18:30', '20:00');
insert into junior_doc values('J1002', 140000, 'Aditya Amit', 'B.Med', 5, '00:00', '7:45');
insert into junior_doc values('J1003', 200000, 'Mahesh Mohit', 'BMBS', 7, '1:00', '6:45');
insert into junior_doc values('J1004', 360000, 'Ankit Shayam', 'MD', 3, '23:30', '5:15');
insert into junior_doc values('J1005', 150000, 'Raj Arjun', 'DPM', 0, '22:30', '4:00');
insert into junior_doc values('J1006', 140000, 'Ankur Manoj', 'DO', 4, '21:30', '2:00');
insert into junior_doc values('J1007', 420000, 'Vinay Parth', 'B.Med', 5, '20:30', '00:00');
insert into junior_doc values('J1008', 560000, 'Vivek Aaditya', 'MBBCh', 1, '20:00', '1:00');
insert into junior_doc values('J1009', 400000, 'Neeraj Kumar', 'B.Med', 2, '3:00', '6:00');
insert into junior_doc values('J1010', 120000, 'Abhinav Soham', 'B.Med', 3, '18:45', '20:30');

-- Base data for the Lab Techinician Table
insert into lab_tech values('L1001', 'Harini Mathur', 120000, 'BSc. Biology', 'Pathology');
insert into lab_tech values('L1002', 'Denny King', 200000, 'MSc. Chemistry', 'Ctogenetician');
insert into lab_tech values('L1003', 'Sammy Kumar', 150000, 'BSc. Radiology', 'Radiology Tech');
insert into lab_tech values('L1004', 'Ali Trivedi', 420000, 'BSc. Neurology', 'Anesthiast');
insert into lab_tech values('L1005', 'Trish Killu', 120000, 'MSc. Internal Science', 'Neurologist');
insert into lab_tech values('L1006', 'Samu Kishi', 300000, 'BSc. Urology', 'Histotechnician');

-- Junior Doctor to Doctor Relation Table
insert into jun_relation values('J1001', 'D1008');
insert into jun_relation values('J1002', 'D1003');
insert into jun_relation values('J1003', 'D1003');
insert into jun_relation values('J1004', 'D1010');
insert into jun_relation values('J1005', 'D1001');
insert into jun_relation values('J1006', 'D1002');
insert into jun_relation values('J1007', 'D1005');
insert into jun_relation values('J1008', 'D1007');
insert into jun_relation values('J1009', 'D1010');
insert into jun_relation values('J1010', 'D1001');

-- Lab Tech to Doctor and Junior Doctor Relation
insert into lab_relation values('L1001', 'D1008', 'J1001');
insert into lab_relation values('L1002', 'D1003', 'J1003');
insert into lab_relation values('L1003', 'D1002', 'J1002');
insert into lab_relation values('L1004', 'D1004', 'J1004');
insert into lab_relation values('L1005', 'D1008', 'J1006');
insert into lab_relation values('L1006', 'D1008', 'J1006');

-- SELECT * FROM employees.maintenance;
-- SELECT * FROM employees.lab_tech;
-- SELECT * FROM employees.junior_doc;
-- SELECT * FROM employees.doctor;
-- SELECT * FROM employees.hr;
-- SELECT * FROM employees.jun_relation;
-- SELECT * FROM employees.lab_relation;