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

import asyncdispatch, uri, httpcore
import strformat, strutils
import tables
import macros
import db_mysql

import nest

when not defined(windows):
  import options
  import httpbeast
else:
  import asynchttpserver

import dach/[route, response, configrator, logger, cookie, session]

#include dach/cookie
#include dach/response

export cookie, response, httpcore, session, route
export tables
#export route except get

type
  Dach* = ref object
    router: Router[CallBack]
    config: Configurator
    routeNames: Table[string, string]
    session*: Dbconn

proc newDach*(filename: string = ""): Dach =
  ## Create a new Dach instance
  result = new Dach

  result.router = newDachRouter()
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
  r.router.addRule(rule, hm, cb)

proc parseBodyQuery(s: string): Table[string, string] =
  result = initTable[string, string]()
  if s != "":
    for query in s.split("&"):
      let param = query.split("=")
      result[param[0]] = param[1]

proc parseUri(path: string): string =
  discard

proc createDachCtx(req: Request): DachCtx =
  discard

proc run*(r: Dach) =
  ## running Dach application.
  r.router.compress()
  let
    port = r.config.port
    address = r.config.address

  if r.config.debug == true:
    dachConsoleLogger()
  when defined(windows):
    let server = newAsyncHttpServer()
    proc handler(req: Request) {.async.} =
      let
        url = req.url.path
        hm = req.reqMethod
        form = parseBodyQuery(req.body)
        res = r.router.route(($hm).toLower, parseUri(url))

      if res.status == routingSuccess:
        var ctx = newDachCtx()
        ctx.form = form
        ctx.req = req
        let 
          resp = res.handler(ctx)
        info(fmt"{$hm} {url} {$Http200}")
        await req.respond(Http200, resp.content, resp.headers)
      else:
        info(fmt"{$hm} {url} {$Http404}")
        await req.respond(Http404, "Not Found")
    waitFor server.serve(port=Port(port), handler, address=address)
  else:
    proc handler(req: Request): Future[void] =
      discard

    discard
#  httpbeast.run(handler, settings)

