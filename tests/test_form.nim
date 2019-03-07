import dach

var app = newDach()

proc cb(ctx: DachCtx): DachResp =
  result = ctx.newDachResp()
  let
    email = ctx.form["email"]
    pass = ctx.form["password"]
  echo $email, " ", $pass
  result.content = response("Hello World")

app.addRoute("/", "index")
app.addView("index", HttpGet, cb)

app.run()
