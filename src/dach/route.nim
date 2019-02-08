import tables
import strutils
import httpcore

import times
import random

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

  Items = ref object
    rule: string
#    hm: HttpMethod
    callbacks: Table[HttpMethod, CallBack]
  #paramIndices: array 

  Router* = CritBitTree[Items]

proc newRouter*(): Router =
  var router: CritBitTree[Items]
  return router

proc addRule*(r: var Router, rule: string, hm: HttpMethod, callback: CallBack) =
  if not r.hasKey(rule):
    var item = new Items
    item.callbacks = initTable[HttpMethod, CallBack]()
    item.rule = rule
    item.callbacks[hm] = callback
    r[rule] = item
  else:
    r[rule].callbacks[hm] = callback

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
    "/lang/javascript",
    "/lang/python",
    "/lang/ruby",
    "/lang/nim",
    "/sechack365/user",
    "/sechack365/user/name",
    "/sechack365/user/age",
    "/sechack365/user/profile",
    "/sechack365/user/email",
    "/sechack365/okinawa",
    "/sechack365/ehime",
    "/sechack365/kanagawa",
    "/sechack365/hokkaido",
    "/sechack365/hukuoka",
    "/sechack365/user/hoge",
    "/sechack365/user/name/hoge",
    "/sechack365/user/age/hoge",
    "/sechack365/user/profile/hoge",
    "/sechack365/user/email/hoge",
    "/sechack365/okinawa/hoge",
    "/sechack365/ehime/hoge",
    "/sechack365/kanagawa/nay",
    "/sechack365/hokkaido/poen",
    "/sechack365/hukuoka/fdsfs",

    "/nums/one/nyan",
    "/nums/tow",
    "/nums/three/hoge",
    "/nums/four",
    "/nums/five",
    "/nums/six/fdsf",
    "/nums/seven/dfdsf",
    "/nums/eight",
    "/nums/nine",
    "/nums/ten/fllll"
    ]
  var r = newRouter()

  proc cb(ctx: DachCtx): Resp =
    ctx.response("Hello World")


  for p in l:
    r.addRule(p, HttpGet, cb)
#  echo "routing time: ", cpuTime() - dachold

  var list: seq[string] = l
  shuffle(list)
 
  let dachold = cpuTime()
  for p in list:
    if not r.hasRule(p, HttpGet):
      echo false
  echo "hasRule time: ", cpuTime() - dachold

  let old = cpuTime()
#  for p in l:
#    r.addRule(p, HttpGet, cb)
#  echo "routing time: ", cpuTime() - old
  for p in list:
    for i in l:
      if p == i:
        break
  echo "hasRule time: ", cpuTime() - old

