import json
import tables
import httpcore

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

proc Response*(content: string, statuscode = Http200, headers = newHttpHeaders()): Resp =
  result = (statuscode: statuscode, content: content, headers: headers)
  CallBack* = proc (ctx: DachCtx): Resp

proc JsonResponse*(content: string, statuscode = Http200): Resp =
  let jsonNode = parseJson(content)
  let headers = newhttpheaders([("content-type", "application/json")])
  result = (statuscode: statuscode, content: $content, headers: headers)

proc JsonResponse*(content: JsonNode, statuscode = Http200): Resp =
  let headers = newhttpheaders([("content-type", "application/json")])
  result = (statuscode: statuscode, content: $content, headers: headers)


