import dach

var app = newDach()
 
proc index(ctx: DachCtx): DachResp =
  result = newDachResp()
  result.content = response("Hello World!")

app.addRoute("/", "index")
app.addView("index", HttpGet, index)

app.run()
