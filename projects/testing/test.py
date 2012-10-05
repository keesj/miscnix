#!/usr/bin/env python
import random
import os
import unittest
import xmlrunner

class BasicTests(unittest.TestCase):

    def test_base_image_boots(self):
	value = os.system("./tests/device_boots --image test.img")
	self.assertEqual(value,0)

    def test_update_world(self):
	value = os.system("../autoinstall/script/04-run-script.expect -- --image test.img --script ./tests/update_world")
	self.assertEqual(value,0)

    def test_updated_image_boots(self):
	value = os.system("./tests/device_boots --image test.img")
	self.assertEqual(value,0)

    def test_run_posix_tests(self):
	value = os.system("../autoinstall/script/04-run-script.expect -- --image test.img --script ./tests/run_posix_tests")
	self.assertEqual(value,0)

if __name__ == '__main__':
    os.system("rm -rf test.img")
    os.system("cp /opt/data/test.img test.img")
    os.system("rm -rf test-reports");
    os.system("mkdir test-reports");
    unittest.main(testRunner=xmlrunner.XMLTestRunner(output='test-reports'))
