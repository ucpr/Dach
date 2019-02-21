<div align="center">
  <img src="img/logo.svg" width=350>
</div>

<div align="right">Design by <a href="https://github.com/10riridk0">@10riridk0</a></div>

<div align="center">
  <img src="https://travis-ci.com/nve3pd/Dach.svg?branch=master">
  <img src="https://img.shields.io/github/license/MasoniteFramework/core.svg" alt="License"> 
</div>

---

## Description
Dach is a tiny web application framework. This project started with SecHack365.  

NOTE: This is still a dev version. 

## Requirement

- Nim >= 0.18.0
- nest
- httpbeast

## Install

```
$ git clone https://github.com/nve3pd/dach
$ cd dach
$ nimble install
```

```
$ docker pull nve3pd/dach
```

## Example

This is a simple example

```nim
import dach

var app = newDach()

proc cb(ctx: DachCtx): Resp =
  ctx.response("Hello World")

app.addRoute("/", "index")
app.addView("index", HttpGet, cb)

app.run()
```

or 

```nim
import dach
var app = newDach()
      
app.get "/":
  ctx.response("Hello World")
      
app.run()
```

## Usage
Please reading [dach.html](https://nve3pd.github.io/Dach/doc/dach.html)

## Author
Taichi Uchihara (@u\_chi\_ha\_ra\_)

## License
MIT

