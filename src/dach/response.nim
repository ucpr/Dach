import json
import strtabs
import httpcore
import strutils
import uri
import mimetypes, os, streams

import cookie, configrator

when useHttpBeast:
  import httpbeast
else:
  import asynchttpserver

type
  Resp* = tuple
    statuscode: HttpCode
    content: string
    headers: HttpHeaders

  DachContent* = tuple
    content: string
    mimetype: string

  DachResp* = ref object # memo: resp
    cookie*: Cookie
    statuscode*: HttpCode
    headers*: HttpHeaders
    content*: DachContent
    session*: StringTableRef

  DachCtx* = ref object  # memo: response object
    uri*: Uri
    httpmethod*: HttpMethod
    statuscode*: HttpCode
    headers*: HttpHeaders
    cookie*: Cookie
    query*: StringTableRef
    form*: StringTableRef
    req*: Request

  CallBack* = proc (ctx: DachCtx): DachResp

proc newDachCtx*(): DachCtx =
  ## Create a new DachCtx instance.
  result = new DachCtx
  result.statuscode = Http200
  result.headers = newhttpheaders()

proc newDachResp*(ctx: DachCtx = newDachCtx()): DachResp =
  ## Create a new Dach Response instance
  result = new DachResp
  result.statuscode = ctx.statuscode
  result.headers = ctx.headers
  result.session = newStringTable()

proc response*(content: string, contentType: string = "text/plain"): DachContent =
  result = (content: content, mimetype: contentType)

proc jsonResponse*(content: JsonNode): DachContent =
  response($content, contentType="application/json")

proc jsonResponse*(content: string): DachContent =
  let jsonNode = parseJson(content)
  result = jsonResponse(jsonNode)

proc redirect*(resp: var DachResp, path: string) =
  ##  redirect to `path`
  ##
  ## .. code-block::nim
  ##    proc cb(ctx: DachCtx): DachResp =
  ##      result = newDachResp()
  ##      result.redirect("/red")
  ##
  resp.headers["Location"] = path
  resp.statuscode = Http303
  resp.content = (content: "Redirecting to <a href=\"$1\">$1</a>" % [path],
                  mimetype: "text/html")

proc staticResponse*(filename: string, staticDir: string = "statics/"): DachContent =
  ## response static file.
  ## 
  ## If using it as a product, we recommend that you distribute it with nginx etc.
  let filepath = joinPath(staticDir, filename)
  if not fileExists(filepath):
    return response("FILE NOT FOUND")

  let
    n = filepath.readFile
    (_, _, ext) = splitFile(filename)
    mts = newMimetypes()
    mimetype = mts.getMimetype(ext.strip(chars={'.'}))
  return response(n, mimetype)

