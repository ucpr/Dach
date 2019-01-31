## Dach is tiny web application framework. This project started with SecHack365.
##
## Example
## -------
## This example will create an Dach application on 127.0.0.1:8080
##
## .. code-block::nim
##    import dach
##    var app = newDach()
##    
##    proc cb(ctx: DachCtx): Resp =
##       ctx.response("Hello World")
##    
##    app.addRoute("/", "index")
##    app.addView("index", HttpGet, cb)
##
##    app.run()
##

import asyncdispatch, asynchttpserver, httpcore
import strformat, strutils
import tables
import macros

import dach/[route, response, configrator, logger, cookie, session]

#include dach/cookie
#include dach/response

export cookie, response, httpcore
export route except get

type
  Dach* = ref object
    router: Router
    config: Configurator
    routeNames: Table[string, string]
    session*: Session

proc newDach*(filename: string = ""): Dach =
  ## Create a new Dach instance
  result = new Dach

  result.router = newRouter()
  result.routeNames = initTable[string, string]()

  if filename == "":
    result.config = newConfigurator()
  else:
    result.config = loadConfigFile(filename)

  if result.config.isUseSession:
    let
      con = result.config.sessionConnection
      user = result.config.sessionServerUser
      pass = result.config.sessionServerPassword
      database = result.config.sessionServerDatabase
    result.session = newSession(con, user, pass, database)

proc addRoute*(r: var Dach, rule, name: string) =
  ## Add route and route name
  r.routeNames[name] = rule

proc addView*(r: var Dach, name: string, hm: HttpMethod, cb: CallBack) =
  ## Add CallBack based on route name
  ##
  ## .. code-block::nim
  ##    import dach
  ##    var app = newDach()
  ##    
  ##    proc cb(ctx: DachCtx): Resp =
  ##       ctx.response("Hello World")
  ##    
  ##    app.addRoute("/", "index")
  ##    app.addView("index", HttpGet, cb)
  ##
  ##    app.run()
  if not r.routeNames.hasKey(name):
    return
    # raise exception
  let rule = r.routeNames[name]

  if not r.router.hasRule(rule, hm):
    r.router.addRule(rule, hm, cb)
  else:
    return  ## Future: raise Exception

proc parseQuery(s: string): Table[string, string] =
  result = initTable[string, string]()
  if s != "":
    for query in s.split("?"):
      let param = query.split("=")
      result[param[0]] = param[1]

proc run*(r: Dach) =
  ## running Dach application.
  let
    server = newAsyncHttpServer()
    port = r.config.port
    address = r.config.address

  if r.config.debug == true:
    dachConsoleLogger()

  proc handler(req: Request) {.async.} =
    let
      url = req.url.path
      hm = req.reqMethod
      query = parseQuery(req.url.query)

    if r.router.hasRule(url, hm):
      var ctx = newDachCtx()
      ctx.query = query
      let 
        resp = r.router.get(url, hm)(ctx)
        statucode = resp.statuscode
      info(fmt"{$hm} {url} {statucode}")
      await req.respond(resp.statuscode, resp.content, resp.headers)
    else:
      info(fmt"{$hm} {url} {$Http404}")
      await req.respond(Http404, "Not Found")

  echo fmt"Running on localhost:8080"
  waitFor server.serve(port=Port(port), handler, address=address)
#  httpbeast.run(handler, settings)

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
  proc cb(ctx: DachCtx): Resp =
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
  proc cb(ctx: DachCtx): Resp =
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
  proc cb(ctx: DachCtx): Resp =
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
  proc cb(ctx: DachCtx): Resp =
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
  proc cb(ctx: DachCtx): Resp =
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
  proc cb(ctx: DachCtx): Resp =
{strBody}
  {repr(head)}.router.addRule(""{repr(path)}"", HttpOptions, cb)"""
  result = parseStmt(mainNode)

