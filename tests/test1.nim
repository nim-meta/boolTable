# This is just an example to get you started. You may wish to put all of your
# tests into a single file, or separate them into multiple `test1`, `test2`
# etc. files (better names are recommended, just make sure the name starts with
# the letter 't').
#
# To run these tests, simply execute `nimble test`.

import unittest

import boolTable
test "strTable":
  var s: string
  strTable s, a^b, sep="       "
  check  s == """
a       b       a ^ b
0       0       0
0       1       0
1       0       0
1       1       1
"""
