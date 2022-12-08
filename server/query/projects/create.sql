CREATE TABLE projects(
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    id_donor INT NOT NULL,
    title VARCHAR(3) default null, --lunghezza, default null perché alcuni non ce l'hanno
    notice VARCHAR(3) default null, --lunghezza, default null perché alcuni non ce l'hanno
    start_proj DATE NOT NULL,
    end_proj DATE NOT NULL,
    infos VARCHAR(3) default null, --lunghezza, default null perché alcuni non ce l'hanno
    criteria VARCHAR(3) default null, --lunghezza, default null perché alcuni non ce l'hanno
    max_funding VARCHAR(3) default null, --lunghezza/discutere del tipo della variabile, default null perché alcuni non ce l'hanno
    required_funding VARCHAR(3) default null, --lunghezza, default null perché alcuni non ce l'hanno
    required_attachments VARCHAR(3) NOT NULL, --lunghezza
    report_closing VARCHAR(3) NOT NULL, --lunghezza
    status VARCHAR(3) NOT NULL, --lunghezza, not null perché tutti ce l'hanno (o anzi, dovrebbero avercelo)
    notes VARCHAR(3) default null, --lunghezza, default null perché alcuni non ce l'hanno
    FOREIGN KEY (id_donor) REFERENCES donors(id)
);