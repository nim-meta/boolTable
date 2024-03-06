
# boolTable

A Nim's Macro library

generates code to print bool truth table.

> Macro-based means it can even be used at nim VM!

## the easiest
In heady:

```Nim
dumpTable a^b
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
What if want a html output as a string?

Here you are:

```Nim
var s = "<ul>\n<li>"
strTable s, a^b, sep=" ", endl="</li>\n<li>"
s.setLen s.len-4
s.add "</ul>"
echo s
```


