import asyncdispatch
import tables
import strformat
import httpcore

import httpbeast except run, Settings
import options

import dach/[route, response, configrator, logger]
export route, response, httpcore

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
  r.router.addRule(rule, hm, cb)

proc run*(r: Dach) =
  let
#    server = newAsyncHttpServer()
    port = r.config.port
    address = r.config.address
    settings = initSettings(Port(8080), address)

  #if r.config.debug == true:
  dachConsoleLogger()

  proc handler(req: Request): Future[void] =
    let
      url = req.path.get()
      hm = req.httpMethod.get()
#      query = req.url.query
#      protocol = req.protocol.orig

    if r.router.hasRule(url, hm):
      let 
        resp = r.router.get(url, hm)()
        statucode = resp.statuscode
      info(fmt"{$hm} {url} {statucode}")
      req.send(resp.statuscode, resp.content, $resp.headers)
      #info(fmt"{}")
    else:
      info(fmt"{$hm} {url} {$Http404}")
      req.send(Http404, "Not Found")

  echo fmt"Running on {address}:{port}"

  httpbeast.run(handler, settings)

