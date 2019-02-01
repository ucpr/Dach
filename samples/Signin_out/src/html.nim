#
# https://getbootstrap.com/docs/4.2/examples/sign-in/
#

import htmlgen

let customCSS = """
body,html{height:100%}body{display:-ms-flexbox;display:flex;-ms-flex-align:center;align-items:center;padding-top:40px;padding-bottom:40px;background-color:#f5f5f5}.form-signin{width:100%;max-width:330px;padding:15px;margin:auto}.form-signin .checkbox{font-weight:400}.form-signin .form-control{position:relative;box-sizing:border-box;height:auto;padding:10px;font-size:16px}.form-signin .form-control:focus{z-index:2}.form-signin input[type=email]{margin-bottom:-1px;border-bottom-right-radius:0;border-bottom-left-radius:0}.form-signin input[type=password]{margin-bottom:10px;border-top-left-radius:0;border-top-right-radius:0}
"""

let indexContent* = "<!DOCTYPE html>" & html(
  head(
    meta(charset="utf-8"),
    title("sample"),
    link(rel="stylesheet", href="https://stackpath.bootstrapcdn.com/bootstrap/4.2.1/css/bootstrap.min.css"),
    style(customCSS),
  ),

  body(class="text-center",
    form(class="form-signin", action="/login", `method`="post",
      h1(class="h3 mb-3 font-weight-normal", "Please Sign in"),
      label(`for`="inputEmail", class="sr-only", "Email Address"),
      input(`type`="email", name="email", id="inputEmail", class="form-control", placeholder="Email Address"),
      label(`for`="inputPassword", class="sr-only", "Password"),
      input(`type`="password", name="password", id="inputPassword", class="form-control", placeholder="Password"),
      button(class="btn btn-lg btn-primary btn-block", `type`="submit", "Sign in"),
      a(href="/register", "Regist"),
      p(class="mt-5 mb-3 text-muted", "&copy; 2019"),
    )
  )
)

let loggedInContent* = "<!DOCTYPE html>" & html(
  head(
    meta(charset="utf-8"),
    title("sample"),
    link(rel="stylesheet", href="https://stackpath.bootstrapcdn.com/bootstrap/4.2.1/css/bootstrap.min.css"),
    style(customCSS),
  ),
  body(class="text-center",
    form(class="form-signin", action="/logout", `method`="post",
      h1("This is ログイン後のページです。"),
      button(class="btn btn-lg btn-primary btn-block", `type`="submit", "Logout"),
      p(class="mt-5 mb-3 text-muted", "&copy; 2019"),
    )
  )
)

let registContent* = "<!DOCTYPE html>" & html(
  head(
    meta(charset="utf-8"),
    title("sample"),
    link(rel="stylesheet", href="https://stackpath.bootstrapcdn.com/bootstrap/4.2.1/css/bootstrap.min.css"),
    style(customCSS),
  ),

  body(class="text-center",
    form(class="form-signin", action="/register", `method`="post",
      h1(class="h3 mb-3 font-weight-normal", "Please regist"),
      label(`for`="inputEmail", class="sr-only", "Email Address"),
      input(`type`="email", name="email", id="inputEmail", class="form-control", placeholder="Email Address"),
      label(`for`="inputPassword", class="sr-only", "Password"),
      input(`type`="password", name="password", id="inputPassword", class="form-control", placeholder="Password"),
      button(class="btn btn-lg btn-primary btn-block", `type`="submit", "regist!"),
      a(href="/", "Login"),
      p(class="mt-5 mb-3 text-muted", "&copy; 2019"),
    )
  )
)

