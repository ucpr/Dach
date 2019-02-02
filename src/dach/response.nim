import json
import tables
import httpcore
import strutils
import asyncHttpServer

import cookie

type
  Resp* = tuple
    statuscode: HttpCode
    content: string
    headers: HttpHeaders

  DachCtx* = ref object
    statuscode*: HttpCode
    headers*: HttpHeaders
    cookie*: Cookie
    query*: Table[string, string]
    form*: Table[string, string]
    req*: Request

  CallBack* = proc (ctx: DachCtx): Resp

proc newDachCtx*(): DachCtx =
  ## Create a new DachCtx instance.
  result = new DachCtx
  result.statuscode = Http200
  result.headers = newhttpheaders()

proc response*(ctx: DachCtx, content: string): Resp =
  var header = ctx.headers
  if ctx.cookie.len != 0:
    header["Set-Cookie"] = concat(ctx.cookie)
  result = (statuscode: ctx.statuscode, content: content, headers: ctx.headers)

proc jsonResponse*(ctx: DachCtx, content: JsonNode): Resp =
  var header = ctx.headers
  if ctx.cookie.len != 0:
    header["Set-Cookie"] = concat(ctx.cookie)
  header["Content-Type"] = "application/json"
  result = (statuscode: ctx.statuscode, content: $content, headers: header)

proc jsonResponse*(ctx: DachCtx, content: string): Resp =
  let jsonNode = parseJson(content)
  result = ctx.jsonResponse(jsonNode)

proc redirect*(ctx: DachCtx, path: string): Resp =
  var header = ctx.headers
  header["Location"] = path
  result = (statuscode: Http303,
            content: "Redirecting to <a href=\"$1\">$1</a>" % [path],
            headers: header)
