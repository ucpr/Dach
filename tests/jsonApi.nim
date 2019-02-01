import dach

var app = newDach()

proc cb(ctx: DachCtx): Resp =
  ctx.jsonResponse("""{"name": "taro"}""")

app.addRoute("/", "index")
app.addView("index", HttpGet, cb)

app.run()
