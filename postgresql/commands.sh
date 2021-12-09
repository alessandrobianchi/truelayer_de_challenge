mkdir data/volume

mkdir data/volume/pgdata

cp data/processed/addresses.csv data/volume/pgdata




psql -h db -U postgres

\copy addresses_data (id, name, last_name, street, city, state, zip_code) FROM '/var/lib/postgresql/data/pgdata/addresses.csv' CSV HEADER;

select * from addresses_data;