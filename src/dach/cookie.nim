import cookies
import strutils

type
  Cookie* = seq[string]

proc `[]=`*(ck: var Cookie, key, val: string) =
  let s = setCookie(key, val, noName = true)
  ck.add(s)

proc concat*(c: Cookie): string =
  result = join(c, ";")

if isMainModule:
  block:
    var ck: Cookie
    ck["name"] = "Taro"
    ck["name"] = "hanako"
    assert concat(ck) == "name=Taro;name=hanako"
