import json

import dach

var app = newDach()

proc user(): Resp =
  return JsonResponse("""{"user": {"kobashiri": 1, "nanako": 2}}""")

proc index(): Resp =
  let jsonNode =  %*{"name": "Isaac", "books": ["Robot Dreams"]}
  return JsonResponse(jsonNode)

app.addRoute("/", "index")
app.addView("index", HttpGet, index)

app.addRoute("/user", "user")
app.addView("user", HttpGet, user)

app.run()
