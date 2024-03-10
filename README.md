
# boolTable

A Nim's Macro library

generates code to print bool truth table.

> Macro-based means it can even be used at nim VM!

## the easiest
In heady:

```Nim
dumpTable a^b # or `a ∧ b` (Unicode alternative)
```

Output:
```
a       b       a ^ b
0       0       0
0       1       0
1       0       0
1       1       1
```

## advanced

### make up
What if want a html output as a string?

Here you are:

```Nim
var s = "<ul>\n<li>"
strTable s, a^b, sep=" ", endl="</li>\n<li>"
s.setLen s.len-4
s.add "</ul>"
echo s
```

### Unicode op

```Nim
dumpTable: a ∧ (¬ b) ∨ c
```

Output:

```
a       b       c       a ∧ (¬ b) ∨ c
0       0       0       0
0       0       1       1
0       1       0       0
0       1       1       1
1       0       0       1
1       0       1       1
1       1       0       0
1       1       1       1
```

### Nim's op

As it's in Nim, you're free to use every Nim expression.

> As it's done at compilation, nothing about secure problems

```Nim
var cnt = 0
proc foo(a: bool): bool =
  cnt.inc
  a
dumpTableVars ¬ foo(a), [a]
echo cnt == 2
```
