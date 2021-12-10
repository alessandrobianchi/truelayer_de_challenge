from src.clients.elasticsearch import ElasticSearchWikipediaIndex
from src.data.wikipedia import WikipediaParser


def main():

    wikipedia_file_path = ''  # TODO: capire cosa mettere qua
    wikipedia_iterator = WikipediaParser.get_file_iterator(wikipedia_file_path)

    es = ElasticSearchWikipediaIndex()
    es.insert(wikipedia_iterator)


if __name__ == '__main__':
    main()
