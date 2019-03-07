import dach
import strformat

var app = newDach()

proc cb(ctx: DachCtx): DachResp =
  result = ctx.newDachResp()
  let name = ctx.pathquery["name"]
  result.content = response(fmt"Hello {name}")

app.addRoute("/{name}", "index")
app.addView("index", HttpGet, cb)

app.run()
