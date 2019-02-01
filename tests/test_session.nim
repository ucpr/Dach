import dach
import dach/[session]
import db_mysql

var app = newDach()

app.session = newSession("127.0.0.1:3314", "root", "root", "dach_sample")

app.session["name"] = "hoge"
assert app.session["name"] == "hoge"

assert app.session.hasKey("name") == true
