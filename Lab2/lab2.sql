CREATE DATABASE Lab2;
USE Lab2;


CREATE TABLE person (
    pid CHAR(12) PRIMARY KEY,
    firstName varchar(50),
    lastName varchar(50),
    email  varchar(50),
    affiliation varchar(50),
    startDate date,
    endDate date
  );
  CREATE TABLE student (pid CHAR(12) primary key,
                        foreign key(pid) references person(pid)   
);

CREATE TABLE employee (pid CHAR(12) primary key,
                        foreign key(pid) references person(pid)

      
)
;
CREATE TABLE academic (pid CHAR(12) primary key,
                        foreign key(pid) references person(pid)
    
  
);
CREATE TABLE faculty(pid CHAR(12) primary key,
                        foreign key(pid) references person(pid)
  
);
CREATE TABLE non_academic (pid CHAR(12) primary key,
                        foreign key(pid) references person(pid)
  
);

CREATE TABLE administrative (pid CHAR(12) primary key,
                        foreign key(pid) references person(pid)
  
);
CREATE TABLE technical (pid CHAR(12) primary key,
                        foreign key(pid) references person(pid)
  
);
CREATE TABLE advises(studentPid char(12),
                        academicPid char(12) NOT NULL,
                       foreign key(studentPid) references student(pid),
                       foreign key(academicPid) references academic(pid),
                       primary key(studentPid,academicPid) );

CREATE TABLE reports_to (
  subordinate_id CHAR(12),
  supervisor_id CHAR(12),
  PRIMARY KEY (subordinate_id,supervisor_id),
  FOREIGN KEY (subordinate_id) REFERENCES employee(pid),
  FOREIGN KEY (supervisor_id) REFERENCES employee(pid)
);

CREATE TABLE Laboratory(
    labId INT PRIMARY KEY,
    name VARCHAR(100),
    building VARCHAR(100),
    roomNumber INT,
    discipline VARCHAR(100),
    facultySupervisor char(12) NOT NULL,
    FOREIGN KEY (facultySupervisor) REFERENCES faculty(pid) 
);

CREATE TABLE ResearchProject(
    code INT PRIMARY KEY,
    title VARCHAR(200),
    startDate DATE,
    endDate DATE,
    status ENUM(
        'Proposed',
        'Active',
        'Suspended',
        'Completed',
        'Cancelled'
    )
     /* since a Research project is managed by exactly one academic we don't need an extra table*/
);

CREATE TABLE Budget (
    budgetLine INT PRIMARY KEY,
    amountGranted INT,
    amountDisbursed INT,
    startDate DATE,
    endDate DATE,
    academicManager char(12) NOT NULL,
    FOREIGN KEY (academicManager) REFERENCES academic(pid)
);

CREATE TABLE Attached (
    personId char(12) NOT NULL,
    labId INT,

    PRIMARY KEY (personId, labId),

    FOREIGN KEY (personId)
        REFERENCES Person(pid),

    FOREIGN KEY (labId)
        REFERENCES Laboratory(labId)
);

CREATE TABLE Participates ( /*we opted for a table even though a person only has one project because we have extra attribute role*/
    personId char(12) NOT NULL,
    code INT,
    role ENUM('PI', 'Co-PI', 'Collaborator'),

    PRIMARY KEY (personId, code),

    FOREIGN KEY (personId) REFERENCES person(pid),

    FOREIGN KEY (code)
        REFERENCES ResearchProject(code)
);


CREATE TABLE FundsLab (
    labId INT,
    budgetLine INT NOT NULL,
    PRIMARY KEY (labId, budgetLine),
    FOREIGN KEY (labId) REFERENCES Laboratory(labId),
    FOREIGN KEY (budgetLine) REFERENCES Budget(budgetLine)
);

CREATE TABLE FundsPrj (
    code INT,
    budgetLine INT NOT NULL,
    PRIMARY KEY (code, budgetLine),
    FOREIGN KEY (code) REFERENCES ResearchProject(code),
    FOREIGN KEY (budgetLine) REFERENCES Budget(budgetLine)
);

CREATE TABLE EquipmentModel (
    modelId INT PRIMARY KEY,
    commercialName VARCHAR(50),
    manufacturer VARCHAR(50),
    category VARCHAR(50),
    requiredEnvironment VARCHAR(50),
    trainingMandatory VARCHAR(50)
);

CREATE TABLE EquipmentUnit (
    serialNo INT PRIMARY KEY,
    modelId INT NOT NULL,
    labId INT NOT NULL,
    acquisitionDate DATE,
    purchaseCost INT,
    status VARCHAR(50),
    portable BOOLEAN,
    FOREIGN KEY (modelId) references EquipmentModel(modelId)
);

CREATE TABLE Certification (
    code INT PRIMARY KEY,
    title VARCHAR(50),
    issuingAuthority VARCHAR(50),
    validityPeriod INT,
    safetyLevel VARCHAR(50)
);

CREATE TABLE Requires (
    code INT,
    modelId INT,
    PRIMARY KEY (code, modelId),
    FOREIGN KEY (code) REFERENCES Certification(code),
    FOREIGN KEY (modelId) REFERENCES EquipmentModel(modelId)
);

CREATE TABLE Holds (
    code INT,
    pid char(12),
    grade INT,
    issueDate DATE,
    expirationDate DATE,
    FOREIGN KEY (code) REFERENCES Certification(code),
    FOREIGN KEY (pid) REFERENCES person(pid)
);



create TABLE Reservation (
     Resv_id int primary key,
     sub_time timestamp,
     start_time timestamp,
     end_time timestamp,
     purpose varchar(100),
     Resv_status varchar(100),
     
	 pid char(12) not null,
     Research_project_code int not null,
     Approver_id char(12),
     
     foreign key (Research_project_code) references ResearchProject(code),
     foreign key(pid) references person(pid),
     foreign key(Approver_id) references person(pid)
     
     );
create TABLE reserves (
    Resv_id int,
     Userial_number int NOT NULL,
     primary key(Resv_id, Userial_number),
     foreign key(Resv_id) references Reservation(Resv_id),
     foreign key(Userial_number) references EquipmentUnit(serialNo)
     );
     
     
create TABLE MaintenanceTechEq (
    Userial_number INT not null,
    start_timestamp timestamp not null,
    pid char(12) not null,
    maint_cost DECIMAL(10,2),
    maint_outcome varchar(100),
    maint_description varchar(100),
    maint_type varchar(50),
    end_timestamp timestamp,
    primary key(Userial_number, start_timestamp,pid),
    foreign key(Userial_number) references EquipmentUnit(serialNo),
    foreign key(pid) references technical(pid) 
      );
CREATE TABLE CalibrationRecordEq(
    calibDate date NOT NULL,
    serialNo int NOT NULL,
    primary key(calibDate,serialNo),
    FOREIGN KEY (serialNo) references EquipmentUnit(serialNo)
);
CREATE TABLE Consumable(
  consId int PRIMARY KEY,
  name VARCHAR(50),
  unitOfMeasure VARCHAR(20),
  hazardLevel VARCHAR(20),
  reorderThreshold int
  );
  CREATE TABLE Supplier(
  suppId int PRIMARY KEY,
  name VARCHAR(50),
  contactEmail VARCHAR(255),
  phone  VARCHAR(20)
  );
  CREATE TABLE Supplies(
  suppId INT,
  consId INT,
  labId INT,
  unitPrice DECIMAL(10,2),
  PRIMARY KEY(suppId,consId,labId),
  FOREIGN KEY (suppId) REFERENCES Supplier(suppId),
  FOREIGN KEY (consId) REFERENCES Consumable(consId),
  FOREIGN KEY (labId) REFERENCES Laboratory(labId)
  );
  CREATE TABLE stocks(
  
  consId INT,
  labId INT,
  quantityOnHand INT,
  lastRestockDate INT,
  pid char(12) NOT NULL,
  MonitoringSince date,
  storageCondition VARCHAR(50),
  primary key(consId, labId,pid),
  FOREIGN KEY (consId) REFERENCES consumable(consId),
  FOREIGN KEY (labId) REFERENCES Laboratory(labId),
    FOREIGN KEY (pid) REFERENCES technical(pid)


  );
  
  CREATE TABLE Consumes(
  resId INT,
  consId INT,
  labId INT,
  quantityUsed INT,
  PRIMARY KEY (resId,consId,labId),
  FOREIGN KEY (consId) REFERENCES Consumable(consId),
  FOREIGN KEY (resId) REFERENCES Reservation(Resv_id),
    FOREIGN KEY (labId) REFERENCES Laboratory(labId)

);


