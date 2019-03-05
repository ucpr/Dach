import dach

var app = newDach()

proc cb(ctx: DachCtx): DachResp =
  result = newDachResp()
  result.content = jsonResponse("""{"name": "taro"}""")

app.addRoute("/", "index")
app.addView("index", HttpGet, cb)

app.run()
