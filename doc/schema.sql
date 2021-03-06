/* 
Authors: 
 - Samuel Messing <sbm2158@columbia.edu>
 - Benjamin Rapaport <bar2150@columbia.edu>

 Conventions:
 - Entity table names start with a single capital letter,
   words separated by underscores
 - Relationship table names are all capitals, words separated
   by underscores

 NOTE: there are several integrity constraints mentioned that
 we could not yet caputre (i.e. that the attribute "amount" in
 the entity set Donations be nonnegative).

 NOTE: the size of char attributes is subject to change, the
 current values were our best estimates of our needs.
 NOTE: we could not fully capture the PROPOSE relationship,
 specifically, we could not enforce the total participation
 of teacher entities in the PROPOSE relationship. In order
 to do this, we'll need to use queries that we have yet to
 learn how to implement.
*/

-- DONE
create table Projects_PROPOSE_AT(
  pid varchar2 (32),
  fundURL varchar2 (200),
  fundingStatus varchar2 (50),
  fulfillmentTrailer varchar2 (1000),
  expirationDate date,
  totalPrice real,
  title varchar2 (100),
  subject varchar2 (100),
  shortDescription varchar2 (500),
  proposalURL varchar2 (100) not null,
  percentFunded real,
  imageURL varchar2 (200),
  numStudents integer,
  tid varchar2 (32),
  ncesId varchar2 (50) not null,
  primary key (pid, tid),
  unique (proposalURL),
  constraint projectTeachers_fk foreign key (tid) references Teachers (tid),
  constraint projectSchools_fk foreign key (ncesId) references Schools_S_IN_S_HAVE (ncesId),
  constraint projectsStudents_ck check (numStudents >= 0),
  constraint projectsPercent_ck check (percentFunded >= 0 AND percentFunded <= 1),
  constraint projectsPrice_ck check (totalPrice >= 0)
);

-- DONE
create table Teachers(
  tid varchar2 (32),
  name varchar2 (50) not null,
  primary key (tid)
);

-- DONE
create table Users(
  email varchar2 (50),
  displayName varchar2 (50) not null,
  password varchar2 (50) not null,
  passwordSalt varchar2 (50) not null,
  primary key (email),
  constraint usersEmail_ck check (REGEXP_LIKE (email, '^[a-zA-Z0-9\._\-\+]+@[a-zA-Z0-9\._\-]+\.[a-zA-Z]{2,4}$'))
);

-- DONE
create table Donations_FUND(
  tid varchar2 (32) not null,
  pid varchar2 (32) not null,
  email varchar2 (50) not null,
  amount real not null,
  donationDate date,
  did int,
  primary key (did),
  constraint donationsProjects_fk foreign key (tid, pid) references Projects_PROPOSE_AT(tid, pid),
  constraint donationsUsers_fk foreign key (email) references Users,
  constraint donationsAmt_ck check (amount >= 0)
);

-- DONE
create table Comments_ABOUT(
  tid varchar2(32) not null,
  pid varchar2(32) not null,
  comments varchar2 (500) not null,
  cDate int,
  email varchar2 (50),
  primary key (cid),
  constraint commentsUsers_fk foreign key (email) references Users,
  constraint commentsProjects_fk foreign key (tid, pid) references Projects_PROPOSE_AT(tid, pid)
);

-- DONE
create table VOTE(
  vDate date,
  tid varchar2(32),
  pid varchar2(32),
  email varchar2 (50),
  primary key (tid, pid, email),
  constraint voteUsers_fk foreign key (email) references Users,
  constraint voteProjects_fk foreign key (tid, pid) references Projects_PROPOSE_AT(tid, pid)
);

-- DONE
create table Schools_S_IN_S_HAVE(
  ncesId varchar2 (50),
  name varchar2 (100),
  avgClassSize real,
  povertyLevel varchar2 (25),
  avgMathSATScore int,
  avgReadingSATScore int,
  avgWritingSATScore int,
  currentGrade char(2),
  progressGrade char(2),
  graduationRate real,
  percentAPAbove2 real,
  dNumber int not null,
  latitude real not null,
  longitude real not null,
  primary key (ncesId),
  constraint schoolsDistricts_fk foreign key (dNumber) references Districts_D_IN,
  constraint schoolsAddresses_fk foreign key (latitude, longitude) references Addresses (latitude, longitude),
  constraint schoolsSize_ck check (avgClassSize is null OR avgClassSize >= 0),
  constraint schoolsMath_ck check (avgMathSATScore is null OR (avgMathSATScore >= 200 AND avgMathSATScore <= 800)),
  constraint schoolsRead_ck check (avgReadingSATScore is null OR (avgReadingSATScore >= 200 AND avgReadingSATScore <= 800)),
  constraint schoolsWrite_ck check (avgWritingSATScore is null OR (avgWritingSATScore >= 200 AND avgWritingSATScore <= 800)),
  constraint schoolsAP_ck check (percentAPAbove2 is null OR (percentAPAbove2 >= 0 AND percentAPAbove2 <= 1))
);

--DONE
create table Addresses(
  latitude real,
  longitude real,
  streetNumber varchar2 (25),
  streetName varchar2 (100),
  zipcode varchar2 (5),
  bName varchar2 (50),
  primary key (latitude, longitude),
  constraint addrBorough_fk foreign key (bName) references Boroughs,
  constraint addrLat_ck check (latitude >= -90 AND latitude <= 90),
  constraint addrLong_ck check (longitude >= -90 AND longitude <= 90),
  constraint addrZip_ck check (REGEXP_LIKE (zipcode, '[0-9]{5}'))
);

-- DONE
create table Districts_D_IN(
  avgAttendance real,
  percentRecvPublicAsst real,
  dNumber int,
  bName varchar2 (50) not null,
  primary key (dNumber),
  constraint distBorough_fk foreign key (bName) references Boroughs,
  constraint distPublicassist_ck check (percentRecvPublicAsst is null OR (percentRecvPublicAsst >= 0 AND percentRecvPublicAsst <= 1)),
  constraint distAttendance_ck check (avgAttendance is null OR (avgAttendance >= 0 AND avgAttendance <= 1))
);

-- DONE
create table Boroughs(
  bName varchar2 (50),
  primary key(bName)
);

-- DONE
create table After_School_Programs_A_HAVE(
  aid varchar2 (50),
  name varchar2 (100) not null,
  programType varchar2 (100),
  agencyName varchar2 (100),
  organizationName varchar2 (100),
  elementaryLevel char(1) check (elementaryLevel in ('T', 'F')),
  middleSchoolLevel char(1) check (middleSchoolLevel in ('T', 'F')),
  highSchoolLevel char(1) check (highSchoolLevel in ('T', 'F')),
  organizationPhoneNumber varchar2 (20),
  latitude real not null,
  longitude real not null,
  primary key (aid),
  constraint afterAddress_fk foreign key (latitude, longitude) references Addresses (latitude, longitude)
);
