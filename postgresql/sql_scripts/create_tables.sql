CREATE TABLE IF NOT EXISTS addresses_data (
    id        integer PRIMARY KEY,
    name      varchar(40) NOT NULL,
    last_name varchar(40) NOT NULL,
    street    varchar(40) NOT NULL,
    city      varchar(40) NOT NULL,
    state     varchar(40) NOT NULL,
    zip_code  varchar(40) NOT NULL
);