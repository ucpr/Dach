
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
  result = new Dach

  result.router = newRouter()
  result.config = newConfigurator()
  result.routeNames = initTable[string, string]()

proc addRoute*(r: var Dach, rule, name: string) =
  r.routeNames[name] = rule

proc addView*(r: var Dach, name: string, hm: HttpMethod, cb: CallBack) =
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

