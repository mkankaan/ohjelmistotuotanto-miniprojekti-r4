import unittest
import datetime
from util import is_date, is_date_in_past

class TestValidateDate(unittest.TestCase):
    def setUp(self):
        self.today_date = datetime.date.today()
        self.today = ".".join(reversed(str(datetime.date.today()).split("-")))

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

        self.past_dates = [
            "27.11.2025",
            "27.12.2000",
            "31.12.1990"
        ]

        self.future_dates = [
            "28.11.3000",
            "1.1.2500"
        ]

    def test_is_date(self):
        for s in self.valid_dates:
            self.assertEqual(True, is_date(s))

        for s in self.invalid_dates:
            self.assertEqual(False, is_date(s))

    def test_is_date_in_past(self):
        for s in self.past_dates:
            self.assertEqual(True, is_date_in_past(s))

        for s in self.future_dates:
            self.assertEqual(False, is_date_in_past(s))

    def test_yesterday_is_in_past(self):
        yesterday = str(self.today_date - datetime.timedelta(days=1)).split("-")
        self.assertEqual(True, is_date_in_past(".".join(reversed((yesterday)))))

    def test_today_is_in_past(self):
        self.assertEqual(True, is_date_in_past(self.today))    

    def test_tomorrow_is_in_future(self):
        tomorrow = str(self.today_date + datetime.timedelta(days=1)).split("-")
        self.assertEqual(False, is_date_in_past(".".join(reversed((tomorrow)))))
