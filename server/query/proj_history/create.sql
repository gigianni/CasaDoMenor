CREATE TABLE proj_history(
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    id_proj INT NOT NULL,
    country VARCHAR(3) NOT NULL,
    dateD DATE NOT NULL,
	desc VARCHAR(512) NOT NULL,
    FOREIGN KEY (id_proj) REFERENCES projects(id)
);