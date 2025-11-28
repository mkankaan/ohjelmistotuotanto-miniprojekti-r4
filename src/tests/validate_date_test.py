import unittest
from util import is_date

class TestValidateDate(unittest.TestCase):
    def setUp(self):
        self.valid_dates = [
            "28.11.2025",
            "01.01.1000",
            "1.1.1000",
            "31.12.3000",
            "29.2.2020",
            "     4.05.2020   ",
        ]

        self.invalid_dates = [
            "32.12.3000",
            "3.13.3000",
            "1.0.3000",
            "1.2.0",
            "",
            "1",
            "1.0"
            "1.2.3.4",
            "abc",
            "1. 1 2. 2000",
            "!",
            "29.2.2021",
            "-1.2.2021"
        ]

    def test_is_date(self):
        for s in self.valid_dates:
            self.assertEqual(True, is_date(s))

        for s in self.invalid_dates:
            self.assertEqual(False, is_date(s))