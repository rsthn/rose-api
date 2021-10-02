/* ******************************************************************************************* */
DROP TABLE IF EXISTS x_directives;
DROP TABLE IF EXISTS x_sessions;
DROP TABLE IF EXISTS x_user_privileges;
DROP TABLE IF EXISTS x_privileges;
DROP TABLE IF EXISTS x_users;


/* ******************************************************************************************* */
CREATE TABLE x_directives
(
	subject_id int unsigned not null default 0,
	type varchar(128) not null, /* verification_code */

	modified datetime,

	s_value varchar(256) default '',
	i_value int default 0,
	t_value text default null
)
ENGINE=InnoDB CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci AUTO_INCREMENT=1;

ALTER TABLE x_directives ADD PRIMARY KEY pk (subject_id, type);
ALTER TABLE x_directives ADD INDEX n_type (type);
ALTER TABLE x_directives ADD INDEX n_s_value (s_value);


/* ******************************************************************************************* */
CREATE TABLE x_users
(
    user_id int unsigned primary key auto_increment,
    created datetime default null,

    is_authorized tinyint not null default 1,
    is_active tinyint not null default 1,

    username varchar(256) not null,
    password char(96) not null collate utf8mb4_bin,

	photo varchar(128) default null,

	name varchar(128) default '',
	email varchar(128) default ''
)
ENGINE=InnoDB CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci AUTO_INCREMENT=1;

ALTER TABLE x_users ADD index n_username (username);
ALTER TABLE x_users ADD index n_is_active (is_active);


CREATE TABLE x_privileges
(
    privilege_id int unsigned primary key auto_increment,
    name varchar(128) not null unique key
)
ENGINE=InnoDB CHARSET=utf8mb4 COLLATE=utf8mb4_bin AUTO_INCREMENT=1;


CREATE TABLE x_user_privileges
(
    user_id int unsigned not null,
    privilege_id int unsigned not null,
	tag tinyint default 0,

    primary key (user_id, privilege_id),

    constraint foreign key (user_id) references x_users (user_id) on delete cascade,
    constraint foreign key (privilege_id) references x_privileges (privilege_id) on delete cascade
)
ENGINE=InnoDB CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

CREATE TABLE x_tokens
(
	token varchar(128) primary key,
	user_id int unsigned not null,

	is_authorized tinyint not null default 1,
	is_active tinyint not null default 1,

	constraint foreign key (user_id) references x_users (user_id) on delete cascade
)
ENGINE=InnoDB CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci AUTO_INCREMENT=1;

ALTER TABLE x_tokens ADD index n_is_active (is_active);


/* ******************************************************************************************* */
CREATE TABLE x_sessions
(
	session_id varchar(48) primary key unique not null,

	created datetime default null,
	last_activity datetime default null,

	device_id varchar(48) default null,

	user_id int unsigned default null,
	constraint foreign key (user_id) references users (user_id) on delete cascade,

	data varchar(8192) default null
)
ENGINE=InnoDB CHARSET=utf8mb4 COLLATE=utf8mb4_bin;


DROP PROCEDURE IF EXISTS x_session_cleanup;
DELIMITER //
CREATE PROCEDURE x_session_cleanup (timeout INT UNSIGNED)
BEGIN
	DELETE FROM x_sessions
	WHERE TIMESTAMPDIFF(SECOND, last_activity, NOW()) >= timeout;
END //
DELIMITER ;

DROP EVENT IF EXISTS x_session_cleanup_evt;
CREATE EVENT x_session_cleanup_evt
ON SCHEDULE EVERY 1 DAY
DO CALL x_session_cleanup (86400);
