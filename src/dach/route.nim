import tables
import strutils
import httpcore

import critbittree, response

type 
#  HttpMethod* = enum
#    GET = "GET"
#    POST = "PUT"
#    PUT = "PUT"
#    HEAD = "HEAD"
#    DELEATE = "DELEATE"
#    OPTIONS = "OPTIONS"

#  CallBack = proc(): string
#  Parameters = Table[string, string]

  Items = object
    rule: string
    hm: HttpMethod
    callbacks: Table[HttpMethod, CallBack]
  #paramIndices: array 

  Router* = CritBitTree[Items]

proc newRouter*(): Router =
  var router: CritBitTree[Items]
  return router

proc addRule*(r: var Router, rule: string, hm: HttpMethod, callback: CallBack) =
  var item: Items

  if not r.hasKey(rule):
    item.callbacks = initTable[HttpMethod, CallBack]()

  item.rule = rule
  item.hm = hm
  item.callbacks[hm] = callback

  r[rule] = item

proc hasRule*(r: Router, rule: string, hm: HttpMethod): bool =
  if (not r.hasKey(rule)) or (not r[rule].callbacks.hasKey(hm)):
    return false
  else:
    return true

proc get*(r: Router, rule: string, hm: HttpMethod): CallBack =
  result = r[rule].callbacks[hm]
