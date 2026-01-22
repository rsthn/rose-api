--------------------------------------------------------------------------------
CREATE TABLE directives
(
    subject_id VARCHAR(128) NOT NULL DEFAULT '0',
    type VARCHAR(128) NOT NULL,
    last_modified DATETIME DEFAULT NULL,
    strval VARCHAR(8192) DEFAULT NULL,
    intval INT DEFAULT 0,
    textval TEXT DEFAULT NULL,
    PRIMARY KEY (subject_id, type)
)
ENGINE=InnoDB CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci AUTO_INCREMENT=1;
CREATE INDEX directives_subject_id ON directives (subject_id);
CREATE INDEX directives_type ON directives (type);
