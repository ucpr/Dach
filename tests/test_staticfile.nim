import dach

var app = newDach()

proc cb(ctx: DachCtx): Resp =
  staticResponse("index.html")

app.addRoute("/", "index")
app.addView("index", HttpGet, cb)

app.run()
