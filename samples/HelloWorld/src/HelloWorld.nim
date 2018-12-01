import dach

var app = newRouter()

proc hello(p: dachParams): respObj =
  return Response("Hello World")

app.addRule("/hello", "GET", "helloworld", hello)

app.run()
