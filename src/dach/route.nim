import json
import asynchttpserver
import asyncdispatch
import sequtils
import strutils
import tables
import nre

type 
  respObj* = tuple[content: string, headers: HttpHeaders]
  dachParams* = Table[string, string]
  cbProc = proc(p: dachParams): respObj
  Router* = ref object
    endpoints*: Table[string,
                  Table[string, tuple[name: string, callback: cbProc]]]

proc splitSlash(url: string): seq[string] =
  #[ split by slash ]#
  result = url.strip(chars={'/'}+Whitespace).split("/")

proc matchUrlVars(rule, url: string): tuple[matchf: bool, params: dachParams] =
  #[
    ruleに基づいてparamaterの値をurlから取得する
  ]#
  let 
    rule = splitSlash(rule)
    url = splitSlash(url)
  if rule.len != url.len:
    return (matchf: false, params: initTable[string, string]())

  var params = initTable[string, string]()
  for i in countup(0, rule.len - 1):
    if rule[i].startsWith("{") and rule[i].endsWith("}"):
      let
        key = rule[i].strip(chars={'{', '}'})
        value = url[i]
      echo key, " : ", value
      params[key] = value
      continue
    if rule[i] != url[i]:
      echo rule[i], " ", url[i]
      # TODO: 今はいったん空のTableを返す
      return (matchf: false, params: initTable[string, string]())
  return (matchf: true, params: params)

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

proc notfound(p: dachParams): respObj =
  return (content: "NOTFOUND", headers: newHttpHeaders())

proc match*(r: Router, url: string, httpMethod: string): tuple[matchf: bool, callback: cbProc, params: dachParams] =
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
      return (matchf: true, callback: callback, params: urlVars.params)
  return (matchf: false, callback: nil, params: initTable[string, string]())