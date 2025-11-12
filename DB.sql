CREATE TABLE passengers (
  id INT PRIMARY KEY AUTO_INCREMENT,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL,
  phone VARCHAR(20) NOT NULL
);

CREATE TABLE airports (
  code VARCHAR(3) PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  city VARCHAR(50) NOT NULL
);

INSERT INTO airports (code, name, city) VALUES
('BKK', 'Suvarnabhumi Airport', 'Bangkok'),
('DMK', 'Don Mueang International Airport', 'Bangkok'),
('CNX', 'Chiang Mai International Airport', 'Chiang Mai'),
('HKT', 'Phuket International Airport', 'Phuket'),
('USM', 'Samui International Airport', 'Koh Samui'),
('UTH', 'Udon Thani International Airport', 'Udon Thani'),
('HDY', 'Hat Yai International Airport', 'Hat Yai'),
('KUL', 'Kuala Lumpur International Airport', 'Kuala Lumpur'),
('SIN', 'Changi Airport', 'Singapore'),
('HAN', 'Noi Bai International Airport', 'Hanoi'),
('SGN', 'Tan Son Nhat International Airport', 'Ho Chi Minh City'),
('TPE', 'Taoyuan International Airport', 'Taipei'),
('ICN', 'Incheon International Airport', 'Seoul'),
('NRT', 'Narita International Airport', 'Tokyo'),
('LAX', 'Los Angeles International Airport', 'Los Angeles');

CREATE TABLE flights (
  id VARCHAR(20) PRIMARY KEY,
  flight_number VARCHAR(20) NOT NULL,
  origin_code VARCHAR(3) NOT NULL, 
  destination_code VARCHAR(3) NOT NULL,
  flight_date DATE NOT NULL,
  depart_time VARCHAR(10) NOT NULL,
  price INTEGER NOT NULL,
  FOREIGN KEY (origin_code) REFERENCES airports(code),
  FOREIGN KEY (destination_code) REFERENCES airports(code)
);

INSERT INTO flights (id, flight_number, origin_code, destination_code, flight_date, depart_time, price) VALUES
('F001','FD1001','BKK','CNX','2025-11-20','09:30',1500),
('F002','FD1002','DMK','HKT','2025-11-20','11:00',2200),
('F003','FD1003','CNX','BKK','2025-11-21','14:15',1400),
('F004','FD1004','BKK','USM','2025-11-22','07:00',2000),
('F005','FD2001','DMK','KUL','2025-11-20','20:45',2700),
('F006','FD2002','BKK','SIN','2025-11-25','16:00',3500),
('F007','FD2003','HKT','HAN','2025-11-28','10:30',3900),
('F008','FD3001','BKK','TPE','2025-12-01','01:00',5800),
('F009','FD3002','ICN','BKK','2025-12-05','18:30',7200),
('F010','FD3003','CNX','SGN','2025-11-27','13:50',4100);


CREATE TABLE bookings (
  id INT PRIMARY KEY AUTO_INCREMENT,
  flight_id VARCHAR(20) NOT NULL,
  passenger_id INT NOT NULL,
  booking_date DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (flight_id) REFERENCES flights(id),
  FOREIGN KEY (passenger_id) REFERENCES passengers(id)
);



CREATE TABLE payments (
  id VARCHAR(40) PRIMARY KEY,
  booking_id VARCHAR(40) UNIQUE NOT NULL,
  amount DECIMAL(10, 2) NOT NULL,
  status VARCHAR(20) NOT NULL, 
  method VARCHAR(50),
  transaction_code VARCHAR(100),
  payment_date DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (booking_id) REFERENCES bookings(id)
);