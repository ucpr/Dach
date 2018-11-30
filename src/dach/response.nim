import json
import httpcore
import route

proc Response*(content: string, headers = newHttpHeaders()): respObj =
  result = (content: content, headers: headers)

proc JsonResponse*(jsonObj: JsonNode): respObj =
  let headers = newHttpHeaders([("Content-Type", "application/json")])
  result = (content: $jsonObj, headers: headers)
