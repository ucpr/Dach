import dach
import tables
import json

var app = newRouter()

proc hello(p: dachParams): respObj =
  return Response("Hello World")

proc jsonResp(p: dachParams): respObj =
  let content = %*[{"languages": ["Nim", "Python3", "C++", "Go", "Rust"]}]
  return JsonResponse(content)

proc paramsResp(p: dachParams): respObj =
  let content = %*[{"params": [p["poyo"], p["hoge"]]}]
  return JsonResponse(content)

app.addRule("/hello", "GET", "hello", hello)
app.addRule("/api/languages", "GET", "lang", jsonResp)
app.addRule("/api/{poyo}/{hoge}", "GET", "params", paramsResp)

app.run()
