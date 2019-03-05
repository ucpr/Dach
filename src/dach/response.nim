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

proc response*(content: string, status: HttpCode = Http200,
              contentType: string = "text/plain", header: HttpHeaders = newhttpheaders()): Resp =
  var h = header
  h["Content-Type"] = contentType
  result = (statuscode: status, content: content, headers: h)

proc jsonResponse*(content: JsonNode,
                  status: HttpCode = Http200, header: HttpHeaders = newhttpheaders()): Resp =
  response($content, contentType="appication/json")

proc jsonResponse*(content: string,
                  status: HttpCode = Http200, header: HttpHeaders = newhttpheaders()): Resp =
  let jsonNode = parseJson(content)
  result = jsonResponse(jsonNode)

proc redirect*(path: string, header: HttpHeaders = newhttpheaders()): Resp =
  var h = header
  h["Location"] = path
  result = (statuscode: Http303,
            content: "Redirecting to <a href=\"$1\">$1</a>" % [path],
            headers: h)
