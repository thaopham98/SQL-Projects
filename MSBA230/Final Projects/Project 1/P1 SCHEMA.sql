CREATE TABLE Users(
	UserID int PRIMARY KEY IDENTITY(1,1),
	FirstName varchar(50),
	LastName varchar(50),
	UserRole varchar(20),
	ContactNumber int,
	MembershipStatus varchar(20))

CREATE TABLE Resources(
	ResourceID int PRIMARY KEY IDENTITY(1,1),
	Title varchar(50),
	AuthorFirstName varchar(20),
	AuthorLastName varchar(50),
	ResourceType varchar(20),
	PublicationDate date,
	Genre varchar(20),
	AvailableStatus varchar(20))

CREATE TABLE Borrowings(
	BorrowingID int PRIMARY KEY IDENTITY(1,1),
	CheckoutDate date,
	ReturnDate int,
	OverdueItems int,
	Fines int,
	UserID int FOREIGN KEY REFERENCES Users(UserID),
	ResourceID int FOREIGN KEY REFERENCES Resources(ResourceID))

CREATE TABLE Events(
	EventID int PRIMARY KEY IDENTITY(1,1),
	EventName varchar(50),
	EventDate date)

CREATE TABLE Participants(
	ParticipantID int PRIMARY KEY IDENTITY(1,1),
	AttendanceStatus varchar(20),
	EventID int FOREIGN KEY REFERENCES Events(EventID),
	UserID int FOREIGN KEY REFERENCES Users(UserID))

CREATE TABLE Facility(
	FacilityID int PRIMARY KEY IDENTITY(1,1),
	FacilityType varchar(20),
	Availability varchar(20))

CREATE TABLE FacilityReservation(
	ReservationID int PRIMARY KEY IDENTITY(1,1),
	StartTime time,
	EndTime time,
	Duration int,
	UserID int FOREIGN KEY REFERENCES Users(UserID),
	FacilityID int FOREIGN KEY REFERENCES Facility(FacilityID))

CREATE TABLE SupportServices(
	ServiceID int PRIMARY KEY IDENTITY(1,1),
	ServiceType varchar(20),
	ServiceDescription varchar(50))

CREATE TABLE ServiceUtilization(
	AppointmentID int PRIMARY KEY IDENTITY(1,1),
	StartTime time,
	EndTime time,
	AppointmentDuration int,
	UserID int FOREIGN KEY REFERENCES Users(UserID),
	ServiceID int FOREIGN KEY REFERENCES SupportServices(ServiceID))

CREATE TABLE Librarians(
	LibrarianID int PRIMARY KEY IDENTITY(1,1),
	FirstName varchar(20),
	LastName varchar(20),
	Specialization varchar(50),
	ContactDetails varchar(50))

CREATE TABLE ResearchConsultation(
	ConsultationID int PRIMARY KEY IDENTITY(1,1),
	ConsultingDate date,
	StartTime time,
	EndTime time,
	UserID int FOREIGN KEY REFERENCES Users(UserID),
	LibrarianID int FOREIGN KEY REFERENCES Librarians(LibrarianID))