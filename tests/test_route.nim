import route

var r = newRouter()

proc hoge(): string =
  return "Hello World!"

proc param(): string =
  return "YES"

block addRule:
  r.addRule(url="/hello", httpMethod="GET", name="root", callback=hoge)
  r.addRule(url="/hello/{poyo}", httpMethod="GET", name="root", callback=hoge)
  r.addRule(url="/hoge/{poyo}/hello", httpMethod="GET", name="root", callback=param)
  r.addRule(url="/hoge", httpMethod="GET", name="root", callback=hoge)

block match:
  let
    a = r.match("/hoge", "GET")
    b = r.match("/hello", "GET")
    c = r.match("/hoge/10/hello", "GET")
    d = r.match("/hello/100", "GET")
