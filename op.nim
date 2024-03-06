##[ bool operators
 
Write expressions in *pure Nim* syntax, like `echo true -> false`
 
There are some utils about calcuate truth tables. 
for example,
```Nim
dumpTable p^q -> r
```
See docuement of `dumpTable <#dumpTable.m%2Cuntyped>`_ for details and demo output.

.. warning:: `¬`, when used as prefix, must be followed by a space, e.g. `¬ true`.\
    `¬` has the lowest priority, e.g. `¬ a^b` means ¬(a^b).\
    please use `(¬ expr)` or `¬(expr)` instead
    
.. warning:: `→` and `↔` are not in `Unicode Operator`_ lists, so cannot be used as infix operators
    
.. _Unicode Operator: https://nim-lang.org/docs/manual.html#lexical-analysis-unicode-operators

]##

template `~`  *(p):  bool = not p        ## ascii alias for `¬ <#¬.t>`_
template `||` *(p,q):bool = p or q       ## ascii alias for `∨ <#∨.t%2C%2C>`_
template `^`  *(p,q):bool = p and q      ## ascii alias for `∧ <#∧.t%2C%2C>`_
template `->` *(p,q):bool = (not p) or q ## ascii alias for `→ <#→.t%2C%2C>`_
template `<->`*(p,q):bool = (p->q)^(q->p)## ascii alias for `↔ <#↔.t%2C%2C>`_


template `¬`*(p):    bool = not p       ## U+00AC  `tex: \neg`
template `∨`*(p,q):  bool = p or q      ## U+2228  `tex: \lor or \vee`
template `∧`*(p,q):  bool = p and q     ## U+2227  `tex: \and or \wedge`
template `→`*(p,q):  bool = ¬ p ∨ q     ## U+2192  `tex: \to  or \rightarrow`
template `↔`*(p,q):  bool = (p→q)∧(q→p) ## U+2194  `tex: \leftrightarrow`

import std/macros
import std/critbits

const
  Sep* = "\t" ## seperator in table
  Endl* = "\n"

macro writeTableVars*(target: untyped, expr, vars: untyped, 
    sep: static string = Sep, endl: static string = Endl) =
  ## `target` shall be a callable that accepts `varargs[string]`
  template forLoop(v, iterBody): NimNode =
    nnkForStmt.newTree(
      v, nnkBracket.newNimNode.add(newLit(false),newLit(true)), # for `v` in [false, true]
      iterBody
    )
  template asInt(b): NimNode =
    newCall(ident"$", newCall(ident"int", b))
  const varsKinds = {nnkBracket, nnkTupleConstr, nnkCurly}
  if vars.kind notin varsKinds:
    error "`vars` is of kind " & $vars.kind & 
      ", but expect one of " & $varsKinds
  result = newNimNode(nnkStmtList)
  
  var headerPri = newNimNode(nnkCall).add ident"echo"
  for v in vars:
    headerPri.add newLit($v), newLit(sep)
  headerPri.add expr.toStrLit
  result.add headerPri
  
  var itemPri =
    if target.kind in {nnkCall, nnkCommand}: target
    else: nnkCall.newTree target
  for v in vars:
    itemPri.add v.asInt, newLit(sep)
  itemPri.add expr.asInt
  if endl!="": itemPri.add newLit(endl)
  
  var iterBody = itemPri
  for i in countdown(vars.len-1,0):
    let v = vars[i]
    iterBody = forLoop(v, iterBody)
  result.add iterBody

macro dumpTableVars*(expr: untyped, vars: untyped, sep: static string=Sep) =
  ## only treat identifiers in `vars` as variables to list (others as constants)
  ## `vars` must be in one of set/array/tuple literals
  runnableExamples:
    dumpTableVars(b -> a, [a,b])
    
    echo "\n------------------\n"
    from std/sugar import dump
    var v: bool
    dump v
    dumpTableVars(b ∨ a ∧ v, [a,b])
  quote do:
    writeTableVars(echo, `expr`, `vars`, sep=`sep`, endl="")

proc collectVars(res: var CritBitTree[void], expr: NimNode) =
  template chkAdd(e: NimNode) =
      let s = $e
      if s[0] in {'a'..'z', 'A'..'Z'}:
        res.incl s
  if expr.kind == nnkIdent:
    chkAdd expr
    return
  for e in expr:
    case e.kind
    of nnkIdent:
      chkAdd e
    of nnkPrefix:
      collectVars(res, e[1])
    of nnkInfix:
      for i in [1,2]:
        collectVars(res, e[i])
    of nnkCommand, nnkCall:
      if e.eqIdent"¬" and e.kind == nnkCommand:
        warning "`¬` has the lowest priority, " &
          "e.g. `¬ a^b` means ¬(a^b). please use (¬ expr) or ¬(expr) instead"
      for i,v in e:
        if i==0: continue
        collectVars(res, v)
    else: discard

proc collectVars(expr: NimNode): CritBitTree[void] = collectVars(result, expr)

macro writeTable*(target: untyped, expr: untyped, 
    sep: static string = Sep, endl: static string = Endl) =
  ## `target` shall be a callable that accepts `varargs[string]`
  var call = nnkCall.newTree ident"writeTableVars"
  call.add target, expr
  
  let idents = collectVars(expr)

  var collects = newNimNode nnkBracket
  for s in idents:
    collects.add ident s
  call.add collects
  call.add nnkExprEqExpr.newTree(
    ident"sep", newLit(sep)
  )
  call.add nnkExprEqExpr.newTree(
    ident"endl", newLit(endl)
  )
  call

macro dumpTable*(expr: untyped, sep: static string = Sep) =
  runnableExamples:
    dumpTable a ∧ (¬ b) ∨ c
    echo "\n-----------------\n"
    dumpTable ~foo 
    # if you type `foo || Foo`, there are two variables,
    #  while foo <=> foO, as in Nim 
    #  only the first alpha's case matters
    
    # the default sep is "\t"
    #
    # outputs:
    #[
    a       b       c       a ∧ (¬ b) ∨ c
    0       0       0       0
    0       0       1       1
    0       1       0       0
    0       1       1       1
    1       0       0       1
    1       0       1       1
    1       1       0       0
    1       1       1       1
    
    -----------------
    
    foo     ~foo
    0       1
    1       0
    ]#
  quote do:
    writeTable(echo, `expr`, sep=`sep`, endl="")

when isMainModule: # some tests
  from std/sugar import dump
  dump: ¬ true
  dump: true || false
  
  
  echo "\n------------------"
  dumpTable (¬ a) ∧ (¬ b) ∨ c #~b ∨ ~c || a

  echo "\n------------------"
  var v: bool
  dump v
  dumpTableVars(b ∨ a ∧ v, [a,b])
  