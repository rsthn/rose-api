--------------------------------------------------------------------------------
CREATE TABLE directives
(
    subject_id VARCHAR(128) NOT NULL DEFAULT '0'
    , type VARCHAR(128) NOT NULL
    , last_modified TIMESTAMP
    , strval VARCHAR(8192)
    , intval INT DEFAULT 0
    , textval TEXT
    , PRIMARY KEY (subject_id, type)
);
CREATE INDEX directives_subject_id ON directives (subject_id);
CREATE INDEX directives_type ON directives (type);

--------------------------------------------------------------------------------
CREATE TABLE users
(
    user_id BIGINT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY
    , created_at TIMESTAMP NOT NULL
    , deleted_at TIMESTAMP
    , blocked_at TIMESTAMP
    , username VARCHAR(256) NOT NULL
    , password VARCHAR(96) NOT NULL

    , name VARCHAR(256) NOT NULL
    , email VARCHAR(256)
    , photo VARCHAR(256)
);
CREATE INDEX users_created_at ON users (created_at);
CREATE INDEX users_deleted_at ON users (deleted_at);
CREATE INDEX users_blocked_at ON users (blocked_at);
CREATE INDEX users_username ON users (deleted_at, username);

--------------------------------------------------------------------------------
CREATE TABLE permissions
(
    permission_id INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY
    , deleted_at TIMESTAMP
    , name VARCHAR(128) NOT NULL
);
CREATE INDEX permissions_name ON permissions (name) WHERE deleted_at IS NULL;

--------------------------------------------------------------------------------
CREATE TABLE user_permissions
(
    user_id BIGINT NOT NULL REFERENCES users (user_id) ON DELETE CASCADE
    , permission_id INT NOT NULL REFERENCES permissions (permission_id) ON DELETE CASCADE
    , flag SMALLINT DEFAULT 0
    , PRIMARY KEY (user_id, permission_id)
);
CREATE INDEX user_permissions_flag ON user_permissions (user_id, flag);

--------------------------------------------------------------------------------
CREATE TABLE tokens
(
    token_id BIGINT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY
    , created_at TIMESTAMP NOT NULL
    , deleted_at TIMESTAMP
    , blocked_at TIMESTAMP
    , user_id BIGINT NOT NULL
    , token VARCHAR(128) NOT NULL UNIQUE
    , name VARCHAR(128) NOT NULL
    , FOREIGN KEY (user_id) REFERENCES users (user_id)
);
CREATE INDEX tokens_user_id ON tokens (user_id, deleted_at);
CREATE INDEX tokens_token ON tokens (token, deleted_at);

--------------------------------------------------------------------------------
CREATE TABLE token_permissions
(
    token_id BIGINT NOT NULL REFERENCES tokens (token_id) ON DELETE CASCADE
    , permission_id INT NOT NULL REFERENCES permissions (permission_id) ON DELETE CASCADE
    , flag SMALLINT DEFAULT 0
    , PRIMARY KEY (token_id, permission_id)
);
CREATE INDEX token_permissions_flag ON token_permissions (token_id, flag);

--------------------------------------------------------------------------------
CREATE TABLE devices
(
    device_id BIGINT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY
    , created_at TIMESTAMP NOT NULL
    , last_activity TIMESTAMP
    , ipaddr VARCHAR(128)
    , user_id BIGINT REFERENCES users (user_id) ON DELETE CASCADE
    , user_agent VARCHAR(128)
    , webpush_subscription TEXT
    , token VARCHAR(512) NOT NULL UNIQUE
    , secret VARCHAR(512) DEFAULT NULL
);

--------------------------------------------------------------------------------
CREATE TABLE sessions
(
    session_id VARCHAR(48) PRIMARY KEY
    , created_at TIMESTAMP NOT NULL
    , last_activity TIMESTAMP
    , device_id BIGINT REFERENCES devices (device_id) ON DELETE CASCADE
    , user_id BIGINT REFERENCES users (user_id) ON DELETE CASCADE
    , data VARCHAR(8192)
);
CREATE INDEX sessions_device_id ON sessions (device_id);

--------------------------------------------------------------------------------
CREATE TABLE suspicious_identifiers
(
    identifier VARCHAR(512) NOT NULL PRIMARY KEY
    , next_attempt_at TIMESTAMP
    , last_attempt_at TIMESTAMP NOT NULL
    , count_failed INT DEFAULT 1
    , count_blocked INT DEFAULT 0
    , is_banned INT DEFAULT 0
);
