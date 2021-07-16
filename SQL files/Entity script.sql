
-- drop schema entity;

create database entity;
use entity;

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

-- create table lab_p(
-- lab_no varchar(7),
-- test_type varchar(50),
-- p_id varchar(8),
-- primary key(lab_no,p_id,test_type),
-- foreign key (lab_no,test_type) references lab(lab_no,type_of_test),
-- foreign key (p_id) references patient(p_id)
-- );

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

insert into department values ('d1','OPD',1,1,1,10,NULL,NULL,NULL);
insert into department values ('d2','Orthopaedics Department',7,3,2,35,20,7,6);
insert into department values ('d3','Opthalmology Department',2,2,0,10,3,5,4);
insert into department values ('d4','Cardiology Department',7,3,2,20,9,8,7);
insert into department values ('d5','Psychiatry Department',5,5,1,25,15,13,7);
insert into department values ('d6','Neurology Department',7,3,2,20,15,12,10);
insert into department values ('d7','Dermatology Department',16,1,3,30,22,50,40);
insert into department values ('d8','Radiology Department',2,0,0,5,5,20,20);

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

insert into lab values ('l1',5,'X-ray Test');
insert into lab values ('l2',2,'Eye Examination');
insert into lab values ('l3',4,'MRI and CT');
insert into lab values ('l4',1,'Psychometric test');
insert into lab values ('l5',3,'Blood Test');
insert into lab values ('l6',4,'Diascopy');
insert into lab values ('l7',2,'Medical Test');

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

insert into posthumus values ('ps1','P11','2021-01-25 18:24:50',71,'Heart Attack','#589, Addy nagar, Barnal','Gurpreet');
insert into posthumus values ('ps2','P12','2020-12-26 19:04:50',65,'Electric shock','#89, Sabna nagar, Kotakpura','Jasmeet');

insert into medical_history_1 values ('P2', 'bone replacement','-','Bone fracture in left knee');
insert into medical_history_1 values ('P4', 'stunt placement','-','Heart patient');
insert into medical_history_1 values ('P5', '-','-','Record of psychiatry problems');
insert into medical_history_1 values ('P6', 'Neurosurgery','-','Hit hard on head');
insert into medical_history_1 values ('P11', 'ECR','-','Heart patient');

insert into medical_history_2 values ('P1','Common cold','2-3 years','Sinarest');
insert into medical_history_2 values ('P9','Bone ache','2-3 years','Supplements');
insert into medical_history_2 values ('P10','Eye dryness','1 year','Lubricant');
insert into medical_history_2 values ('P7','Skin infection','1-1.5 years','Antibiotics');
insert into medical_history_2 values ('P8','OCD','2-3 years','Sessions');