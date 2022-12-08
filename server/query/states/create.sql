CREATE TABLE states (
	code VARCHAR(5) NOT NULL PRIMARY KEY, 
	name VARCHAR(100) NOT NULL,
	country VARCHAR(5) NOT NULL,
	FOREIGN KEY (country) REFERENCES countries(code)
);