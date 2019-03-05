import dach
import json

var app = newDach()

app.get "/json":
  let
    content = %*{"hoge": "poyo"}
  result.content = jsonResponse(content)

proc cb(ctx: DachCtx): DachResp =
  result = newDachResp()
  result.content = jsonResponse("""{"name": "taro"}""")

app.addRoute("/", "index")
app.addView("index", HttpGet, cb)

app.run()
