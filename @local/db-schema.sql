/* ******************************************************************************************* */
DROP TABLE IF EXISTS ##devices;
DROP TABLE IF EXISTS ##directives;
DROP TABLE IF EXISTS ##sessions;
DROP TABLE IF EXISTS ##tokens;
DROP TABLE IF EXISTS ##user_privileges;
DROP TABLE IF EXISTS ##privileges;
DROP TABLE IF EXISTS ##users;


/* ******************************************************************************************* */
CREATE TABLE ##directives
(
	subject_id int unsigned not null default 0,
	type varchar(128) not null,

	modified datetime,

	s_value varchar(8192) default null,
	i_value int default 0,
	t_value text default null
)
ENGINE=InnoDB CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci AUTO_INCREMENT=1;

ALTER TABLE ##directives ADD PRIMARY KEY pk (subject_id, type);
ALTER TABLE ##directives ADD INDEX n_type (type);
ALTER TABLE ##directives ADD INDEX n_s_value (s_value);


/* ******************************************************************************************* */
CREATE TABLE ##users
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

ALTER TABLE ##users ADD index n_username (username);
ALTER TABLE ##users ADD index n_is_active (is_active);


CREATE TABLE ##privileges
(
    privilege_id int unsigned primary key auto_increment,
    name varchar(128) not null unique key
)
ENGINE=InnoDB CHARSET=utf8mb4 COLLATE=utf8mb4_bin AUTO_INCREMENT=1;


CREATE TABLE ##user_privileges
(
    user_id int unsigned not null,
    privilege_id int unsigned not null,
	tag tinyint default 0,

    primary key (user_id, privilege_id),

    constraint foreign key (user_id) references ##users (user_id) on delete cascade,
    constraint foreign key (privilege_id) references ##privileges (privilege_id) on delete cascade
)
ENGINE=InnoDB CHARSET=utf8mb4 COLLATE=utf8mb4_bin;


CREATE TABLE ##tokens
(
	token_id int unsigned primary key auto_increment,

	is_active tinyint not null default 1,
	created datetime not null,

	user_id int unsigned not null,
	constraint foreign key (user_id) references ##users (user_id) on delete cascade,

	is_authorized tinyint not null default 1,

	token varchar(128) not null unique,
	name varchar(128) default null
)
ENGINE=InnoDB CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci AUTO_INCREMENT=1;

ALTER TABLE ##tokens ADD index n_is_active (is_active);



/* ******************************************************************************************* */
CREATE TABLE ##sessions
(
	session_id varchar(48) primary key unique not null,

	created datetime default null,
	last_activity datetime default null,

	device_id varchar(48) default null,

	user_id int unsigned default null,
	constraint foreign key (user_id) references ##users (user_id) on delete cascade,

	data varchar(8192) default null
)
ENGINE=InnoDB CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

ALTER TABLE ##sessions ADD index idx1 (device_id);
