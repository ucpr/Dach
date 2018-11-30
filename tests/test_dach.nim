import dach
import json
import tables

var r = newRouter()

proc hoge(): respObj =
  return Response("Hello World")

proc param(): respObj =
  return JsonResponse(%*[{"hoge": 2, "kobashiri": "kawaii"}])

r.addRule(url="/hello", httpMethod="GET", name="root", callback=hoge)
r.addRule(url="/hoge/{poyo}/hello", httpMethod="GET", name="root", callback=param)
r.addRule(url="/hoge/{poyo}", httpMethod="GET", name="root", callback=param)
r.addRule(url="/hoge", httpMethod="GET", name="root", callback=param)

r.run()
