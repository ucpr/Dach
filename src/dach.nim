import asynchttpserver
import asyncdispatch
import tables

import dach/[route]
export route, Port

proc run*(r: Router, p=Port(8080), address="") =
  var server = newAsyncHttpServer()
  proc cb(req: Request) {.async.} =
    let
      url = req.url.path
      mh = $req.reqMethod
      params = r.match(url, mh)
    if url != "./favicon.ico":
      await req.respond(Http200, params.callback())

  waitFor server.serve(port=p, cb, address=address)
