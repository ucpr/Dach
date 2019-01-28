import cookies
import strutils

type
  Cookie* = seq[string]

proc `[]=`*(ck: var Cookie, key, val: string) =
  let s = setCookie(key, val, noName = true)
  ck.add(s)

if isMainModule:
  block:
    assert @["a=1", "b=2", "c=3"].joinCookies() == "a=1;b=2;c=3"

  block:
    let ck = new Cookie
    ck["name"] = "taro"

    assert ck[0] == "name=taro"
