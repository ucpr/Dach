import dach

import asynchttpserver

import sequtils, random, std/sha1, cookies, strtabs
import strutils, logging
import db_mysql

import html

randomize()

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

proc debugDBprint() =
  # DBの中身全部プリントしちゃうお
  echo "\n" & "===========================" & "\n"
  for i in db.rows(sql"select * from user_table"):
    echo i
  echo "\n" & "===========================" & "\n"

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

proc checkSession(req: Request): bool =
  if not req.headers.hasKey("cookie"):
    return false

  let cookieTable = req.headers["cookie"].parseCookies()
  if req.headers.hasKey("cookie") and cookieTable["username"] != "":
    return true
  else:
    return false

proc loggedInPage(ctx: DachCtx): Resp =
  if checkSession(ctx.req):
    ctx.response(loggedInContent)
  else:
    ctx.redirect("/")

proc regist(ctx: DachCtx): Resp =  # post
  let
    username = ctx.form["email"]
    password = ctx.form["password"]
    existsUser = db.getValue(sql"SELECT password FROM user_table WHERE username=?", username)

  if existsUser == "":  # userが登録されてない場合
    register(username, password)
    ctx.cookie["username"] = username
    return ctx.redirect("/logged_in")  ## ここはlogin後のページ
  else:  # 登録されていたらindexにredirect
    return ctx.redirect("/")  ## loginページ

proc login(ctx: DachCtx): Resp =  # post
#  debugDBprint()
  let
    username = ctx.form["email"]
    password = ctx.form["password"]
    digitPass = db.getValue(sql"SELECT password FROM user_table WHERE username=?", username)
    salt = db.getValue(sql"SELECT salt FROM user_table WHERE username=?", username)

  if digitPass == "":  
    # userが登録されてない場合は register にredirect
    info("userが登録されていません")
    return ctx.redirect("/")
  else:
    if password == digitPass:  
      # 登録されてたらcookieにusernameをいれてctx.redirectする
      ctx.cookie["username"] = username
      return ctx.redirect("/logged_in")
    else:
      ## passwordの間違いなのでloginにctx.redirectさせる
      info("passwordの間違いかもしれない")
      return ctx.redirect("/")

proc logout(ctx: DachCtx): Resp =  # post
#  let
#    username = ctx.form["email"]
#  app.session.del(username)
  ctx.redirect("/")

app.get("/debug"):
  debugDBprint()
  ctx.redirect("/")

app.addRoute("/", "index")
app.addRoute("/register", "regist")
app.addRoute("/login", "login")
app.addRoute("/logout", "logout")
app.addRoute("/logged_in", "logged_in")

app.addView("index", HttpGet, index)
app.addView("regist", HttpGet, viewRegist)
app.addView("logged_in", HttpGet, loggedInPage)

app.addView("regist", HttpPost, regist)
app.addView("login", HttpPost, login)
app.addView("logout", HttpPost, logout)

app.run()

