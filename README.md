<div align="center">
  <img src="img/logo.svg" width=350>
</div>

<div align="right">Design by <a href="https://github.com/10riridk0">@10riridk0</a></div>

<div align="center">
  <img src="https://travis-ci.com/ucpr/Dach.svg?branch=master">
  <img src="https://img.shields.io/github/license/MasoniteFramework/core.svg" alt="License"> 
</div>

---

## Description
Dach is a tiny web application framework. This project started with SecHack365.  

NOTE: This is still a beta version. Please note that destructive changes will be made.

## Requirement

- Nim >= 0.18.0
- nest
- httpbeast

## Install

```
$ git clone https://github.com/ucpr/dach
$ cd dach
$ nimble install
```

```
$ docker pull ucpr/dach
```

## Example

This is a simple example

```nim
import dach

var app = newDach()

proc cb(ctx: DachCtx): DachResp =
  result = newDachResp()
  result.content = response("Hello World")

app.addRoute("/", "index")
app.addView("index", HttpGet, cb)

app.run()
```

or 

```nim
import dach
var app = newDach()
      
app.get "/":
  result.content = response("Hello World")
      
app.run()
```

## Usage
Please check it! [ucpr.github.io/Dach/doc/dach.html](https://ucpr.github.io/Dach/doc/dach.html)

## Author
Taichi Uchihara (@u\_chi\_ha\_ra\_)

## License
MIT

