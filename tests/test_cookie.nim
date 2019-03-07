import dach

var app = newDach()

app.get "/":
  result.cookie["name"] = "taro"
  result.content = response("Hello World")

app.get "/rm":
  result.cookie.pop("name")
  result.content = response("/rm")

app.get "/check":
  result.content = response("CHECK")

app.run()
