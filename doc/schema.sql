# Authors: 
# - Samuel Messing <sbm2158@columbia.edu>
# - Benjamin Rapaport <bar2150@columbia.edu>
#
# Conventions:
# - Entity table names start with a single capital letter,
#   words separated by underscores
# - Relationship table names are all capitals, words separated
#   by underscores
#
# NOTE: there are several integrity constraints mentioned that
# we could not yet caputre (i.e. that the attribute "amount" in
# the entity set Donations be nonnegative).
#
# NOTE: the size of char attributes is subject to change, the
# current values were our best estimates of our needs.

# NOTE: we could not fully capture the PROPOSE relationship,
# specifically, we could not enforce the total participation
# of teacher entities in the PROPOSE relationship. In order
# to do this, we'll need to use queries that we have yet to
# learn how to implement.
create table Projects_PROPOSE_AT(
  pid integer,
  fundURL char(300),
  fundingStatus char(50),
  fulfillmentTrailer char(300),
  expirationDate date,
  totalPrice real,
  title char(100),
  subject char(100),
  shortDescription char(500),
  proposalURL char(300) not null,
  percentFunded real,
  imageURL char(300),
  numStudents integer,
  tid int not null,
  tName char(200) not null,
  ncesId char(300) not null,
  primary key (pid),
  unique (proposalURL),
  foreign key (tid, tName) references Teachers (tid, name)
                      on delete no action
                      on update cascade,
  foreign key (ncesId) references Schools (ncesId)
                      on delete no action
                      on update cascade
);

create table Teachers(
  tid int,
  name char(200) not null,
  primary key (tid)
);

create table Users(
  email char(200),
  displayName char(200) not null,
  password char(128) not null,
  passwordSalt char(200) not null,
  primary key (email)
);

create table Donations_FUND(
  tid int not null,
  pid int not null,
  email char(200) not null,
  amount real not null,
  donationDate date,
  did int,
  primary key (did),
  foreign key (tid, pid) references PROPOSE(tid, pid),
  foreign key (email) references Users
);

create table Comments_ABOUT(
  tid int not null,
  pid int not null,
  comment char(500) not null,
  cDate date,
  email char(200),
  primary key (cDate, email),
  foreign key (email) references Users
                        on delete no action
                        on update cascade,
  foreign key (tid, pid) references PROPOSE(tid, pid)
                        on delete cascade
                        on update cascade
);

create table VOTE(
  vDate date,
  tid int,
  pid int,
  email char(200),
  primary key (tid, pid, email),
  foreign key (email) references Users
                      on delete no action
                      on update cascade,
  foreign key (tid, pid) references PROPOSE(tid, pid)
                      on delete cascade
                      on update cascade
);

create table Schools_S_IN_S_HAVE(
  ncesId char(50),
  name char(300),
  avgClassSize real,
  povertyLevel char(50),
  avgMathSATScore int,
  avgReadingSATScore int,
  avgWritingSATScore int,
  currentGrade char(2),
  progressGrade char(2),
  graduationRate real,
  percentAPAbove2 real,
  dNumber int not null,
  streetNumber char(10) not null,
  streetName char(150) not null,
  zipcode int not null,
  primary key (ncesId),
  foreign key (dNumber) references School_Districts_D_IN
                          on delete no action
                          on update cascade,
  foreign key (streetNumber, streetName, zipcode) references 
                          Addresses(streetNumber, streetName, zipCode)
                          on delete no action
                          on update cascade
);

create table Addresses(
  latitude real,
  longitude real,
  streetNumber char(10),
  streetName char(150),
  zipcode int,
  primary key (streetNumber, streetName, zipcode)
);

create table Districts_D_IN(
  avgAttendance real,
  precentRecvPublicAsst real,
  dNumber int,
  bName char(100) not null,
  primary key (dNumber),
  foreign key (bName) references Boroughs
);

create table Boroughs(
  bName char(100),
  primary key(bName)
);

create table After_School_Programs_A_HAVE(
  aid int,
  name char(300) not null,
  programType char(300),
  agencyName char(300),
  organizationName char(300),
  elementaryLevel boolean,
  middleSchoolLevel boolean,
  highSchoolLevel boolean,
  organizationPhoneNumber char(20),
  streetNumber char(10) not null,
  streetName char(150) not null,
  zipcode int not null,
  primary key (aid),
  foreign key (streetNumber, streetName, zipcode) references 
                          Addresses(streetNumber, streetName, zipCode)
                          on delete no action
                          on update cascade
);