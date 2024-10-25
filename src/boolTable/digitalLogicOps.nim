


template `+`*(p, q: bool): bool = p or  q
template `*`*(p, q: bool): bool = p and q
template `×`*(p, q: bool): bool = p and q  ## U+00D7 `tex: \times` logical and
template `⊕`*(p, q: bool): bool = p xor q  ## U+2295 `tex: \oplus` logical xor
template `‾`*(p: bool): bool =
  ## U+203E `tex: \overline`
  ## 
  ## .. hint::
  ##   unfortunately U+0304 `tex: \bar`: Combining Macron
  ##   cannot be used as that's not a operator,
  ##   so expression like `̄a` cannot be written.
  runnableExamples:
      let a = false
      assert a+true
  not p
