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

template get*(head, path, body: untyped): untyped =
  ## Add rule to router
  ##
  ## .. code-block::nim
  ##    import dach
  ##    var app = newDach()
  ##    
  ##    app.get "/":
  ##      result.content = response("Hello World")
  ##    
  ##    app.run()
  block:
    proc cb(ctx: DachCtx): DachResp =
      result = ctx.newDachResp()
      body
    head.router.addRule(path, HttpGet, cb)

template post*(head, path, body: untyped): untyped =
  block:
    proc cb(ctx: DachCtx): DachResp =
      result = ctx.newDachResp()
      body
    head.router.addRule(path, HttpPost, cb)

template head*(head, path, body: untyped): untyped =
  block:
    proc cb(ctx: DachCtx): DachResp =
      result = ctx.newDachResp()
      body
    head.router.addRule(path, HttpHead, cb)

template put*(head, path, body: untyped): untyped =
  block:
    proc cb(ctx: DachCtx): DachResp =
      result = ctx.newDachResp()
      body
    head.router.addRule(path, HttpPut, cb)

template Delete*(head, path, body: untyped): untyped =
  block:
    proc cb(ctx: DachCtx): DachResp =
      result = ctx.newDachResp()
      body
    head.router.addRule(path, HttpDelete, cb)

template trace*(head, path, body: untyped): untyped =
  block:
    proc cb(ctx: DachCtx): DachResp =
      result = ctx.newDachResp()
      body
    head.router.addRule(path, HttpTrace, cb)

template optioins*(head, path, body: untyped): untyped =
  block:
    proc cb(ctx: DachCtx): DachResp =
      result = ctx.newDachResp()
      body
    head.router.addRule(path, HttpOptions, cb)

template connect*(head, path, body: untyped): untyped =
  block:
    proc cb(ctx: DachCtx): DachResp =
      result = ctx.newDachResp()
      body
    head.router.addRule(path, HttpConnect, cb)

template patch*(head, path, body: untyped): untyped =
  block:
    proc cb(ctx: DachCtx): DachResp =
      result = ctx.newDachResp()
      body
    head.router.addRule(path, HttpPatch, cb)

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

