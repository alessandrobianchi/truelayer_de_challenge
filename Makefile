.PHONY: clean_python data lint requirements clean_volumes set_volumes download_data

#################################################################################
# GLOBALS                                                                       #
#################################################################################

PROJECT_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
PROFILE = default
PROJECT_NAME = truelayer_de_challenge
PYTHON_INTERPRETER = python3

ifeq (,$(shell which conda))
HAS_CONDA=False
else
HAS_CONDA=True
endif

#################################################################################
# COMMANDS                                                                      #
#################################################################################

## Install Python Dependencies
requirements: test_environment
	$(PYTHON_INTERPRETER) -m pip install -U pip setuptools wheel
	$(PYTHON_INTERPRETER) -m pip install -r requirements.txt

## Make Dataset
data: requirements
	$(PYTHON_INTERPRETER) src/data/make_dataset.py data/raw data/processed

## Download data from the Web  TODO: aggiornare Kaggle
download_data:
	wget https://dumps.wikimedia.org/enwiki/latest/enwiki-latest-abstract.xml.gz -O data/raw/enwiki-latest-abstract.xml.gz
	# wget https://www.kaggle.com/rounakbanik/the-movies-dataset/version/7#movies_metadata.csv -O data/raw/movies_metadata.csv
	pushd data/raw
	gzip -d enwiki-latest-abstract.xml.gz
	# TODO: unzipping Kaggle
	popd

## Delete all compiled Python files
clean_python:
	find . -type f -name "*.py[co]" -delete
	find . -type d -name "__pycache__" -delete

## Clear all data stored inside the Docker Volumes
clean_volumes:
	rm -rf databases/elasticsearch/volume
	rm -rf databases/postgresql/volume

## Set up directories that will be mounted as Docker volumes
set_volumes: clean_volumes
	mkdir databases/elasticsearch/volume
	mkdir databases/postgresql/volume
	# mkdir databases/postgresql/volume/pgdata

## Lint using flake8
lint:
	flake8 src

## Set up python interpreter environment
create_environment:
ifeq (True,$(HAS_CONDA))
		@echo ">>> Detected conda, creating conda environment."
ifeq (3,$(findstring 3,$(PYTHON_INTERPRETER)))
	conda create --name $(PROJECT_NAME) python=3
else
	conda create --name $(PROJECT_NAME) python=2.7
endif
		@echo ">>> New conda env created. Activate with:\nsource activate $(PROJECT_NAME)"
else
	$(PYTHON_INTERPRETER) -m pip install -q virtualenv virtualenvwrapper
	@echo ">>> Installing virtualenvwrapper if not already installed.\nMake sure the following lines are in shell startup file\n\
	export WORKON_HOME=$$HOME/.virtualenvs\nexport PROJECT_HOME=$$HOME/Devel\nsource /usr/local/bin/virtualenvwrapper.sh\n"
	@bash -c "source `which virtualenvwrapper.sh`;mkvirtualenv $(PROJECT_NAME) --python=$(PYTHON_INTERPRETER)"
	@echo ">>> New virtualenv created. Activate with:\nworkon $(PROJECT_NAME)"
endif

## Test python environment is setup correctly
test_environment:
	$(PYTHON_INTERPRETER) test_environment.py
