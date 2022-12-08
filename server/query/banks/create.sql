CREATE TABLE banks(
	iban VARCHAR(35) NOT NULL PRIMARY KEY,
    name VARCHAR(512) NOT NULL,
    address VARCHAR(512) default null,
    city VARCHAR(9) default 'dfval',
	swift VARCHAR(20) default null,
    FOREIGN KEY (city) REFERENCES cities(zipcode)
);