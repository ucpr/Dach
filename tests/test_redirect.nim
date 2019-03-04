import dach

var app = newDach()
 
app.get "/":
  response("Hello World")

app.get "/hoge":
  redirect("/")

app.run()
