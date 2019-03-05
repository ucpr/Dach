import httpcore
import uri, strutils, strformat, macros

import nest

import response

type 
  DachRouter* = Router[CallBack]

proc newDachRouter*(): DachRouter =
  ## create new DachRouter instance
  result = newRouter[CallBack]()

proc addRule*(r: var DachRouter, rule: string, hm: HttpMethod, cb: CallBack) =
  ## mapping to router
  r.map(cb, ($hm).toLower, rule)

# Routing macros

macro get*(head, path, body: untyped): untyped =
  ## Add rule to router
  ##
  ## .. code-block::nim
  ##    import dach
  ##    var app = newDach()
  ##    
  ##    app.get "/":
  ##      ctx.response("Hello World")
  ##    
  ##    app.run()
  var strBody: string
  for i in body:
    strBody.add(fmt"    {repr(i)}" & "\n")

  var mainNode: string = fmt"""
block:
  proc cb(ctx: DachCtx): DachResp =
{strBody}
  {repr(head)}.router.addRule(""{repr(path)}"", HttpGet, cb)"""
  result = parseStmt(mainNode)

macro post*(head, path, body: untyped): untyped =
  ## Add rule to router
  var strBody: string
  for i in body:
    strBody.add(fmt"    {repr(i)}" & "\n")

  var mainNode: string = fmt"""
block:
  proc cb(ctx: DachCtx): DachResp =
{strBody}
  {repr(head)}.router.addRule(""{repr(path)}"", HttpPost, cb)"""
  result = parseStmt(mainNode)

macro put*(head, path, body: untyped): untyped =
  ## Add rule to router
  var strBody: string
  for i in body:
    strBody.add(fmt"    {repr(i)}" & "\n")

  var mainNode: string = fmt"""
block:
  proc cb(ctx: DachCtx): DachResp =
{strBody}
  {repr(head)}.router.addRule(""{repr(path)}"", HttpPut, cb)"""
  result = parseStmt(mainNode)

macro head*(head, path, body: untyped): untyped =
  ## Add rule to router
  var strBody: string
  for i in body:
    strBody.add(fmt"    {repr(i)}" & "\n")

  var mainNode: string = fmt"""
block:
  proc cb(ctx: DachCtx): DachResp =
{strBody}
  {repr(head)}.router.addRule(""{repr(path)}"", HttpHead, cb)"""
  result = parseStmt(mainNode)

macro delete*(head, path, body: untyped): untyped =
  ## Add rule to router
  var strBody: string
  for i in body:
    strBody.add(fmt"    {repr(i)}" & "\n")

  var mainNode: string = fmt"""
block:
  proc cb(ctx: DachCtx): DachResp =
{strBody}
  {repr(head)}.router.addRule(""{repr(path)}"", HttpDelete, cb)"""
  result = parseStmt(mainNode)

macro options*(head, path, body: untyped): untyped =
  ## Add rule to router
  var strBody: string
  for i in body:
    strBody.add(fmt"    {repr(i)}" & "\n")

  var mainNode: string = fmt"""
block:
  proc cb(ctx: DachCtx): DachResp =
{strBody}
  {repr(head)}.router.addRule(""{repr(path)}"", HttpOptions, cb)"""
  result = parseStmt(mainNode)

if isMainModule:
  var
    router = newDachRouter()
    ctx = newDachCtx()

  proc cb(ctx: DachCtx): DachResp =
    result = newDachResp()
    result.content = response("Hello World!")

  router.addRule("/", HttpGet, cb)
  router.addRule("/hoge", HttpGet, cb)

  router.compress()

  let
    indexRes = router.route(($HttpGet).toLower, parseUri("/"))
    hogeRes = router.route(($HttpGet).toLower, parseUri("/hoge"))
    missingRes = router.route(($HttpGet).toLower, parseUri("/missing"))
  
  assert indexRes.status == routingSuccess
  assert hogeRes.status == routingSuccess
  assert missingRes.status != routingSuccess

