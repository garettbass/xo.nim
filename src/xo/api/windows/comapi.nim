import macros
import winapi
export winapi

when defined(vcc):
  {.link:"uuid.lib".}
else:
  {.passL:"-luuid".}

type ComApi*[Vtbl] = object
  lpVtbl: ptr Vtbl

macro comapi*(head: untyped, body: untyped): untyped =
  ##
  ## This macro rewrites input like this:
  ##
  ## .. code-block:: nim
  ##  comapi Base:
  ##    proc foo(i:int): HRESULT
  ##
  ## .. code-block:: nim
  ##  comapi Derived of Base:
  ##    proc foo(i:int): HRESULT
  ##    proc bar(): uint32
  ##
  ## To produce type output like this:
  ##
  ## .. code-block:: nim
  ##  type
  ##    Base* = ComApi[BaseVtbl]
  ##    BaseVtbl = object
  ##      foo: proc (this: ptr Base; i:int): HRESULT {.stdcall.}
  ##  proc foo*(this: ptr Base; i:int): HRESULT =
  ##    this.lpVtbl.foo(this, riid, ppvObject)
  ##
  ## .. code-block:: nim
  ##  type
  ##    Derived* = ComApi[DerivedVtbl]
  ##    DerivedVtbl = object
  ##      foo: proc (this: ptr Derived; i:int): HRESULT {.stdcall.}
  ##      bar: proc (this: ptr Derived): uint32 {.stdcall.}
  ##  proc foo*(this: ptr Derived; i:int): HRESULT =
  ##    this.lpVtbl.foo(this, riid, ppvObject)
  ##  proc bar*(this: ptr Derived): HRESULT =
  ##    this.lpVtbl.bar(this)
  ##  converter asBase*(this: ptr Derived): ptr Base =
  ##    cast[ptr Base](this)
  ##
  when isMainModule:
    echo "----"
    echo head.treeRepr
    echo "----"
    echo body.treeRepr
  head.expectKind({nnkIdent, nnkInfix})
  body.expectKind(nnkStmtList)
  proc getClassIdent(identOrInfix: NimNode): NimNode =
    case identOrInfix.kind
      of nnkIdent: return identOrInfix
      of nnkInfix:
        let ident = identOrInfix[1]
        ident.expectKind(nnkIdent)
        return ident
      else: identOrInfix.expectKind({nnkIdent, nnkInfix})
  proc getBaseClassIdent(identOrInfix: NimNode): NimNode =
    case identOrInfix.kind
      of nnkIdent: return nil
      of nnkInfix:
        let ident = identOrInfix[2]
        ident.expectKind(nnkIdent)
        return ident
      else: identOrInfix.expectKind({nnkIdent, nnkInfix})
  let empty = newEmptyNode()
  let classIdent = head.getClassIdent()
  let classPtrTy = nnkPtrTy.newTree(classIdent)
  let baseClassIdent = head.getBaseClassIdent()
  let vtableIdent = newIdentNode(classIdent.repr & "Vtbl")
  let vtableRecList = newNimNode(nnkRecList)
  let asteriskIdent = newIdentNode("*")
  result = nnkStmtList.newTree(
    nnkTypeSection.newTree(
      nnkTypeDef.newTree(
        nnkPostfix.newTree(asteriskIdent, classIdent),
        empty,
        nnkBracketExpr.newTree(newIdentNode("ComApi"), vtableIdent),
      ),
      nnkTypeDef.newTree(
        vtableIdent,
        empty,
        nnkObjectTy.newTree(empty, empty, vtableRecList),
      ),
    )
  )
  let thisIdent = newIdentNode("this")
  block: # add procs to vtableRecList
    let stdcallPragma = nnkPragma.newTree(newIdentNode("stdcall"))
    for procDef in body:
      procDef.expectKind(nnkProcDef)
      let procIdent = procDef[0]
      procIdent.expectKind(nnkIdent)
      let procFormalParams = procDef[3]
      procFormalParams.expectKind(nnkFormalParams)
      let vtableFormalParams = nnkFormalParams.newTree(
        procFormalParams[0],
        nnkIdentDefs.newTree(
          thisIdent,
          classPtrTy,
          empty,
        )
      )
      for procFormalParam in procFormalParams[1..<procFormalParams.len]:
        vtableFormalParams.add(procFormalParam)
      vtableRecList.add(
        nnkIdentDefs.newTree(
          procIdent,
          nnkProcTy.newTree(vtableFormalParams, stdcallPragma),
          empty,
        )
      )
  block: # add procs to invoke vtable methods
    let lpVtblIdent = newIdentNode("lpVtbl")
    for procDef in body:
      procDef.expectKind(nnkProcDef)
      let procIdent = procDef[0]
      procIdent.expectKind(nnkIdent)
      let procFormalParams = procDef[3]
      procFormalParams.expectKind(nnkFormalParams)
      let formalParams = nnkFormalParams.newTree(
        procFormalParams[0],
        nnkIdentDefs.newTree(
          thisIdent,
          classPtrTy,
          empty,
        )
      )
      let call = nnkCall.newTree(
        nnkDotExpr.newTree(
          nnkDotExpr.newTree(thisIdent, lpVtblIdent),
          procIdent,
        ),
        thisIdent,
      )
      for procFormalParam in procFormalParams[1..<procFormalParams.len]:
        formalParams.add(procFormalParam)
        for paramIdent in procFormalParam[0..<procFormalParam.len-2]:
          call.add(paramIdent)
      result.add(
        nnkProcDef.newTree(
          nnkPostfix.newTree(asteriskIdent, procIdent),
          empty,
          empty,
          formalParams,
          empty,
          empty,
          nnkStmtList.newTree(call),
        )
      )
  if baseClassIdent != nil: # add converter to base class
    let baseClassPtrTy = nnkPtrTy.newTree(baseClassIdent)
    result.add(
      nnkConverterDef.newTree(
        nnkPostfix.newTree(
          asteriskIdent,
          newIdentNode("as" & baseClassIdent.repr),
        ),
        empty,
        empty,
        nnkFormalParams.newTree(
          baseClassPtrTy,
          nnkIdentDefs.newTree(
            thisIdent,
            classPtrTy,
            empty,
          ),
        ),
        empty,
        empty,
        nnkStmtList.newTree(
          nnkCast.newTree(
            baseClassPtrTy,
            thisIdent,
          ),
        ),
      )
    )
  when isMainModule:
    echo "----"
    echo result.treeRepr

# IUnknown ---------------------------------------------------------------------

comapi IUnknown:
  proc QueryInterface(riid: ptr IID; ppvObject: ptr pointer): HRESULT
  proc AddRef(): uint32
  proc Release(): uint32

# AsyncIUnknown ----------------------------------------------------------------

comapi AsyncIUnknown of IUnknown:
  proc QueryInterface(riid: ptr IID; ppvObject: ptr pointer): HRESULT
  proc AddRef(): uint32
  proc Release(): uint32
  proc BeginQueryInterface(riid: ptr IID): HRESULT
  proc FinishQueryInterface(ppvObject: ptr pointer): HRESULT
  proc BeginAddRef(): HRESULT
  proc FinishAddRef(): uint32
  proc BeginRelease(): HRESULT
  proc FinishRelease(): uint32

# IClassFactory ----------------------------------------------------------------

comapi IClassFactory of IUnknown:
  proc QueryInterface(riid: ptr IID; ppvObject: ptr pointer): HRESULT
  proc AddRef(): uint32
  proc Release(): uint32
  proc CreateInstance(pUnkOuter: ptr IUnknown; riid: ptr IID; ppvObject: ptr pointer): HRESULT
  proc LockServer(fLock: BOOL): HRESULT

#-------------------------------------------------------------------------------

when isMainModule:
  dumpTree:
    type
      Base* = ComApi[BaseVtbl]
      BaseVtbl = object
        foo: proc (this: ptr Base; riid: ptr IID; ppvObject: ptr pointer): HRESULT {.stdcall.}
    proc foo*(this: ptr Base; riid: ptr IID; ppvObject: ptr pointer): HRESULT =
      this.lpVtbl.foo(this, riid, ppvObject)

  static:
    echo "\n----\n"

  dumpTree:
    type
      Derived* = ComApi[DerivedVtbl]
      DerivedVtbl = object
        foo: proc (this: ptr Derived; riid: ptr IID; ppvObject: ptr pointer): HRESULT {.stdcall.}
        bar: proc (this: ptr Derived): uint32 {.stdcall.}
    proc foo*(this: ptr Derived; riid: ptr IID; ppvObject: ptr pointer): HRESULT =
      this.lpVtbl.foo(this, riid, ppvObject)
    proc bar*(this: ptr Derived): HRESULT =
      this.lpVtbl.bar(this)
    converter toBase*(this: ptr Derived): ptr Base =
      cast[ptr Base](this)

  static:
    echo "\n----\n"

  comapi Base:
    proc foo(riid: ptr IID; ppvObject: ptr pointer): HRESULT

  comapi Derived of Base:
    proc foo(riid: ptr IID; ppvObject: ptr pointer): HRESULT
    proc bar(): uint32
