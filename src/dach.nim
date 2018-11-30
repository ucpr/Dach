import asynchttpserver
import asyncdispatch
import tables

import dach/[route, response]
export route, response, Port

proc run*(r: Router, p=Port(8080), address="") =
  var server = newAsyncHttpServer()
  proc cb(req: Request) {.async.} =
    let
      url = req.url.path
      mh = $req.reqMethod
      params = r.match(url, mh)
    if url != "./favicon.ico":
      let ctx = params.callback()
      if ctx.headers.len == 0:
        await req.respond(Http200, ctx.content)
      else:
        await req.respond(Http200, ctx.content, ctx.headers)

  waitFor server.serve(port=p, cb, address=address)
