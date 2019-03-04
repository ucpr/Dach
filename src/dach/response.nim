import json
import strtabs
import httpcore
import strutils
import uri

import cookie, configrator

when useHttpBeast:
  import httpbeast
else:
  import asynchttpserver

type
  Resp* = tuple
    statuscode: HttpCode
    content: string
    headers: HttpHeaders

  DachCtx* = ref object
    uri*: Uri
    httpmethod*: HttpMethod
    statuscode*: HttpCode
    headers*: HttpHeaders
    cookie*: Cookie
    query*: StringTableRef
    form*: StringTableRef
    req*: Request

  CallBack* = proc (ctx: DachCtx): Resp

proc newDachCtx*(): DachCtx =
  ## Create a new DachCtx instance.
  result = new DachCtx
  result.statuscode = Http200
  result.headers = newhttpheaders()

proc response*(ctx: DachCtx, content: string, statucode: HttpCode = Http200,
              contentType: string = "text/plain", header: HttpHeaders = newhttpheaders()): Resp =
  var h = header
  h["Content-Type"] = contentType
  result = (statuscode: statucode, content: content, headers: h)

proc jsonResponse*(ctx: DachCtx, content: JsonNode,
                  statucode: HttpCode = Http200, header: HttpHeaders = newhttpheaders()): Resp =
  ctx.response($content, contentType="appication/json")

proc jsonResponse*(ctx: DachCtx, content: string,
                  statucode: HttpCode = Http200, header: HttpHeaders = newhttpheaders()): Resp =
  let jsonNode = parseJson(content)
  result = ctx.jsonResponse(jsonNode)

proc redirect*(ctx: DachCtx, path: string, header: HttpHeaders = newhttpheaders()): Resp =
  var h = header
  h["Location"] = path
  result = (statuscode: Http303,
            content: "Redirecting to <a href=\"$1\">$1</a>" % [path],
            headers: h)
