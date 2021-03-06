#!/usr/bin/env python2.7
#
# Alternative to the run shell script that formats the output
# in a machine redeable form (xml unit test) format.
#

import os
import unittest
import xmlrunner

# [ "test name", "command to run" ]
tests = [
	["01","test1"],
	["02","test2"],
# disabled on 11 2012 by keesj
#	["03","test3"],
	["04","test4"],
	["05","test5"],
	["06","test6"],
	["07","test7"],
	["08","test8"],
	["09","test9"],
	["10","test10"],
	["11","test11"],
	["12","test12"],
	["13","test13"],
	["14","test14"],
	["15","test15"],
	["16","test16"],
	["17","test17"],
	["18","test18"],
	["19","test19"],
	["20","test20"],
	["21","test21"],
	["22","test22"],
	["23","test23"],
	["24","test24"],
	["25","test25"],
	["26","test26"],
	["27","test27"],
	["28","test28"],
	["29","test29"],
	["30","test30"],
	["31","test31"],
	["32","test32"],
	["33","test33"],
	["34","test34"],
	["35","test35"],
# disabled on 11 2012 by keesj
#	["36","test36"],
	["37","test37"],
	["38","test38"],
	["39","test39"],
	["40","test40"],
	["41","test41"],
# disabled on 11 2012 by keesj
#	["42","test42"],
	["43","test43"],
	["44","test44"],
	["45","test45"],
	["46","test46"],
	["47","test47"],
	["48","test48"],
	["49","test49"],
	["50","test50"],
	["51","test51"],
	["52","test52"],
	["53","test53"],
	["54","test54"],
	["55","test55"],
	["56","test56"],
	["57","test57"],
	["58","test58"],
	["59","test59"],
	["60","test60"],
	["61","test61"],
	["62","test62"],
	["63","test63 `pwd`/mod"],
	["64","test64"],
  	["65","test65"],
	["66","test66"],
	["67","test67"],
	["68","test68"],
	["69","testsh1.sh"],
	["70","testsh2.sh"],
	["71","testinterp.sh"],

  ]

class PosixTests(unittest.TestCase):
    def setUp(self):
	if os.geteuid() == 0:
		os.system("chown root  test11 test33 test43 test44 test46 test56 test60 test61 test65")
		os.system("chmod 4755  test11 test33 test43 test44 test46 test56 test60 test61 test65")
        os.system("rm -rf DIR*")

def test_generator(a, b):
    def test(self):
	if os.geteuid() == 0:
        	value = os.system('su - bin -c "cd `pwd`; ./%s >>/tmp/k"' % b)
	else:
        	value = os.system('./%s >>/tmp/k' % b)
        self.assertEqual(value,0)
    return test

if __name__ == '__main__':
    if os.geteuid() == 0:
       	os.system('chown bin .')
    for t in tests:
        test_name = 'test_%s' % t[0]
        test = test_generator(t[0], t[1])
        setattr(PosixTests, test_name, test)
    #unittest.main()
    unittest.main(testRunner=xmlrunner.XMLTestRunner(output='test-reports'))
