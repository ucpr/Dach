import dach
import tables

var r = newRouter()

proc hoge(): string =
  return "Hello World!"

proc param(): string =
  return "YES"

r.addRule(url="/hello", httpMethod="GET", name="root", callback=hoge)
r.addRule(url="/hoge/{poyo}/hello", httpMethod="GET", name="root", callback=param)
r.addRule(url="/hoge/{poyo}", httpMethod="GET", name="root", callback=param)
r.addRule(url="/hoge", httpMethod="GET", name="root", callback=param)

#for i in r.endpoints["GET"].keys():
#  echo i

#let a = r.match("/hello", "GET")
#echo a.callback()

r.run()
