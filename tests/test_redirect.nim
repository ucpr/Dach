import dach

var app = newDach()
 
app.get "/":
  result.content = response("Hello World")

app.get "/redirect":
  result.redirect("/")

app.run()
