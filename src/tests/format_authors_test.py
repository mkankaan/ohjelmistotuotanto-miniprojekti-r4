import unittest
from util import format_authors

class TestFormatAuthors(unittest.TestCase):
    def setUp(self):
        pass

    def test_add_connector_between_names(self):
        authors = ["Allan Collins", "John Seely Brown", "Ann Holum"]
        expected_result = "Allan Collins and John Seely Brown and Ann Holum"
        self.assertEqual(expected_result, format_authors(authors))

    def test_return_empty_string_if_empty_list(self):
        self.assertEqual("", format_authors([]))

    def test_dont_add_connector_if_one_name(self):
        authors = ["Martin, Robert"]
        self.assertEqual(authors[0], format_authors(authors))
