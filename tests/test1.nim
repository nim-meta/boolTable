# This is just an example to get you started. You may wish to put all of your
# tests into a single file, or separate them into multiple `test1`, `test2`
# etc. files (better names are recommended, just make sure the name starts with
# the letter 't').
#
# To run these tests, simply execute `nimble test`.

import unittest

import boolTable

const Sep = "       " # powershell or bash render a '\t' as 7 spaces

test "strTable":
  check:
    tableStr(a^b, sep=Sep) == """
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
  check:
    tableStrVars(¬ foo(a), [a], sep=Sep) == """
a       ¬ foo(a)
0       1
1       0
"""
  check cnt == 2

test "multi op":
  check:
    tableStr(a->(b->c), sep=Sep) == """
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

test "strlit as arg":
  check tableStr("a^b") == tableStr a^b
  check tableStrVars("~a", [a]) == tableStrVars(~a, [a])