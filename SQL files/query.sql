use project;

select Doc_id,d_id,jun_name from (department join doctor on (department.d_id=doctor.d_id)) natural left outer join junior_doc order by doc_id;

-- admin
select a_id as 'Admin Id', a_name as 'Admin Name', phone_no as 'Phone No',City from admin_h;

-- doctor
select Doc_ID as 'Doctor ID', Doc_Name as 'Name', doctor.Salary, Age, Degree_level, doctor.years_exp as 'Years of experience', Specialization, doctor.night_shift_start as 'Night shift start', doctor.Night_shift_end as 'Night shift end', patients_attended as 'Patients attended', doctor.phone_no as 'Phone no', doctor.d_id as 'Department ID', d_name as 'Department Name', jun_id as 'Associated junior doctor id', jun_name as 'Associated junior doctor' from ((doctor join department using (d_id)) left outer join jun_relation using(doc_id)) left outer join junior_doc using (jun_id) order by Doc_id ASC;

-- HR
select HR_ID as 'HR Id', HR_Name as 'Name', Salary, Timing, phone_no as 'Phone No' from hr;

-- Junior Doctor
select jun_ID as 'Jun. Doc. ID', jun_Name 'Jun. Doc. Name', junior_doc.Salary, Qualifications, junior_doc.Years_exp as 'Years of experience', junior_doc.Night_shift_start as 'Night shift start', junior_doc.night_shift_end as 'Night shift end', junior_doc.phone_no as 'Phone No', junior_doc.d_id as 'Department ID', d_name as 'Department Name', doc_id as 'Associated Senior Doc. ID', doc_name as 'Associated Senior Doc.' from ((junior_doc join department using (d_id)) natural left outer join jun_relation) left outer join doctor using (doc_id) order by jun_ID ASC;

-- Patient
select p_id as 'Patient ID', p_name as 'Patient Name', admission_status as 'Admission Status', patient.City, State,Age, no_of_tests_conducted as 'No of tests conducted', ongoing_medication as 'Ongoing medication', patient.phone_no as 'Phone No', Gender, d_id as 'Department ID', d_name as 'Department Name',time_of_admission as 'Time of admission', tr_id as 'Test report ID', test_type as 'Test type', lab_no as 'Lab No', previous_operations as 'Previous Operation', Disability, previous_conditions as 'Previous Condition', previous_disease as 'Previous Disease', time_span_of_disease as 'Time span of disease', previous_medication as 'Previous Medication' from (((patient natural left outer join test_report) natural left outer join medical_history_1) natural left outer join medical_history_2) join department using (d_id) order by p_id;

-- Department
select d_id as 'Deparment ID',d_name as 'Department Name', no_of_rooms as 'No of rooms', no_of_halls as 'No of halls', no_of_consultancy_rooms as 'No of consultancy rooms', no_of_beds as 'No of beds', beds_occupied as 'Beds occupied', patient_discharge_average as 'Average patients discharged each day', patient_admissionrate_average as 'Average patients admitted each day' from department;

-- Lab
select lab_no as 'Lab No', no_of_equipments as 'No. of equipments', type_of_test as 'Type of test', d_id as 'Department Id', d_name as 'Department Name' from lab natural join lab_d natural join department;

-- Lab Technician
select tech_id as 'Tech ID', tech_name as 'Name', Salary, Qualifications, phone_no as 'Phone No', lab_no as 'Lab No', type_of_test as 'Type of test' from lab_tech natural join lab;

-- Maintenance
select main_id as 'Maintenance Id', Main_name as 'Name', Salary, Main_type as 'Maintenance Type', Street, City, phone_no as 'Phone No' from maintenance;

-- Equipment
select ventilator_in_use as 'Ventilators in use', beds_in_use as 'Beds in use', oxygen_cylinders_in_use as 'Oxygen cylinders in use' from equipments;
 