import json
import logging
import asynchttpserver
import asyncdispatch
import sequtils
import strutils
import tables

var L = newConsoleLogger()
addHandler(L)

type cbProc = proc(): string

type 
  Router* = ref object
    endpoints*: Table[string,
                  Table[string, tuple[name: string, callback: cbProc]]]

proc newRouter*(): Router =
  result = new(Router)
  result.endpoints = initTable[string,
                      Table[string, tuple[name: string, callback: cbProc]]]()

proc addRule*(r: Router, url: string, httpMethod: string, name: string, callback: cbProc) =
  let
    # TODO: '/' のみの場合
    url = url.strip().strip(chars={'/'}, leading=false)
    httpMethod = httpMethod.toUpperAscii()
  if not r.endpoints.hasKey(httpMethod):
    r.endpoints[httpMethod] = initTable[string, tuple[name: string, callback: cbProc]]()
    r.endpoints[httpMethod][url] = (name: name, callback: callback)

proc match*(r: Router, url: string, httpMethod: string): int =
  discard
