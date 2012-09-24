#!/usr/bin/env python
#
# Alternative to the run shell script that formats the output
# in a machine redeable form (xml unit test) format.
#

import os
import unittest
import xmlrunner

# [ "test name", "command to run" ]
tests = [
	["1","test1"],
	["2","test2"],
	["3","test3"],
	["4","test4"],
	["5","test5"],
	["6","test6"],
	["7","test7"],
	["8","test8"],
	["9","test9"],
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
	["36","test36"],
	["37","test37"],
	["38","test38"],
	["39","test39"],
	["40","test40"],
	["41","test41"],
	["42","test42"],
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
#	["63","test63"],
	["sh1.sh","testsh1.sh"],
	["sh2.sh","testsh2.sh"],
	["interp.sh","testinterp.sh"],
  ]

class TestSequense(unittest.TestCase):
    def setUp(self):
        os.system("rm -rf DIR*")

def test_generator(a, b):
    def test(self):
	if os.geteuid() == 0:
        	value = os.system('su - bin -c "cd `pwd`; ./%s >>k"' % b)
	else:
        	value = os.system('./%s >>k' % b)
        self.assertEqual(value,0)
    return test

if __name__ == '__main__':
    for t in tests:
        test_name = 'test_%s' % t[0]
        test = test_generator(t[0], t[1])
        setattr(TestSequense, test_name, test)
    unittest.main()
    #unittest.main(testRunner=xmlrunner.XMLTestRunner(output='test-reports'))
