##
## .. code-block::nim
##

import cookies
import strutils, strtabs

const
  COOKIE_REMOVE_EXPIRES = "Fri, 31 Dec 1999 23:59:59 GMT"

type
#  Cookie* = seq[string]
  Cookie* = StringTableRef
  SessionCookie* = StringTableRef

#proc `[]=`*(ck: var Cookie, key, val: string) =
#  ##
#  ## .. code-block::nim
#  ##    import cookies
#  ##    app.cookie["key"] = value
#  ##
#  let s = setCookie(key, val, noName = true)
#  ck.add(s)

#proc concat*(c: Cookie): string =
#  result = join(c, ";")

proc concat*(c: Cookie): string =
  result = ""
  for i in c.pairs:
    result &= i.key & "=" & i.value & ";"

proc pop*(c: var Cookie, key: string) =
  if not c.hasKey(key):
    return
  var k = c[key]
  k &= ";expires=" & COOKIE_REMOVE_EXPIRES & ";"
  c[key] = k

if isMainModule:
  block:
    var ck: Cookie
    ck["name"] = "Taro"
    ck["name"] = "hanako"
    assert concat(ck) == "name=Taro;name=hanako"
