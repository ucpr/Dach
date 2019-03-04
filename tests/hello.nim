import dach

var app = newDach()
 
proc index(ctx: DachCtx): Resp =
  response("Hello World!")

app.addRoute("/", "index")
app.addView("index", HttpGet, index)

app.run()
