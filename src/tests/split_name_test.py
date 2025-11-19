import unittest
from util import split_names

class TestSplitNames(unittest.TestCase):
    def test_single_author(self):
        content = {"author": "Example 1"}
        split_names(content)
        self.assertEqual(content["author"], ["Example 1"])

    def test_multiple_authors(self):
        content = {"author": "Example 1 and Example 2"}
        split_names(content)
        self.assertEqual(content["author"], ["Example 1", "Example 2"])

