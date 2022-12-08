CREATE TABLE donors(
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    desc VARCHAR(256) NOT NULL,--lunghezza
    id_country VARCHAR(5) NOT NULL,
    contacts VARCHAR(1024) default null,
    sending_type VARCHAR(256) default null,--lunghezza, forse solo 128
    notes VARCHAR(4096) default null,--lunghezza
    FOREIGN KEY (id_country) REFERENCES countries(code)
);