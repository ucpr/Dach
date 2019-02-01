import dach

var app = newDach()
 
app.get "/":
  ctx.response("Hello World")

app.get "/hoge":
  redirect("/")

app.run()
