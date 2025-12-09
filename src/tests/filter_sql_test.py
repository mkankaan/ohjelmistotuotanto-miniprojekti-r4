import unittest
from util import filter_sql

class TestFilterSQL(unittest.TestCase):
    def setUp(self):
        pass

    def test_return_empty_string_if_empty_dict(self):
        self.assertEqual(filter_sql({}), "")

    def test_return_correct_string_if_valid_values(self):
        filter_dict = {"min_year": "1990", "max_year": "2000"}
        expected_result = " WHERE year >= :min_year AND year <= :max_year"
        self.assertEqual(filter_sql(filter_dict), expected_result)

    def test_return_correct_string_if_some_field_empty(self):
        filter_dict = {"min_year": "", "max_year": "2000"}
        expected_result = " WHERE year <= :max_year"
        self.assertEqual(filter_sql(filter_dict), expected_result)

    def test_return_empty_string_if_invalid_value(self):
        filter_dict = {"min_year": "a", "max_year": ""}
        self.assertEqual(filter_sql(filter_dict), "")
