import glm
import macros
import sets
import strformat
import strutils
import tables

type
  Bool*    = bool
  Vec2b*   = glm.Vec2b
  Vec3b*   = glm.Vec3b
  Vec4b*   = glm.Vec4b
  Float32* = float32
  Vec2f*   = glm.Vec2f
  Vec3f*   = glm.Vec3f
  Vec4f*   = glm.Vec4f
  Int32*   = int32
  Vec2i*   = glm.Vec2i
  Vec3i*   = glm.Vec3i
  Vec4i*   = glm.Vec4i
  UInt32*  = uint32
  Vec2ui*  = glm.Vec2ui
  Vec3ui*  = glm.Vec3ui
  Vec4ui*  = glm.Vec4ui
  Mat4f*   = glm.Mat4f

const
  MAX_UNIFORMS* = 4
  MAX_UNIFORM_FIELDS* = 16
  MAX_ATTRIBUTES* = 16

type Comparison* {.pure.} = enum
  Never
  Less
  Equal
  LessEqual
  Greater
  NotEqual
  GreaterEqual
  Always

type Cull* {.pure.} = enum
  None
  Back
  Front

type Winding* {.pure.} = enum
  Left
  Right

type BlendFactor* {.pure.} = enum
  Zero
  One
  SrcColor
  OneMinusSrcColor
  SrcAlpha
  OneMinusSrcAlpha
  DstColor
  OneMinusDstColor
  DstAlpha
  OneMinusDstAlpha
  SrcAlphaSaturated
  BlendColor
  OneMinusBlendColor
  BlendAlpha
  OneMinusBlendAlpha

type BlendOp* {.pure.} = enum
  Add
  Sub
  Rsub

type StencilOp* {.pure.} = enum
  Keep
  Clear
  Replace
  IncrWrap
  DecrWrap
  IncrClamp
  DecrClamp
  Invert

type BlendFunction* = object
  op*           :BlendOp
  sourceFactor* :BlendFactor
  targetFactor* :BlendFactor

type BlendState* = object
  enabled* :bool
  color*   :BlendFunction
  alpha*   :BlendFunction

type DepthState* = object
  write*         :bool
  compare*       :Comparison
  bias*          :float32
  biasClamp*     :float32
  biasSlopeScale*:float32

type StencilFace* = object
  compare*     :Comparison
  depthFailOp* :StencilOp
  failOp*      :StencilOp
  passOp*      :StencilOp

type StencilState* = object
  enabled*   :bool
  readMask*  :uint8
  writeMask* :uint8
  refValue*  :uint8
  front*     :StencilFace
  back*      :StencilFace

type TypeId* {.pure.} = enum
  Void
  Float32
  Vec2f
  Vec3f
  Vec4f
  Mat4f

converter toTypeId*(name:string):TypeId =
  case name.toLower
    of "float32": TypeId.Float32
    of "vec2f":   TypeId.Vec2f
    of "vec3f":   TypeId.Vec3f
    of "vec4f":   TypeId.Vec4f
    of "mat4f":   TypeId.Mat4f
    of "mat4x4f": TypeId.Mat4f
    else:         TypeId.Void

proc size*(typeId:TypeId):uint32 =
  case typeId
    of TypeId.Void:    0u32
    of TypeId.Float32: cast[uint32](sizeof(Float32))
    of TypeId.Vec2f:   cast[uint32](sizeof(Vec2f))
    of TypeId.Vec3f:   cast[uint32](sizeof(Vec3f))
    of TypeId.Vec4f:   cast[uint32](sizeof(Vec4f))
    of TypeId.Mat4f:   cast[uint32](sizeof(Mat4f))

proc isValidUniformFieldTypeId*(typeId:TypeId):bool =
  case typeId
    of TypeId.Float32: true
    of TypeId.Vec2f:   true
    of TypeId.Vec3f:   true
    of TypeId.Vec4f:   true
    of TypeId.Mat4f:   true
    else: false

proc isValidAttributeTypeId*(typeId:TypeId):bool =
  case typeId
    of TypeId.Float32: true
    of TypeId.Vec2f:   true
    of TypeId.Vec3f:   true
    of TypeId.Vec4f:   true
    else: false

type UniformField* = object
  typeId:TypeId
  name*:string
  binding*:string
  arrayLength*:uint32

proc size*(field:UniformField):uint32 =
  field.typeId.size

type Uniform* = object
  name*:string
  binding*:string
  fields*:array[MAX_UNIFORM_FIELDS,UniformField]

proc size*(uniform:Uniform):uint32 =
  for field in uniform.fields:
    result += field.size

type Attribute* = object
  typeId:TypeId
  name*:string
  binding*:string

proc size*(attribute:Attribute):uint32 =
  attribute.typeId.size

type Language* = enum
  None
  Glsl
  Hlsl
  Metal

type Stage* = object
  source*:string
  uniforms*:array[MAX_UNIFORMS,Uniform]
  attributes*:array[MAX_ATTRIBUTES,Attribute]

type StageId* {.pure.} = enum
  Vertex
  Fragment

type Shader* = object
  blend*:BlendState
  depth*:DepthState
  stencil*:StencilState
  language*:Language
  vert*:Stage
  frag*:Stage

template stage(shader:Shader, stageId:StageId):ptr Stage =
  case stageId
    of StageId.Vertex:
      addr(shader.vert)
    of StageId.Fragment:
      addr(shader.frag)

#-------------------------------------------------------------------------------

macro shader*(n: typed) =
  n.expectKind(nnkStmtList)
  block: # write AST to file for debugging
    let astFile = n.lineInfoObj.filename & ".ast"
    writeFile(astFile, n.treeRepr)

  proc recList(objectTy:NimNode):NimNode =
    objectTy.expectKind(nnkObjectTy)
    let recList = objectTy[2]
    recList.expectKind(nnkRecList)
    recList

  iterator fields(objectTy:NimNode):NimNode =
    let recList = objectTy.recList
    for rec in recList:
      case rec.kind
        of nnkIdentDefs:
          for i in 0..<rec.len-2:
            yield rec[i]
        of nnkSym:
          yield rec
        else: discard

  iterator varSyms(node:NimNode):NimNode =
    case node.kind:
      of nnkVarSection:
        let varSection = node
        for identDefs in varSection:
          identDefs.expectKind(nnkIdentDefs)
          for node in identDefs[0..<identDefs.len-2]:
            yield node
      of nnkIdentDefs:
        let identDefs = node
        for node in identDefs[0..<identDefs.len-2]:
          yield node
      else: error(&"cannot find variables in {node.kind}", node)

  template typeInst(node:NimNode):NimNode = node.getTypeInst
  template typeImpl(node:NimNode):NimNode = node.getTypeImpl

  proc resultTypeSym(procDef:NimNode):NimNode =
    for param in procDef.params:
      case param.kind:
        of nnkEmpty:
          return nil
        of nnkSym:
          let sym = param
          return sym
        of nnkBracketExpr:
          let bracketExpr = param
          let sym = bracketExpr[0]
          return sym
        else:
          echo procDef.repr
          echo param.treeRepr
          param.expectKind({nnkEmpty,nnkSym})

  proc resultTypeInst(procDef:NimNode):NimNode =
    for param in procDef.params:
      case param.kind:
        of nnkEmpty:
          return nil
        of nnkSym:
          return param.typeInst
        of nnkBracketExpr:
          return param[0].typeInst
        else:
          echo procDef.repr
          echo param.treeRepr
          param.expectKind({nnkEmpty,nnkSym})

  iterator paramSyms(procDef:NimNode):NimNode =
    for param in procDef.params:
      case param.kind:
        of nnkEmpty:
          continue
        of nnkSym:
          continue
        of nnkIdentDefs:
          for node in param[0..<param.len-2]:
            case node.kind:
              of nnkEmpty:
                continue
              of nnkSym:
                yield node
              else: node.expectKind({nnkEmpty,nnkSym})
        else: param.expectKind({nnkEmpty,nnkSym})

  let shaderTypeNames = {
    "int"     :"",
    "int32"   :"int",
    "int64"   :"",
    "uint"    :"",
    "uint32"  :"uint",
    "uint64"  :"",
    "float32" :"float",
    "float64" :"",
    "Vec2b"   :"bvec2",
    "Vec3b"   :"bvec3",
    "Vec4b"   :"bvec4",
    "Vec2f"   :"vec2",
    "Vec3f"   :"vec3",
    "Vec4f"   :"vec4",
    "Vec2i"   :"ivec2",
    "Vec3i"   :"ivec3",
    "Vec4i"   :"ivec4",
    "Vec2ui"  :"uvec2",
    "Vec3ui"  :"uvec3",
    "Vec4ui"  :"uvec4",
    "Mat2f"   :"mat2",
    "Mat3f"   :"mat3",
    "Mat4f"   :"mat4",
    "Mat2x2f" :"mat2x2",
    "Mat2x3f" :"mat2x3",
    "Mat2x4f" :"mat2x4",
    "Mat3x2f" :"mat3x2",
    "Mat3x3f" :"mat3x3",
    "Mat3x4f" :"mat3x4",
    "Mat4x2f" :"mat4x2",
    "Mat4x3f" :"mat4x3",
    "Mat4x4f" :"mat4x4",
  }.toTable()

  proc getShaderTypeName(typeName:string):string =
    result = typeName
    if shaderTypeNames.contains(typeName):
      result = shaderTypeNames[typeName]

  proc requireShaderTypeName(typeInst:NimNode):string =
    let typeName = typeInst.repr
    if shaderTypeNames.contains(typeName):
      result = shaderTypeNames[typeName]
    if result == "":
      error(&"unsupported type, \"{typeName}\", in shader", typeInst)

  var shaderGlobalNames:HashSet[string]

  proc add[T](s:var HashSet[T], key:T):bool =
    if s.contains(key):
      result = false
    else:
      s.incl(key)
      result = true

  proc addGlslType(glsl:var string, typeInst:NimNode) =
    let typeName = typeInst.repr
    if (shaderTypeNames.contains(typeName)):
        return
    if shaderGlobalNames.add(typeName):
      # echo &"addGlslType(\"{typeInst.repr}\")"
      let typeImpl = typeInst.typeImpl
      case typeImpl.kind
        of nnkObjectTy:
          for field in typeImpl.fields:
            let fieldTypeInst = field.typeInst
            glsl.addGlslType(fieldTypeInst)
          glsl &= &"\nstruct {typeName} " & "{"
          for field in typeImpl.fields:
            let fieldName = field.repr
            let fieldTypeInst = field.typeInst
            let shaderTypeName = requireShaderTypeName(fieldTypeInst)
            glsl &= &"\n  {shaderTypeName} {fieldName};"
          glsl &= "\n};\n"
        else:
          glsl &= "\n/* " & typeName & "\n"
          glsl &= typeImpl.treeRepr
          glsl &= "\n*/\n"

  proc indent(glsl:var string, depth:int) =
    for i in 0..<depth:
      glsl &= "  "

  proc isSwizzleName(procName:string, swizzleChars:string):bool =
    for c in procName:
      if not swizzleChars.contains(c):
        return false
    return true

  proc addGlslParamSeparator(glsl:var string) =
    if not glsl.endsWith("("):
      glsl &= ", "

  proc addGlslParam(glsl:var string, paramName:string) =
    glsl.addGlslParamSeparator()
    glsl &= &"{paramName}"

  proc addGlslFunctionBody(glsl:var string, body:NimNode, depth:int=0) =
    case body.kind
      of nnkCall:
        let call = body
        let procSym = call[0]
        let procName = procSym.repr
        # check for vector swizzle
        if call.len == 2 and procName.len <= 4:
          if (isSwizzleName(procName, "xyzw") or
              isSwizzleName(procName, "rgba")):
            # check for single argument of vector type
            var arg = call[1]
            var argTypeSym = arg.typeInst
            var argTypeName = argTypeSym.repr
            if argTypeName.startsWith("Vec"):
              glsl.addGlslFunctionBody(arg)
              glsl &= "." & procName
              return
        glsl &= procName & "("
        for arg in call[1..<call.len]:
          glsl.addGlslParamSeparator()
          glsl.addGlslFunctionBody(arg)
        glsl &= ")"
      of nnkStmtList:
        let stmtList = body
        for node in stmtList:
          glsl.indent(depth)
          glsl.addGlslFunctionBody(node, depth + 1)
          glsl &= ";\n"
      of nnkDiscardStmt:
        discard
      of nnkAsgn:
        let asgn = body
        let lhs = asgn[0]
        let rhs = asgn[1]
        glsl.addGlslFunctionBody(lhs)
        glsl &= " = "
        glsl.addGlslFunctionBody(rhs)
      of nnkDotExpr:
        let dotExpr = body
        let lhs = dotExpr[0]
        let rhs = dotExpr[1]
        glsl.addGlslFunctionBody(lhs)
        glsl &= "."
        glsl.addGlslFunctionBody(rhs)
      of nnkSym:
        let sym = body
        glsl &= sym.repr
      of nnkIntLit..nnkInt32Lit:
        let intLit = body
        glsl &= $intLit.intVal
      of nnkFloat32Lit:
        let floatLit = body
        glsl &= $floatLit.floatVal
      of nnkFloatLit,nnkFloat64Lit:
        let doubleLit = body
        glsl &= $doubleLit.floatVal & "lf"
      of nnkInfix:
        let infix = body
        let op = infix[0]
        let lhs = infix[1]
        let rhs = infix[2]
        glsl.addGlslFunctionBody(lhs)
        glsl &= " " & op.repr & " "
        glsl.addGlslFunctionBody(rhs)
      else:
        glsl &= "\n/*\n"
        glsl &= body.treeRepr
        glsl &= "\n*/\n"

  proc addGlslFunction(glsl:var string, procDef:NimNode) =
    let procName = procDef[0].repr
    if not shaderGlobalNames.add(procName):
      return
    var resultTypeName = "void"
    var resultTypeInst = procDef.resultTypeInst
    if resultTypeInst != nil:
      resultTypeName = getShaderTypeName(resultTypeInst.repr)
      glsl.addGlslType(resultTypeInst)
    for paramSym in procDef.paramSyms:
      let paramTypeInst = paramSym.typeInst
      glsl.addGlslType(paramTypeInst)
    block: # function signature
      glsl &= &"\n{resultTypeName} {procName}("
      for paramSym in procDef.paramSyms:
        let paramTypeInst = paramSym.typeInst
        let paramTypeName = getShaderTypeName(paramTypeInst.repr)
        let paramName = paramSym.repr
        glsl.addGlslParam(&"{paramTypeName} {paramName}")
      glsl &= ") {"
    block: # function body
      if resultTypeInst != nil:
        glsl &= "\n"
        glsl.indent(depth=1)
        glsl &= &"{resultTypeName} result;"
      var body = procDef.body
      case body.kind:
        of nnkDiscardStmt:
          discard
        of nnkStmtList:
          glsl &= "\n"
          glsl.addGlslFunctionBody(body,depth=1)
        else:
          glsl &= "\n"
          glsl.addGlslFunctionBody(newStmtList(body),depth=1)
      if resultTypeInst != nil:
        glsl.indent(depth=1)
        glsl &= "return result;\n"
    glsl &= "}\n"

  proc entryName(stageId:StageId):string =
    case stageId:
      of StageId.Vertex:
        return "vert"
      of StageId.Fragment:
        return "frag"

  proc inTypeName(stageId:StageId):string =
    case stageId:
      of StageId.Vertex:
        return "Vertex"
      of StageId.Fragment:
        return "Fragment"

  proc outTypeName(stageId:StageId):string =
    case stageId:
      of StageId.Vertex:
        return "Fragment"
      of StageId.Fragment:
        return "Sample"

  var shader:Shader

  proc addGlslMain(glsl:var string, procDef:NimNode, stageId:StageId) =
    let stage = shader.stage(stageId)
    let entryName = stageId.entryName
    let inTypeName = stageId.inTypeName
    let inPrefix = inTypeName.toLower
    let outTypeName = stageId.outTypeName
    let outPrefix = outTypeName.toLower
    let resultTypeInst = procDef.resultTypeInst
    let resultTypeImpl = resultTypeInst.typeImpl
    block: # convert parameters to input attributes
      glsl &= "\n"
      for paramSym in procDef.paramSyms:
        let paramName = paramSym.repr
        let paramTypeInst = paramSym.typeInst
        let paramTypeName = paramTypeInst.repr
        let paramTypeImpl = paramTypeInst.typeImpl
        if (paramTypeName == inTypeName):
          var fieldIndex = -1
          for field in paramTypeImpl.fields:
            fieldIndex += 1
            let fieldTypeInst = field.typeInst
            let fieldTypeName = fieldTypeInst.repr
            let glslTypeName = requireShaderTypeName(fieldTypeInst)
            let fieldName = field.repr
            let attributeName = &"{inPrefix}_{fieldName}"
            if (stageId == StageId.Vertex):
              glsl &= &"layout(location={fieldIndex}) "
            glsl &= &"in {glslTypeName} {attributeName};\n"
            let typeId = fieldTypeName.toTypeId
            if (typeId.isValidAttributeTypeId):
              stage.attributes[fieldIndex].typeId  = typeId
              stage.attributes[fieldIndex].name    = fieldName
              stage.attributes[fieldIndex].binding = attributeName
            else:
              error(&"unsupported attribute type, `{fieldTypeName}`", field)
          continue
        case paramName
          of "vertId","instId":
            if (paramTypeName != "uint32"):
              error($"{paramName} must be of type uint32", paramSym)
          else:
            error(&"unsupported {entryName} parameter, {paramName}", paramSym)
            glsl &= &"\n/*\n{paramTypeImpl.treeRepr}*/\n"
    block: # convert result to output attributes
      glsl &= "\n"
      let resultTypeName = resultTypeInst.repr
      if (resultTypeName != outTypeName):
        error(&"expected return type {outTypeName}", procDef.resultTypeSym)
      for field in resultTypeImpl.fields:
        let fieldTypeInst = field.typeInst
        let attributeTypeName = requireShaderTypeName(fieldTypeInst)
        let fieldName = field.repr
        glsl &= &"out {attributeTypeName} {outPrefix}_{fieldName};\n"
    glsl &= "\nvoid main() {\n"
    block: # assign input attributess
      for paramSym in procDef.paramSyms:
        let paramName = paramSym.repr
        let paramTypeInst = paramSym.typeInst
        let paramTypeName = paramTypeInst.repr
        let paramTypeImpl = paramTypeInst.typeImpl
        if (paramTypeName == inTypeName):
          glsl &= &"  {inTypeName} {paramName};\n"
          for field in paramTypeImpl.fields:
            let fieldName = field.repr
            glsl &= &"  {paramName}.{fieldName} = {inPrefix}_{fieldName};\n"
    block: # invoke stage entry point
      glsl &= &"  {outTypeName} result = {entryName}("
      for paramSym in procDef.paramSyms:
        let paramName = paramSym.repr
        let paramTypeInst = paramSym.typeInst
        let paramTypeName = paramTypeInst.repr
        if (paramTypeName == inTypeName):
          glsl.addGlslParam(paramName)
          continue
        case paramName
          of "vertId":
            glsl.addGlslParam("gl_VertexId")
          of "instId":
            glsl.addGlslParam("gl_InstanceId")
      glsl &= ");\n"
    block: # assign output attributes
      if (stageId == StageId.Vertex):
        for field in resultTypeImpl.fields:
          let fieldName = field.repr
          if (fieldName != "position"):
            error(&"first field in {outTypeName} must be `position`", field)
          glsl &= &"  gl_Position = result.{fieldName};\n"
          break
      for field in resultTypeImpl.fields:
        let fieldName = field.repr
        glsl &= &"  {outPrefix}_{fieldName} = result.{fieldName};\n"
    glsl &= "}\n";

  proc addGlslUniform(glsl:var string, varSym:NimNode, stageId:StageId) =
    let stage = shader.stage(stageId)
    let varName = varSym.repr
    let typeInst = varSym.typeInst
    let typeName = typeInst.repr
    let typeImpl = typeInst.typeImpl
    glsl.addGlslType(typeInst)
    glsl &= &"\nuniform {typeName} {varName};\n"
    var uniformIndex = -1
    for uniform in stage.uniforms:
      uniformIndex += 1
      if (uniform.name == ""):
        break
    if (uniformIndex >= stage.uniforms.len):
      error("too many global variables in shader", varSym)
      return
    let uniform = addr(stage.uniforms[uniformIndex])
    uniform.name = varName
    var fieldIndex = 0
    for field in typeImpl.fields:
      fieldIndex += 1
      let fieldName = field.repr
      let fieldTypeInst = field.typeInst
      let fieldTypeName = fieldTypeInst.repr
      let typeId = fieldTypeName.toTypeId
      if (typeId.isValidUniformFieldTypeId):
        uniform.fields[fieldIndex].typeId  = typeId
        uniform.fields[fieldIndex].name    = fieldName
        uniform.fields[fieldIndex].binding = &"{varName}.{fieldName}"
      else:
        error(&"unsupported uniform field type, {fieldTypeName}", field)

  proc addGlslGlobals(glsl:var string, node:NimNode, stageId:StageId) =
    if (shaderGlobalNames.contains(stageId.entryName)):
      return
    case node.kind
      of nnkStmtList:
        for child in node:
          glsl.addGlslGlobals(child, stageId)
      of nnkConstSection:
        return
      of nnkTypeSection:
        let typeSection = node
        for typeDef in typeSection:
          let typeInst = typeDef[0]
          let typeName = getShaderTypeName(typeInst.repr)
          if (stageId == StageId.Vertex and typeName == "Sample"):
            return
          if (stageId == StageId.Fragment and typeName == "Vertex"):
            return
          glsl.addGlslType(typeInst)
      of nnkVarSection:
        let varSection = node
        for varSym in varSection.varSyms:
          glsl.addGlslUniform(varSym, stageId)
      of nnkProcDef:
        let procDef = node
        let procName = procDef[0].repr
        if (procName == stageId.entryName):
          glsl.addGlslFunction(procDef)
          glsl.addGlslMain(procDef, stageId)
        elif (procName != "vert" and procName != "frag"):
          glsl.addGlslFunction(procDef)
      of nnkIncludeStmt:
        discard
      else:
        glsl &= "/*\n"
        glsl &= node.treeRepr
        glsl &= "\n*/\n"

  proc toGlsl(node:NimNode, stageId:StageId):string =
    result = "#version 330\n"
    result.addGlslGlobals(node, stageId)

  proc print(stage:Stage) =
    echo "  uniforms:"
    for uniform in stage.uniforms:
      if uniform.name.len > 0:
        echo "    " & uniform.name
        for field in uniform.fields:
          if field.typeId != TypeId.Void:
            var fieldInfo = &"      {field.typeId} {field.name}"
            if field.arrayLength > 0:
              fieldInfo &= &"[{field.arrayLength}]"
            fieldInfo &= &": {field.binding}"
            echo fieldInfo
    echo "  attributes:"
    for attribute in stage.attributes:
      if attribute.typeId != TypeId.Void:
        echo &"    {attribute.typeId} {attribute.name}: {attribute.binding}"

  proc print(shader:Shader) =
    echo "vert:"
    print shader.vert
    echo "frag:"
    print shader.frag

  block:
    let vert = n.toGlsl(StageId.Vertex)
    let frag = n.toGlsl(StageId.Fragment)
    let glsl =
      "/*-- vert --*/\n" & vert & "\n" &
      "/*-- frag --*/\n" & frag
    echo glsl
    let glslFile = n.lineInfoObj.filename & ".glsl"
    writeFile(glslFile, glsl)
    shader.language = Language.Glsl
    shader.vert.source = vert
    shader.frag.source = frag
    print shader
    result = newLit(shader)


#-------------------------------------------------------------------------------

const Back*  = Cull.Back
const Front* = Cull.Front

macro cull*(cull:Cull) =
  result = quote do:
    const cull* = `cull`

#-------------------------------------------------------------------------------

const Left*  = Winding.Left
const Right* = Winding.Right

macro winding*(winding:Winding) =
  result = quote do:
    const winding* = `winding`

#-------------------------------------------------------------------------------

const
  Zero*               = BlendFactor.Zero
  One*                = BlendFactor.One
  SrcColor*           = BlendFactor.SrcColor
  OneMinusSrcColor*   = BlendFactor.OneMinusSrcColor
  SrcAlpha*           = BlendFactor.SrcAlpha
  OneMinusSrcAlpha*   = BlendFactor.OneMinusSrcAlpha
  DstColor*           = BlendFactor.DstColor
  OneMinusDstColor*   = BlendFactor.OneMinusDstColor
  DstAlpha*           = BlendFactor.DstAlpha
  OneMinusDstAlpha*   = BlendFactor.OneMinusDstAlpha
  SrcAlphaSaturated*  = BlendFactor.SrcAlphaSaturated
  BlendColor*         = BlendFactor.BlendColor
  OneMinusBlendColor* = BlendFactor.OneMinusBlendColor
  BlendAlpha*         = BlendFactor.BlendAlpha
  OneMinusBlendAlpha* = BlendFactor.OneMinusBlendAlpha

proc add*(sourceFactor, targetFactor:BlendFactor):BlendFunction =
  result.op = BlendOp.Add
  result.sourceFactor = sourceFactor
  result.targetFactor = targetFactor
  result

proc sub*(sourceFactor, targetFactor:BlendFactor):BlendFunction =
  result.op = BlendOp.Sub
  result.sourceFactor = sourceFactor
  result.targetFactor = targetFactor
  result

proc rsub*(sourceFactor, targetFactor:BlendFactor):BlendFunction =
  result.op = BlendOp.Rsub
  result.sourceFactor = sourceFactor
  result.targetFactor = targetFactor
  result

macro blend*(colorAndAlpha:BlendFunction) =
  result = quote do:
    const blend* = BlendState(
      enabled:true,
      color:`colorAndAlpha`,
      alpha:`colorAndAlpha`,
    )

macro blend*(color, alpha:BlendFunction) =
  result = quote do:
    const blend* = BlendState(
      enabled:true,
      color:`color`,
      alpha:`alpha`,
    )

#-------------------------------------------------------------------------------

const
  Never*        = Comparison.Never
  Less*         = Comparison.Less
  Equal*        = Comparison.Equal
  LessEqual*    = Comparison.LessEqual
  Greater*      = Comparison.Greater
  NotEqual*     = Comparison.NotEqual
  GreaterEqual* = Comparison.GreaterEqual
  Always*       = Comparison.Always

macro depth*(
  write         :bool       = false,
  compare       :Comparison = Always,
  bias          :float32    = 0f,
  biasClamp     :float32    = 0f,
  biasSlopeScale:float32    = 0f,
) =
  result = quote do:
    const depth* = DepthState(
      write:`write`,
      compare:`compare`,
      bias:`bias`,
      biasClamp:`biasClamp`,
      biasSlopeScale:`biasSlopeScale`,
    )

#-------------------------------------------------------------------------------

const
  Keep*      = StencilOp.Keep
  Clear*     = StencilOp.Clear
  Replace*   = StencilOp.Replace
  IncrWrap*  = StencilOp.IncrWrap
  DecrWrap*  = StencilOp.DecrWrap
  IncrClamp* = StencilOp.IncrClamp
  DecrClamp* = StencilOp.DecrClamp
  Invert*    = StencilOp.Invert

proc face*(
  compare     :Comparison = Comparison.Never,
  depthFailOp :StencilOp = StencilOp.Keep,
  failOp      :StencilOp = StencilOp.Keep,
  passOp      :StencilOp = StencilOp.Keep,
):StencilFace =
  result.compare = compare
  result.depthFailOp = depthFailOp
  result.failOp = failOp
  result.passOp = passOp
  result

macro stencil*(
  readMask  :uint8       = 0xFFu8,
  writeMask :uint8       = 0xFFu8,
  refValue  :uint8       = 0u8,
  front     :StencilFace = StencilFace(),
  back      :StencilFace = StencilFace(),
) =
  result = quote do:
    const stencil* = StencilState(
      enabled:true,
      readMask:`readMask`,
      writeMask:`writeMask`,
      refValue:`refValue`,
      front:`front`,
      back:`back`,
    )

#-------------------------------------------------------------------------------

when isMainModule:

  # it is useful to define uniform types outside of the shader code
  type Transforms = object
    mvp:Mat4f
    counter:float32

  let s = shader:
    # blend(add(SrcAlpha,OneMinusSrcAlpha))
    blend(
      color=add(SrcAlpha,OneMinusSrcAlpha),
      alpha=add(SrcAlpha,OneMinusSrcAlpha),
    )

    depth(
      write=true,
      compare=Comparison.Less
    )

    stencil(
      readMask=0xFFu8,
      writeMask=0xFFu8,
      refValue=0u8,
      front=face(),
      back=face(),
    )

    var transforms:Transforms

    type Vertex = object
      position:Vec4f
      color:Vec4f

    type Instance = object
      translation:Vec3f
      scale:float32
      rotation:Vec4f

    type Fragment = Vertex

    type Sample = object
      color:Vec4f

    proc vert*(v:Vertex, vertId, instId:uint32):Fragment =
      result.position = transforms.mvp * v.position.xyzw
      result.color = v.color

    include pbr

    proc frag*(f:Fragment):Sample =
      result.color = f.color * pbr()

  discard s