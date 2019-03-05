import dach

var app = newDach()

proc cb(ctx: DachCtx): DachResp =
  result = newDachResp()
  result.content = staticResponse("index.html")

app.addRoute("/", "index")
app.addView("index", HttpGet, cb)

app.run()
