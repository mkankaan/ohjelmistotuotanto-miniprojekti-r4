import unittest
from util import get_bibtex, citation_bibtex, bibtex_field
from app import app

class TestBibtex(unittest.TestCase):
    def setUp(self):
        self.citations = [
        {
            "citation_key": "key1",
            "title": "Title 1",
            "type": "book",
            "author": "Alan Turing",
            "publisher": "Otava",
            "year": 2025,
            "isbn": "111-111-11111-1-1",
            "doi": "10.1234/456",
            "url": "https://www.test.com"
        },
        {
            "citation_key": "key2",
            "title": "Title 2",
            "type": "inproceedings",
            "author": "Martin, Robert and Fowler, Martin"
        }]

        self.expected = [
            "@book{key1,\n" \
            "\xa0title = {Title 1},\n" \
            "\xa0author = {Alan Turing},\n" \
            "\xa0publisher = {Otava},\n" \
            "\xa0year = {2025},\n" \
            "\xa0isbn = {111-111-11111-1-1},\n" \
            "\xa0doi = {10.1234/456},\n" \
            "\xa0url = {https://www.test.com}\n" \
            "}",
            "@inproceedings{key2,\n" \
            "\xa0title = {Title 2},\n" \
            "\xa0author = {Martin, Robert and Fowler, Martin}\n" \
            "}"]

    def test_bibtex_field(self):
        self.assertEqual(bibtex_field("key", "value"), f"\xa0key = {{value}}")

    def test_citation_to_bibtex(self):
        self.assertEqual(citation_bibtex(self.citations[0]), self.expected[0])
    
    def test_multiple_citations_to_bibtex(self):
        self.assertEqual(get_bibtex(self.citations), "\n\n".join(self.expected))

    def test_empty_list(self):
        self.assertEqual(get_bibtex([]), "")

class TestDownloadBibtex(unittest.TestCase):
    def setUp(self):
        app.testing = True
        self.client = app.test_client()
        self.sample_bibtex = "@book{testkey,\n  title = {Test Book}\n}"

    def test_bibtex_page_renders_with_content(self):
        with self.client.session_transaction() as sess:
            sess["bibtex"] = self.sample_bibtex

        response = self.client.get('/bibtex')
        self.assertEqual(response.status_code, 200)

        self.assertIn(b'Download BibTeX', response.data)
        self.assertIn(b'Copy BibTeX', response.data)

    def test_bibtex_content_in_page(self):
        with self.client.session_transaction() as sess:
            sess["bibtex"] = self.sample_bibtex

        response = self.client.get('/bibtex')
        self.assertEqual(response.status_code, 200)

        self.assertIn(b'@book{testkey', response.data)

