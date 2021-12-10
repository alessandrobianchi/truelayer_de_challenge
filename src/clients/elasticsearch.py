from collections import deque
from typing import Dict, Generator

import pandas as pd
from elasticsearch import Elasticsearch
from elasticsearch.helpers import parallel_bulk
from lxml import etree

from src.data.wikipedia import WikipediaParser


class ElasticSearchWikipediaIndex:
    def __init__(self, index_name: str = 'wikipedia', host: str = 'localhost', port: str = '9200') -> None:
        self.es_client = Elasticsearch(hosts=[ElasticSearchWikipediaIndex.compose_host_url(host, port)])
        self.index_name = index_name

    @staticmethod
    def compose_host_url(host: str, port: str) -> str:
        return f'http://{host}:{port}'

    @staticmethod
    def parse_response(response: Dict) -> Dict:
        try:
            return response['hits']['hits'][0]['_source']
        except IndexError:
            return dict(title=pd.NA, url=pd.NA, abstract=pd.NA)

    def refresh(self) -> None:
        self.es_client.indices.refresh(index=self.index_name)

    def count(self) -> Dict:
        self.refresh()
        return self.es_client.cat.count(index=self.index_name, params={"format": "json"})

    def delete(self) -> None:
        self.es_client.indices.delete(index=self.index_name)

    def get_documents_iterator(self, iterator: etree.iterparse) -> Generator:
        for _, element in iterator:
            doc = WikipediaParser.get_document_from_element(element)
            doc['_index'] = self.index_name
            yield doc

    def insert(self, iterator: etree.iterparse) -> None:
        docs = self.get_documents_iterator(iterator)
        deque(parallel_bulk(self.es_client, docs), maxlen=0)

    def find(self, title: str) -> Dict:
        query_body = {
            "fuzzy": {
                "title.keyword": {
                    "value": title
                }
            }
        }
        response = self.es_client.search(index=self.index_name,
                                         query=query_body,
                                         size=1)
        return ElasticSearchWikipediaIndex.parse_response(response)
