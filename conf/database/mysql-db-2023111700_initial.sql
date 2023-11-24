--------------------------------------------------------------------------------
CREATE TABLE directives
(
    subject_id INT NOT NULL DEFAULT 0,
    type VARCHAR(128) NOT NULL,
    last_modified DATETIME DEFAULT NULL,
    strval VARCHAR(8192) DEFAULT NULL,
    intval INT DEFAULT 0,
    textval TEXT DEFAULT NULL,
    PRIMARY KEY (subject_id, type)
)
ENGINE=InnoDB CHARSET=utf8mb4 COLLATE=utf8_unicode_ci AUTO_INCREMENT=1;
CREATE INDEX directives_subject_id ON directives (subject_id);
CREATE INDEX directives_type ON directives (type);

--------------------------------------------------------------------------------
CREATE TABLE users
(
    user_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    created_at DATETIME NOT NULL,
    deleted_at DATETIME DEFAULT NULL,
    blocked_at DATETIME DEFAULT NULL,
    username VARCHAR(256) NOT NULL,
    password VARCHAR(96) NOT NULL
)
ENGINE=InnoDB CHARSET=utf8mb4 COLLATE=utf8_unicode_ci AUTO_INCREMENT=1;
CREATE INDEX users_created_at ON users (created_at);
CREATE INDEX users_deleted_at ON users (deleted_at);
CREATE INDEX users_blocked_at ON users (blocked_at);
CREATE INDEX users_username ON users (username, deleted_at);

--------------------------------------------------------------------------------
CREATE TABLE privileges
(
    privilege_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(128) NOT NULL UNIQUE
)
ENGINE=InnoDB CHARSET=utf8mb4 COLLATE=utf8_unicode_ci;

--------------------------------------------------------------------------------
CREATE TABLE user_privileges
(
    user_id INT NOT NULL,
    privilege_id INT NOT NULL,
    flag INT DEFAULT 0,
    PRIMARY KEY (user_id, privilege_id),
    FOREIGN KEY (user_id) REFERENCES users (user_id),
    FOREIGN KEY (privilege_id) REFERENCES privileges (privilege_id)
)
ENGINE=InnoDB CHARSET=utf8mb4 COLLATE=utf8_unicode_ci;
CREATE INDEX user_privileges_flag ON user_privileges (user_id, flag);

--------------------------------------------------------------------------------
CREATE TABLE tokens
(
    token_id INT PRIMARY KEY AUTO_INCREMENT,
    created_at DATETIME NOT NULL,
    deleted_at DATETIME DEFAULT NULL,
    blocked_at DATETIME DEFAULT NULL,
    user_id INT NOT NULL,
    token VARCHAR(128) NOT NULL UNIQUE,
    name VARCHAR(128) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users (user_id)
)
ENGINE=InnoDB CHARSET=utf8mb4 COLLATE=utf8_unicode_ci AUTO_INCREMENT=1;
CREATE INDEX tokens_user_id ON tokens (user_id, deleted_at);
CREATE INDEX tokens_token ON tokens (token, deleted_at);

--------------------------------------------------------------------------------
CREATE TABLE token_privileges
(
    token_id INT NOT NULL,
    privilege_id INT NOT NULL,
    flag INT DEFAULT 0,
    PRIMARY KEY (token_id, privilege_id),
    FOREIGN KEY (token_id) REFERENCES tokens (token_id),
    FOREIGN KEY (privilege_id) REFERENCES privileges (privilege_id)
)
ENGINE=InnoDB CHARSET=utf8mb4 COLLATE=utf8_unicode_ci;
CREATE INDEX token_privileges_flag ON token_privileges (token_id, flag);

--------------------------------------------------------------------------------
CREATE TABLE devices
(
    device_id VARCHAR(48) PRIMARY KEY,
    created_at DATETIME DEFAULT NULL,
    ipaddr VARCHAR(128) DEFAULT NULL,
    user_id INT DEFAULT NULL,
    user_agent VARCHAR(128) DEFAULT NULL,
    FOREIGN KEY (user_id) REFERENCES users (user_id) ON DELETE CASCADE
)
ENGINE=InnoDB CHARSET=utf8mb4 COLLATE=utf8_unicode_ci AUTO_INCREMENT=1;

--------------------------------------------------------------------------------
CREATE TABLE sessions
(
    session_id VARCHAR(48) PRIMARY KEY,
    created_at DATETIME DEFAULT NULL,
    last_activity DATETIME DEFAULT NULL,
    device_id VARCHAR(48) DEFAULT NULL,
    user_id INT DEFAULT NULL,
    data VARCHAR(8192) DEFAULT NULL,
    FOREIGN KEY (user_id) REFERENCES users (user_id) ON DELETE CASCADE
)
ENGINE=InnoDB CHARSET=utf8mb4 COLLATE=utf8_unicode_ci AUTO_INCREMENT=1;
CREATE INDEX sessions_device_id ON sessions (device_id);
