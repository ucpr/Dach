import dach

var app = newDach()
 
proc index(): Resp =
  return Response("Hello World!")

proc user(): Resp =
  return Response("Hello User!")

app.addRoute("/", "index")
app.addRoute("/hoge", "hoge")

app.addView("index", HttpGet, index)
app.addView("hoge", HttpGet, user)

app.run()
