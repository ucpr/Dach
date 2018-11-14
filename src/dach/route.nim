import json
import logging
import asynchttpserver
import asyncdispatch
import sequtils
import tables

var L = newConsoleLogger()
addHandler(L)

type cbProc = proc(): string

type 
#  Route = object
#  rule = string
#  httpMethod = string
#  name = string
#   callback: cbProc

  Router* = ref object
    endpoints*: Table[string,
                  Table[string,
                    tuple[name: string, callback: cbProc]
                ]]

proc add_rule*(r: Router, url: string, httpMethod: string, name: string, callback: cbProc) =
  #r.routes.add(route)
  discard

proc match*(r: Router, url: string, httpMethod: string): int =
  discard
