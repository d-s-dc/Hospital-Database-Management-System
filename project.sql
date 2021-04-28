
drop schema project;

create database project;
use project;

create table admin_h(
a_id varchar(11) not null primary key,
a_name varchar(30) not null,
phone_no varchar(10) not null,
pass varchar(15) not null,
city varchar(20) not null,
check (length(phone_no) = 10)
);

create table department(
d_id varchar(3) primary key,
d_name varchar(35) unique not null,
no_of_rooms int,
no_of_halls int,
no_of_consultancy_rooms int,
no_of_beds int,
beds_occupied int,
patient_discharge_average int,
patient_admissionrate_average int,
check (d_id like 'd%'),
check (beds_occupied <= no_of_beds)
);

create table patient(
p_id varchar(8) primary key,
admission_status varchar(16),
city varchar(10),
state varchar(10),
p_name varchar(10),
age int,
no_of_tests_conducted int,
ongoing_medication varchar(20),
phone_no varchar(10),
gender varchar(7),
d_id varchar(8),
time_of_admission timestamp default now(),
check (p_id like 'P%'),
check (d_id like 'd%'),
check (admission_status = 'admitted' OR admission_status = 'not admitted'),
check (gender = 'male' or gender = 'female'),
foreign key (d_id) references department(d_id)
);

create table lab(
lab_no varchar(7),
no_of_equipments int,
type_of_test varchar(50) unique,
primary key (lab_no,type_of_test),
check (lab_no like 'l%')
);

create table lab_d(
lab_no varchar(7),
d_id varchar(3),
primary key(lab_no,d_id),
foreign key (lab_no) references lab(lab_no),
foreign key (d_id) references department(d_id)
);

create table test_report(
tr_id varchar(7),
test_type varchar(50),
lab_no varchar(7),
p_id varchar (8),
check (tr_id like 'tr%'),
foreign key (lab_no,test_type) references lab(lab_no,type_of_test),
foreign key (p_id) references patient(p_id),
primary key(tr_id,p_id)
);

create table equipments(
ventilator_in_use int,
beds_in_use int,
oxygen_cylinders_in_use int
);

create table posthumus(
id varchar(10) primary key,
p_id varchar(8),
timingofdeath timestamp default now(),
age int,
cause_of_death varchar(15),
address varchar(90),
guardian_name varchar(15),
check (id like 'ps%'),
foreign key (p_id) references patient(p_id)
);

create table medical_history_1(
p_id varchar(8) primary key,
previous_operations varchar(50),
disability varchar(50),
previous_conditions varchar(50),
foreign key (p_id) references patient(p_id)
);

create table medical_history_2(
p_id varchar(8) primary key,
previous_disease varchar(30),
time_span_of_disease varchar(15),
previous_medication varchar(15),
foreign key (p_id) references patient(p_id)
);

create table maintenance (
Main_ID varchar(5),
Salary numeric(6,1),
Main_Name varchar(30),
Main_Type varchar(20) not null,
Street varchar(10),
City varchar(30),
phone_no varchar(10) not null,
check (length(phone_no) = 10),
primary key (Main_ID),
check(Main_Type in ('Cleaner', 'Security', 'Electrician', 'Peon', 'Sample man'))
);

create table HR (
HR_ID varchar(5),
HR_Name varchar(30),
Salary numeric(6,1),
timing time,
phone_no varchar(10) not null,
pass varchar(10) not null,
check (length(phone_no) = 10),
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
d_id varchar(3),
phone_no varchar(10) not null,
pass varchar(10) not null,
check (length(phone_no) = 10),
foreign key (d_id) references department(d_id),
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
d_id varchar(3),
phone_no varchar(10) not null,
pass varchar(10) not null,
check (length(phone_no) = 10),
foreign key (d_id) references department(d_id),
primary key (jun_ID)
);

create table lab_tech (
tech_ID varchar(5),
tech_Name varchar(30),
salary numeric(8,2),
qualifications varchar(30) not null,
lab_no varchar(7),
phone_no varchar(10) not null,
check (length(phone_no) = 10),
foreign key (lab_no) references lab(lab_no),
primary key (tech_ID)
);

create table jun_relation(
jun_ID varchar(5) not null,
doc_ID varchar(5) not null,
foreign key (jun_ID) references junior_doc(jun_ID),
foreign key (doc_ID) references doctor(doc_ID),
primary key(jun_ID,doc_ID)
);

delimiter $$
create trigger jun_rel_check
after insert
on jun_relation for each row
begin
declare doc_d varchar(3);
declare jdoc_d varchar(3);
select d_id into doc_d from doctor where new.doc_id = doctor.doc_id;
select d_id into jdoc_d from junior_doc where new.jun_id = junior_doc.jun_id;
if jdoc_d <> doc_d then
signal sqlstate '45000' set message_text = "They are not from same department";
end if;
end $$ delimiter ;

create table lab_relation(
tech_ID varchar(5) not null,
doc_ID varchar(5) not null,
jun_ID varchar(5) not null,
foreign key (jun_ID,doc_ID) references jun_relation(jun_ID,doc_ID),
foreign key (tech_ID) references lab_tech(tech_ID)
);

delimiter $$
create trigger lab_rel_check
after insert 
on lab_relation for each row
begin
declare doc_d varchar(3);
drop temporary table if exists lab_dpt;
create temporary table lab_dpt ( l_d varchar(3));
insert into lab_dpt (select d_id from lab_tech,lab_d where new.tech_id = lab_tech.tech_id and lab_tech.lab_no = lab_d.lab_no);
select d_id into doc_d from doctor where new.doc_id = doctor.doc_id;
if doc_d not in (select * from lab_dpt) then
signal sqlstate '45000' set message_text = "The department of doctor/junior doc and lab technician are not same";
end if;
end $$ delimiter ;

-- Base data for admin
insert into admin_h values('a1','Dhruv Singla',9465818638,'dhruv','Bathinda');
insert into admin_h values('a2','Ankur Tambe',9998252337,'ankur','Surat');
insert into admin_h values('a3','Joel John Kurien',9497895742,'joel','Kochi');
insert into admin_h values('a4','Chittibommala Rohith',8374201931,'rohith','Warangal');
insert into admin_h values('a5','Aashwin Raj',7424961792,'aashwin','Jamshedpur');

-- Base data for department
insert into department values ('d1','OPD',1,1,1,10,NULL,NULL,NULL);
insert into department values ('d2','Orthopaedics Department',7,3,2,35,20,7,6);
insert into department values ('d3','Opthalmology Department',2,2,0,10,3,5,4);
insert into department values ('d4','Cardiology Department',7,3,2,20,9,8,7);
insert into department values ('d5','Psychiatry Department',5,5,1,25,15,13,7);
insert into department values ('d6','Neurology Department',7,3,2,20,15,12,10);
insert into department values ('d7','Dermatology Department',16,1,3,30,22,50,40);
insert into department values ('d8','Radiology Department',2,0,0,5,5,20,20);

-- Base data for patient
insert into patient values ('P1','admitted','Bathinda','Punjab','Tipun',34,1,'Surgery required',9465814789,'male','d1','2020-11-25 18:24:50');
insert into patient values ('P2','not admitted','Bathinda','Punjab','Sony',34,5,'Nothing required',9588814789,'male','d2','2020-10-8 17:24:50');
insert into patient values ('P3','admitted','Ludhiana','Punjab','Kiran',28,4,'Treatment required',9588518989,'male','d3','2020-12-18 19:50:50');
insert into patient values ('P4','admitted','Amritsar','Punjab','Kamaljeet',50,1,'Treatment required',9584589789,'female','d4','2020-11-26 10:24:50');
insert into patient values ('P5','not admitted','Moga','Punjab','Sukhwinder',45,3,'Nothing required',9584589000,'male','d5','2020-12-16 17:24:10');
insert into patient values ('P6','not admitted','Patiala','Punjab','Sarabjeet',20,2,'Nothing required',9584587090,'male','d6','2020-12-24 2:4:50');
insert into patient values ('P7','admitted','Batala','Punjab','Jaswinder',48,6,'Surgery required',9875478945,'female','d7','2020-12-2 8:24:5');
insert into patient values ('P8','admitted','Rampura','Punjab','Harnoor',54,1,'Surgery required',9889745445,'male','d6','2020-11-25 18:24:50');
insert into patient values ('P9','admitted','Bhucho','Punjab','Kimal',60,4,'Treatment required',9812345445,'female','d1','2020-12-10 5:4:10');
insert into patient values ('P10','admitted','Ambala','Punjab','Lala',40,5,'Treatment required',9812965124,'male','d3','2020-12-18 13:4:50');
insert into patient values ('P11','not admitted','Barnala','Punjab','Lakki',40,5,'Patient no more',9812547124,'male','d4','2020-12-15 1:20:30');
insert into patient values ('P12','not admitted','Kotakpura','Punjab','Lala',40,5,'Patient no more',9812969924,'male','d6','2020-12-31 20:44:50');

-- Base data for lab
insert into lab values ('l1',5,'X-ray Test');
insert into lab values ('l2',2,'Eye Examination');
insert into lab values ('l3',4,'MRI and CT');
insert into lab values ('l4',1,'Psychometric test');
insert into lab values ('l5',3,'Blood Test');
insert into lab values ('l6',4,'Diascopy');
insert into lab values ('l7',2,'Medical Test');

-- Base data for lab and department relationship
insert into lab_d values ('l1','d1');
insert into lab_d values ('l1','d2');
insert into lab_d values ('l1','d4');
insert into lab_d values ('l1','d6');
insert into lab_d values ('l1','d7');
insert into lab_d values ('l2','d3');
insert into lab_d values ('l3','d2');
insert into lab_d values ('l3','d4');
insert into lab_d values ('l3','d6');
insert into lab_d values ('l3','d8');
insert into lab_d values ('l4','d5');
insert into lab_d values ('l5','d1');
insert into lab_d values ('l6','d7');
insert into lab_d values ('l7','d1');

-- Base data for test report
insert into test_report values ('tr1','Medical Test','l7','P1');
insert into test_report values ('tr2','X-ray Test','l1','P2');
insert into test_report values ('tr3','Eye Examination','l2','P3');
insert into test_report values ('tr4','MRI and CT','l3','P4');
insert into test_report values ('tr5','Psychometric Test','l4','P5');
insert into test_report values ('tr6','MRI and CT','l3','P6');
insert into test_report values ('tr7','Diascopy','l6','P7');
insert into test_report values ('tr8','X-Ray Test','l1','P8');
insert into test_report values ('tr9','Medical Test','l7','P9');
insert into test_report values ('tr10','Eye Examination','l2','P10');

-- Base data for posthumus
insert into posthumus values ('ps1','P11','2021-01-25 18:24:50',71,'Heart Attack','#589, Addy nagar, Barnal','Gurpreet');
insert into posthumus values ('ps2','P12','2020-12-26 19:04:50',65,'Electric shock','#89, Sabna nagar, Kotakpura','Jasmeet');

-- Base data for medical history (part 1)
insert into medical_history_1 values ('P2', 'bone replacement','-','Bone fracture in left knee');
insert into medical_history_1 values ('P4', 'stunt placement','-','Heart patient');
insert into medical_history_1 values ('P5', '-','-','Record of psychiatry problems');
insert into medical_history_1 values ('P6', 'Neurosurgery','-','Hit hard on head');
insert into medical_history_1 values ('P11', 'ECR','-','Heart patient');

-- Base data for medical history (part 2)
insert into medical_history_2 values ('P1','Common cold','2-3 years','Sinarest');
insert into medical_history_2 values ('P9','Bone ache','2-3 years','Supplements');
insert into medical_history_2 values ('P10','Eye dryness','1 year','Lubricant');
insert into medical_history_2 values ('P7','Skin infection','1-1.5 years','Antibiotics');
insert into medical_history_2 values ('P8','OCD','2-3 years','Sessions');

-- Base data for the maintenance table
insert into maintenance values('M3001', 5000, 'Anita Kumar', 'Cleaner', 'Dadabhai', 'Mumbai','9874561230');
insert into maintenance values('M3002', 2500, 'Rajeev Gandhi', 'Electrician', 'Colaba', 'Mumbai','8745846555');
insert into maintenance values('M3003', 1500, 'Mohit Kumar', 'Security', 'Peddar', 'Mumbai','8745796412');
insert into maintenance values('M3004', 3200, 'Jain Singhla', 'Security', 'Bandra', 'Mumbai','8745210298');
insert into maintenance values('M3005', 4500, 'Mathur Trivedi', 'Peon', 'Pali Hill', 'Mumbai','8974563210');
insert into maintenance values('M3006', 1600, 'Abhijoy Mandel', 'Sample Man', 'Hill Road', 'Mumbai','9874563210');
insert into maintenance values('M3007', 1520, 'Divya Bhaji', 'Cleaner', 'Linking Rd', 'Mumbai','9987478540');

-- Base data for the HR table
insert into HR values('H2001', 'Shila Ali', 10000, '5:30','8894562165','shila');
insert into HR values('H2002', 'Ali Trivedi', 12000, '12:30','8874596123','ali');
insert into HR values('H2003', 'Trivedi Kumar', 11000, '13:30','8798457965','trivedi');
insert into HR values('H2004', 'Kumar Prajapati', 13000, '14:30','7748596120','kumar');
insert into HR values('H2005', 'Prajapati Sahil', 14000, '9:00','1245653278','prajapati');
insert into HR values('H2006', 'Sahil Verma', 12000, '10:00','9874586325','sahil');
insert into HR values('H2007', 'Verma Shah', 10000, '7:00','8954567821','verma');
insert into HR values('H2008', 'Shah Rukh Khan', 12000, '1:00','9987895645','shah');

-- Base data for the Doctor table
insert into doctor values ('D1001', 'Aditi Musunur', 2000000, 45, 'MBBS', 7, 'General Physician', '3:00', '6:00', 15,'d1','9785161894','aditi');
insert into doctor values ('D1002', 'Barsati Sandipa', 3500000, 23, 'MD', 9, 'Orthopaedician', '19:30', '2:00' , 6,'d2','8671618954','barsati');
insert into doctor values ('D1003', 'Dhritiman Salim', 2500000, 50, 'B.Med', 12, 'Opthalomoligist', '20:30', '00:00', 10,'d3','8745321698','dhritiman');
insert into doctor values ('D1004', 'Hardeep Suksma', 2300000, 37, 'MBChB', 9, 'Cadiologist', '18:45', '20:30', 7,'d4','8745126956','hardeep');
insert into doctor values ('D1005', 'Gopa Trilochana', 5600000, 39, 'MBBS', 6, 'Psychiatrist', '20:00', '1:00', 18,'d5','6565451225','gopa');
insert into doctor values ('D1006', 'Alexander Thomas', 4500000, 39, 'B.Med', 8, 'Neurologist', '21:30', '2:00', 20,'d6','7856458596','alexander');
insert into doctor values ('D1007', 'Mohammad Hussain', 5600000, 45, 'MD', 9, 'Dermatologist', '22:30', '4:00', 17,'d7','8855461299','mohammad');
insert into doctor values ('D1008', 'Alladin Gini', 8900000, 29, 'MBChB', 6, 'Orthopaedician', '23:30', '5:15', 24,'d2','7744989863','alladin');
insert into doctor values ('D1009', 'Vijai Sritharan', 2300000, 35, 'MBBS', 7, 'Psychiatrist', '00:00', '7:45', 12,'d5','9954785632','vijai');
insert into doctor values ('D1010', 'Avidosa Vaisaki', 7500000, 40, 'MD', 9, 'Cardiologist', '1:00', '6:45', 30,'d4','7746893210','avidosa');

-- Base data for the Junior doctor table
insert into junior_doc values('J1001', 120000, 'Priya Rahul', 'B.Med', 4, '18:30', '20:00','d2','8787465891','priya');
insert into junior_doc values('J1002', 140000, 'Aditya Amit', 'B.Med', 5, '00:00', '7:45','d3','5612452301','aditya');
insert into junior_doc values('J1003', 200000, 'Mahesh Mohit', 'BMBS', 7, '1:00', '6:45','d5','8874596523','mahesh');
insert into junior_doc values('J1004', 360000, 'Ankit Shayam', 'MD', 3, '23:30', '5:15','d4','1245325689','ankit');
insert into junior_doc values('J1005', 150000, 'Raj Arjun', 'DPM', 0, '22:30', '4:00','d4','9445012540','raj');
insert into junior_doc values('J1006', 140000, 'Ankur Manoj', 'DO', 4, '21:30', '2:00','d2','8974586523','ankur');
insert into junior_doc values('J1007', 420000, 'Vinay Parth', 'B.Med', 5, '20:30', '00:00','d5','9874563215','vinay');
insert into junior_doc values('J1008', 560000, 'Vivek Aaditya', 'MBBCh', 1, '20:00', '1:00','d7','7845965632','vivek');
insert into junior_doc values('J1009', 400000, 'Neeraj Kumar', 'B.Med', 2, '3:00', '6:00','d6','9845785684','neeraj');
insert into junior_doc values('J1010', 120000, 'Abhinav Soham', 'B.Med', 3, '18:45', '20:30','d1','8745896512','abhinav');

-- Base data for the Lab Techinician Table
insert into lab_tech values('L1001', 'Harini Mathur', 120000, 'BSc. Medical Lab', 'l1','9874345120');
insert into lab_tech values('L1002', 'Denny King', 200000, 'BSc. Psychiatry', 'l4','8745120123');
insert into lab_tech values('L1003', 'Sammy Kumar', 150000, 'BSc. Medical Lab', 'l2','1045124512');
insert into lab_tech values('L1004', 'Ali Trivedi', 420000, 'BSc. Medical Lab', 'l3','9874587410');
insert into lab_tech values('L1005', 'Trish Killu', 120000, 'BSc. Medical Lab', 'l4','9658745210');
insert into lab_tech values('L1006', 'Samu Kishi', 300000, 'BSc. Medical Lab', 'l6','9856895620');
insert into lab_tech values('L1007', 'Donaoel Kit', 250000, 'BSc. Medical Lab', 'l5','9898654512');

-- Junior Doctor to Doctor Relation Table
insert into jun_relation values('J1001', 'D1008');
insert into jun_relation values('J1002', 'D1003');
insert into jun_relation values('J1003', 'D1009');
insert into jun_relation values('J1004', 'D1010');
insert into jun_relation values('J1005', 'D1004');
insert into jun_relation values('J1006', 'D1002');
insert into jun_relation values('J1007', 'D1005');
insert into jun_relation values('J1008', 'D1007');
insert into jun_relation values('J1009', 'D1006');
insert into jun_relation values('J1010', 'D1001');

-- Lab Tech to Doctor and Junior Doctor Relation
insert into lab_relation values('L1001', 'D1008', 'J1001');
insert into lab_relation values('L1002', 'D1009', 'J1003');
insert into lab_relation values('L1003', 'D1003', 'J1002');
insert into lab_relation values('L1004', 'D1010', 'J1004');
insert into lab_relation values('L1005', 'D1005', 'J1007');
insert into lab_relation values('L1006', 'D1007', 'J1008');
insert into lab_relation values('L1007', 'D1001', 'J1010');

-- SELECT * FROM employees.maintenance;
-- SELECT * FROM employees.lab_tech;
-- SELECT * FROM employees.junior_doc;
-- SELECT * FROM employees.doctor;
-- SELECT * FROM employees.hr;
-- SELECT * FROM employees.jun_relation;
-- SELECT * FROM employees.lab_relation;