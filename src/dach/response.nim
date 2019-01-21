import json
import httpcore

type
  CallBack = proc (): string
  responseObj

proc Response*(content: string, headers = newHttpHeaders()): respObj =
  result = (content: content, headers: headers)

proc JsonResponse*(jsonObj: JsonNode): respObj =
  let headers = newHttpHeaders([("Content-Type", "application/json")])
  result = (content: $jsonObj, headers: headers)
