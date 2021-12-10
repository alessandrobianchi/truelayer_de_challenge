from re import sub
from typing import Dict

from lxml import etree


class WikipediaParser:
    """Class to parse the Wikipedia dump"""

    tag_name = 'doc'

    @staticmethod
    def get_file_iterator(file_path: str) -> etree.iterparse:
        return etree.iterparse(file_path, tag=WikipediaParser.tag_name)

    @staticmethod
    def get_field_from_element(et: etree.ElementTree, field: str) -> str:
        return et.find(field).text

    @staticmethod
    def clean_page_title(title: str) -> str:
        title = sub(r'^Wikipedia: ', '', title)
        title = title.strip()
        return title

    @staticmethod
    def get_document_from_element(et: etree.ElementTree) -> Dict:
        title = WikipediaParser.clean_page_title(WikipediaParser.get_field_from_element(et, 'title'))
        url = WikipediaParser.get_field_from_element(et, 'url')
        abstract = WikipediaParser.get_field_from_element(et, 'abstract')
        return dict(title=title, url=url, abstract=abstract)
