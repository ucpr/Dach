import tables
import strutils

import critbittree, response

type 
  httpMethods* = enum
    GET = "GET"
    POST = "PUT"
    PUT = "PUT"
    HEAD = "HEAD"
    DELEATE = "DELEATE"
    OPTIONS = "OPTIONS"

#  CallBack = proc(): string
#  Parameters = Table[string, string]

  Items = object
    rule: string
    name: string
    httpMethod: httpMethods
    callbacks: Table[httpMethods, CallBack]
  #paramIndices: array 

  Router* = CritBitTree[Items]

proc newRouter*(): Router =
  var router: CritBitTree[Items]
  return router

proc addRule*(r: var Router, rule, name: string, httpMethod: httpMethods, callback: CallBack) =
  var item: Items

  if not r.hasKey(rule):
    item.callbacks = initTable[httpMethods, CallBack]()

  item.rule = rule
  item.name = name
  item.httpMethod = httpMethod
  item.callbacks[httpMethod] = callback

  r[rule] = item

proc hasRule*(r: Router, rule: string, httpMethod: httpMethods): bool =
  if (not r.hasKey(rule)) or (not r[rule].callbacks.hasKey(httpMethod)):
    return false
  else:
    return true
