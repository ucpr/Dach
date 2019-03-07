import dach

var app = newDach()
 
proc index(ctx: DachCtx): DachResp =
  result = newDachResp()
  result.cookie["name"] = "u_chi_ha_ra_"
  result.content = response("Hello World!")

app.addRoute("/", "index")
app.addView("index", HttpGet, index)

app.run()
