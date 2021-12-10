CREATE TABLE IF NOT EXISTS movies (
    id                  integer PRIMARY KEY NOT NULL,
    title               varchar(100) NOT NULL,
    budget              real,
    year                integer,
    revenue             real,
    rating              real,
    ratio               real,
    production_company  varchar(500),
    wikipedia_page      varchar(100),
    wikipedia_abstract  varchar(1000)
);