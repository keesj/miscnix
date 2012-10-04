#!/usr/bin/env python
import random
import os
import unittest
import xmlrunner

class BasicTests(unittest.TestCase):
    def setUp(self):
	os.system("rm -rf test.img")
	os.system("rm -rf test-reports");
	os.system("mkdir test-reports");
	os.system("cp /opt/data/test.img test.img")

    def test_base_image_boots(self):
	self.value = os.system("./tests/device_boots --image test.img")
	self.assertEqual(self.value,0)

    def test_update_world(self):
	self.value = os.system("rm -rf test-update.img")
	self.value = os.system("cp test.img test-update.img")
	self.value = os.system("../autoinstall/script/04-run-script.expect -- --image test-update.img --script ./tests/update_world")
	self.assertEqual(self.value,0)

    def test_updated_image_boots(self):
	self.value = os.system("./tests/device_boots --image test-update.img")
	self.assertEqual(self.value,0)

    def test_run_posix_tests(self):
	self.value = os.system("../autoinstall/script/04-run-script.expect -- --image test-update.img --script ./tests/run_posix_tests")
	self.assertEqual(self.value,0)

if __name__ == '__main__':
    unittest.main(testRunner=xmlrunner.XMLTestRunner(output='test-reports'))
