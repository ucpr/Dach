import json
import asynchttpserver
import asyncdispatch
import sequtils
import strutils
import tables
import nre

type 
  cbProc = proc(): string
  Router* = ref object
    endpoints*: Table[string,
                  Table[string, tuple[name: string, callback: cbProc]]]

proc splitSlash(url: string): seq[string] =
  #[ split by slash ]#
  result = url.strip(chars={'/'}+Whitespace).split("/")

proc newRouter*(): Router =
  result = new(Router)
  result.endpoints = initTable[string,
                      Table[string, tuple[name: string, callback: cbProc]]]()

proc addRule*(r: Router, url: string, httpMethod: string, name: string, callback: cbProc) =
  #[
    add rule to Router.
    TODO: "/"のみの場合
          "すでにaddRuleされてたときのexception"
  ]#
  let
    url = url.strip().strip(chars={'/'}, leading=false)
    httpMethod = httpMethod.toUpperAscii()
  if not r.endpoints.hasKey(httpMethod):
    r.endpoints[httpMethod] = initTable[string, tuple[name: string, callback: cbProc]]()
  r.endpoints[httpMethod][url] = (name: name, callback: callback)

proc match*(r: Router, url: string, httpMethod: string): tuple[callback: cbProc, params: Table[string, string]] =
  #[ return callback & var ]#
  let
    url = url.strip().strip(chars={'/'}, leading=false)
#  if not r.endpoints.hasKey(httpMethod):
#    return nil
  for rule in r.endpoints[httpMethod].keys():
    var urlVars = matchUrlVars(rule, url)
    if urlVars.matchf:
      let
        callback = r.endpoints[httpMethod][rule].callback
      return (callback: callback, params: urlVars.params)
  return (callback: nil, params: initTable[string, string]())
