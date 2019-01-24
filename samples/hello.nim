import dach

var app = newDach()

proc helloworld(): Resp =
  return Response("Hello World!")

app.addRoute("/", "index")
app.addView("index", HttpGet, helloworld)

app.run()
