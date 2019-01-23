import json
import httpcore

type
  Resp* = tuple[statuscode: HttpCode,
              content: string,
              headers: HttpHeaders]
  CallBack* = proc (): Resp

proc Response*(content: string, statuscode = Http200, headers = newHttpHeaders()): Resp =
  result = (statuscode: statuscode, content: content, headers: headers)

proc JsonResponse*(content: JsonNode, statuscode = Http200): Resp =
  let headers = newHttpHeaders([("Content-Type", "application/json")])
  result = (statuscode: statuscode, content: $content, headers: headers)

