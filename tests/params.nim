import dach

var app = newDach()

app.post "/":
  echo ctx.query["name"]
  ctx.response("hello index")

app.post "/hoge":
  echo ctx.query["name"]
  ctx.response("hello index")


app.run()
