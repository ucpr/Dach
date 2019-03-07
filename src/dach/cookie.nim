
import cookies
import strutils, strtabs


type
#  Cookie* = seq[string]
  Cookie* = StringTableRef
  SessionCookie* = StringTableRef

proc `[]=`*(ck: var Cookie, key, val: string) =
  let s = setCookie(key, val, noName = true)
  ck.add(s)

proc concat*(c: Cookie): string =
  result = join(c, ";")

proc concat*(c: Cookie): string =
  result = ""
  for i in c.pairs:
    result &= i.key & "=" & i.value & ";"

proc pop*(key: string): string =
  result = ""

if isMainModule:
  block:
    var ck: Cookie
    ck["name"] = "Taro"
    ck["name"] = "hanako"
    assert concat(ck) == "name=Taro;name=hanako"
