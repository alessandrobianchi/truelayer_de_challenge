mkdir databases/postgresql/volume
mkdir databases/postgresql/volume/pgdata
cp data/processed/top_n_movies.csv databases/postgresql/volume/pgdata

psql -h db -U postgres

\copy movies (id, title, budget, year, revenue, rating, ratio, production_company, wikipedia_page, wikipedia_abstract) FROM '/var/lib/postgresql/data/pgdata/top_n_movies.csv' CSV HEADER;

select * from movies;