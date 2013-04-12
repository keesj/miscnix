#!/usr/bin/env python
import random
import os
import unittest
import xmlrunner
from time import sleep


class BasicTests(unittest.TestCase):
    def setUp(self):
	self.port = 8989
        while os.system("netstat -na | grep LIST | grep tcp | grep %s 2>/dev/null" % self.port) == 0:
            print "port %s taken trying next " % self.port
	    self.port += 1
	    sleep(1)

    def test_01_base_image_boots(self):
	value = os.system("./tests/device_boots --image test.img -p %s" % self.port)
	self.assertEqual(value,0)

    def test_02_update_world(self):
	value = os.system("../autoinstall/script/04-run-script.expect -- --image test.img --script ./tests/update_world -p %s" % self.port)
	self.assertEqual(value,0)

    def test_03_updated_image_boots(self):
	value = os.system("./tests/device_boots --image test.img -p %s" % self.port)
	self.assertEqual(value,0)

    def test_04_run_posix_tests(self):
	value = os.system("../autoinstall/script/04-run-script.expect -- --image test.img --script ./tests/run_posix_tests -p %s" % self.port)
	self.assertEqual(value,0)

    def test_05_create_iso(self):
	value = os.system("../autoinstall/script/04-run-script.expect -- --image test.img --script ./tests/create_iso -p %s" % self.port)
	self.assertEqual(value,0)

    def test_06_install_iso(self):
	value = os.system("./tests/install_iso -p %s" % self.port)
	self.assertEqual(value,0)

    def test_07_installed_image_boots(self):
	value = os.system("./tests/device_boots --image install_test.img -p %s" % self.port )
	self.assertEqual(value,0)

if __name__ == '__main__':
    os.system("rm -rf test.img")
    os.system("cp /apts/data/test.img test.img")
    os.system("rm -rf test-reports");
    os.system("mkdir test-reports");
    unittest.main(testRunner=xmlrunner.XMLTestRunner(output='test-reports'))
