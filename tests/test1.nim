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

test "Nim op":
  var cnt = 0
  proc foo(a: bool): bool =
    cnt.inc
    a
  var s: string
  strTableVars s, ¬ foo(a), [a], sep = "       "
  check s == """
a       ¬ foo(a)
0       1
1       0
"""
  check cnt == 2

test "multi op":
  var s: string
  strTable(s, a->(b->c), sep="       ")
  check s == """
a       b       c       a -> (b -> c)
0       0       0       1
0       0       1       1
0       1       0       1
0       1       1       1
1       0       0       1
1       0       1       1
1       1       0       0
1       1       1       1
"""
