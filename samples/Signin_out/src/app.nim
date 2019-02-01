import dach

import sequtils, random, std/sha1
import strutils
import db_mysql

import html

var app = newDach("config.toml")
# dbを別で使うときはopenしたやつを渡してあげる
app.session = newSession("127.0.0.1:3314", "root", "root", "dach_sample")
let db = app.session

## Init Database
#db.exec(sql"""
#CREATE TABLE user_table (
#  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
#  username VARCHAR(32) NOT NULL,
#  password VARCHAR(32) NOT NULL,
#  salt VARCHAR(32) NOT NULL)""")

proc randomStr(n: int): string =
  result = ""
  let list = "abcdefghjklmnopqlstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0987654321"
  for i in countup(0, n-1):
    result.add(rand(list))

proc register(username, password: string) =
  let  
    salt = randomStr(15)
#    passDigest = sha1.`$`(secureHash(password & salt)).toHex()
#  db.exec(sql"INSERT INTO user_table (username, password, salt) VALUES (?, ?, ?)", username, passDigest, salt)
  db.exec(sql"INSERT INTO user_table (username, password, salt) VALUES (?, ?, ?)", username, password, salt)

proc index(ctx: DachCtx): Resp =  # get
  ctx.response(indexContent)

proc viewRegist(ctx: DachCtx): Resp = # get
  ctx.response(registContent)

proc loggedInPage(ctx: DachCtx): Resp =
  ctx.response("This is logged in page!")

proc regist(ctx: DachCtx): Resp =  # post
  let
    username = ctx.form["email"]
    password = ctx.form["password"]
    existsUser = db.getValue(sql"SELECT password FROM user_table WHERE username=?", username)

  if existsUser == "":  # userが登録されてない場合
    register(username, password)
    app.session[username] = username
    return redirect("/")  ## ここはlogin後のページ
  else:  # 登録されていたらindexにredirect
    return redirect("/")  ## loginページ

proc login(ctx: DachCtx): Resp =  # post
  let
    username = ctx.form["email"]
    password = ctx.form["password"]
  
  # Sessionに残っているかを確認
  if app.session.hasKey(username):
    return redirect("/")
  else:
    let
      digitPass = db.getValue(sql"SELECT password FROM user_table WHERE username=?", username)
      salt = db.getValue(sql"SELECT salt FROM user_table WHERE username=?", username)

    if digitPass == "":  # userが登録されてない場合
      return redirect("/register")
    else:
      if password == digitPass:
        app.session[username] = username
      return redirect("/")
#      if sha1.`$`(secureHash(password & salt)).toHex() == digitPass:
#        app.session[username] = username
#      else:
#        return redirect("/")

proc logout(ctx: DachCtx): Resp =  # post
  let
    username = ctx.form["email"]
  app.session.del(username)
  redirect("/")

app.addRoute("/", "index")
app.addRoute("/register", "regist")
app.addRoute("/login", "login")
app.addRoute("/logout", "logout")
app.addRoute("/logged_in", "logged_in")

app.addView("index", HttpGet, index)

app.addView("regist", HttpGet, viewRegist)
app.addView("regist", HttpPost, regist)

app.addView("login", HttpPost, login)
app.addView("logout", HttpPost, logout)

app.addView("logged_in", HttpGet, loggedInPage)

app.run()
