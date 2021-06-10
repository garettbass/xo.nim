import strformat
import ../src/api/ptrutils

type Destructible = object
  id : int

proc `=destroy`(d:var Destructible)=
  echo &"`=destroy`({d.id=})"
  d.id = 0

proc `=copy`(d:var Destructible, s:Destructible) {.error.}

proc newDestructible(id:int):ref Destructible=
  new result
  result.id = id

(proc =
  let d = newDestructible(id=1)
  echo &"{d.id=}"
)()