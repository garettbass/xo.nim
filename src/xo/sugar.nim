import std/sugar
export sugar

#===============================================================================

template `?`*(predicate:bool, results:(untyped,untyped)):untyped =
  ## Shorthand for inline if/else.
  runnableExamples:
    let a = (1 == 2) ? ("true", "false")
    assert a == "false"
  if predicate: results[0] else: results[1]

#===============================================================================

