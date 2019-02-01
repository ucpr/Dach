import dach

var app = newDach()
 
proc index(ctx: DachCtx): Resp =
  ctx.cookie["name"] = "u_chi_ha_ra_"
  ctx.response("Hello World!")

app.addRoute("/", "index")
app.addView("index", HttpGet, index)

app.run()
