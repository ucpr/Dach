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
import strformat,  strutils
import tables
import macros

import dach/[route, response, configrator, logger, cookie]

#include dach/cookie
#include dach/response

export cookie, response, httpcore
export route except get

type
  Dach* = ref object
    router: Router
    config: Configrator
    routeNames: Table[string, string]

proc newDach*(): Dach =
  ## Create a new Dach instance
  result = new Dach

  result.router = newRouter()
  result.config = newConfigurator()
  result.routeNames = initTable[string, string]()

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

