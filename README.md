truelayer_de_challenge
==============================

Data Engineer Challenge v1.04 from TrueLayer

# Processare file
Per trovare i top N del dataframe https://docs.dask.org/en/latest/generated/dask.dataframe.DataFrame.nlargest.html

1 - git clone <repo>
2 - make download_data
3 - start ES docker-compose
4 - run python script make_dataset.py
5 - start postgres docker-compose
6 - copy file output da terminale nel volume
7 - docker-compose run db bash
8 - script vari dentro psql


# Ordine comandi

- Bash script per scaricare i dataset dentro alla folder data/raw
- Script Python (runnato da Docker container, con volume per salvare l'output) che legge i file con chunksize di Pandas e produce un file di output in csv
- Runnare da terminale locale mkdir data/volume/ 
- Docker compose per mandare su Postgres con init script per creare la tabella sql già preconfigurata
- cp data/processed/nomefile.csv data/volume/pgdata
- docker-compose run db bash 
- psql -h db -U postgres
- password: postgres
- \copy movies (id, title, budget, year, revenue, rating, ratio, production_company, wikipedia_page, wikipedia_abstract) FROM '/var/lib/postgresql/data/pgdata/top_n_movies.csv' CSV HEADER;



1. Docker compose up
2. Copia file nel path
3. 



Project Organization
------------

    ├── LICENSE
    ├── Makefile           <- Makefile with commands like `make data` or `make train`
    ├── README.md          <- The top-level README for developers using this project.
    ├── data
    │   ├── external       <- Data from third party sources.
    │   ├── interim        <- Intermediate data that has been transformed.
    │   ├── processed      <- The final, canonical data sets for modeling.
    │   └── raw            <- The original, immutable data dump.
    │
    ├── docs               <- A default Sphinx project; see sphinx-doc.org for details
    │
    ├── models             <- Trained and serialized models, model predictions, or model summaries
    │
    ├── notebooks          <- Jupyter notebooks. Naming convention is a number (for ordering),
    │                         the creator's initials, and a short `-` delimited description, e.g.
    │                         `1.0-jqp-initial-data-exploration`.
    │
    ├── references         <- Data dictionaries, manuals, and all other explanatory materials.
    │
    ├── reports            <- Generated analysis as HTML, PDF, LaTeX, etc.
    │   └── figures        <- Generated graphics and figures to be used in reporting
    │
    ├── requirements.txt   <- The requirements file for reproducing the analysis environment, e.g.
    │                         generated with `pip freeze > requirements.txt`
    │
    ├── setup.py           <- makes project pip installable (pip install -e .) so src can be imported
    ├── src                <- Source code for use in this project.
    │   ├── __init__.py    <- Makes src a Python module
    │   │
    │   ├── data           <- Scripts to download or generate data
    │   │   └── make_dataset.py
    │   │
    │   ├── features       <- Scripts to turn raw data into features for modeling
    │   │   └── build_features.py
    │   │
    │   ├── models         <- Scripts to train models and then use trained models to make
    │   │   │                 predictions
    │   │   ├── predict_model.py
    │   │   └── train_model.py
    │   │
    │   └── visualization  <- Scripts to create exploratory and results oriented visualizations
    │       └── visualize.py
    │
    └── tox.ini            <- tox file with settings for running tox; see tox.readthedocs.io


--------

<p><small>Project based on the <a target="_blank" href="https://drivendata.github.io/cookiecutter-data-science/">cookiecutter data science project template</a>. #cookiecutterdatascience</small></p>
