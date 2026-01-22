--------------------------------------------------------------------------------
CREATE TABLE directives
(
    subject_id TEXT NOT NULL DEFAULT '0'
    , type TEXT NOT NULL
    , last_modified TIMESTAMP
    , strval TEXT
    , intval INT DEFAULT 0
    , textval TEXT
    , PRIMARY KEY (subject_id, type)
);
CREATE INDEX directives__subject_id ON directives (subject_id);
CREATE INDEX directives__type ON directives (type);
