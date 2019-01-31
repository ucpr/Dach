import tables
import strutils
import httpcore

import times

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

if isMainModule:
  let l = @[
    "/",
    "/user",
    "/user/profile",
    "/user/ac",
    "/user/account",
    "/user/char",
    "/user/hoge",
    "/ascii/hoge",
    "/ascii/name",
    "/namespace",
    "/lang",
    "/lang/java",
    "/lang/javascript",
    "/lang/python",
    "/lang/ruby",
    "/lang/nim"
    ]
  var r = newRouter()

  proc cb(ctx: DachCtx): Resp =
    ctx.response("Hello World")

  let old = cpuTime()

  for p in l:
    r.addRule(p, HttpGet, cb)
  echo "routing time: ", cpuTime() - old

  for p in l:
    discard r.hasRule(p, HttpGet)

  echo "hasRule time: ", cpuTime() - old

