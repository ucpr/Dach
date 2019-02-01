import dach
import json

var app = newDach()

app.get "/":
  ctx.response("Hello World!")

app.get "/json":
  ctx.jsonResponse(%*{"name": "u_chi_ha_ra_"})

## or

proc hoge(ctx: DachCtx): Resp =
  redirect("/")

app.addRoute("/hoge", "hoge")
app.addView("hoge", HttpGet, hoge)

app.run()
