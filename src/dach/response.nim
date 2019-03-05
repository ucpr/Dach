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

  DachCtx* = ref object
    uri*: Uri
    httpmethod*: HttpMethod
    statuscode*: HttpCode
    headers*: HttpHeaders
    cookie*: Cookie
    query*: StringTableRef
    form*: StringTableRef
    req*: Request

  CallBack* = proc (ctx: DachCtx): Resp

proc newDachCtx*(): DachCtx =
  ## Create a new DachCtx instance.
  result = new DachCtx
  result.statuscode = Http200
  result.headers = newhttpheaders()

proc response*(content: string, status: HttpCode = Http200,
              contentType: string = "text/plain", header: HttpHeaders = newhttpheaders()): Resp =
  var h = header
  h["Content-Type"] = contentType
  result = (statuscode: status, content: content, headers: h)

proc jsonResponse*(content: JsonNode,
                  status: HttpCode = Http200, header: HttpHeaders = newhttpheaders()): Resp =
  response($content, contentType="appication/json")

proc jsonResponse*(content: string,
                  status: HttpCode = Http200, header: HttpHeaders = newhttpheaders()): Resp =
  let jsonNode = parseJson(content)
  result = jsonResponse(jsonNode)

proc redirect*(path: string, header: HttpHeaders = newhttpheaders()): Resp =
  var h = header
  h["Location"] = path
  result = (statuscode: Http303,
            content: "Redirecting to <a href=\"$1\">$1</a>" % [path],
            headers: h)

proc staticResponse*(filename: string, staticDir: string = "statics/", status: HttpCode = Http200,
                    header: HttpHeaders = newhttpheaders()): Resp =
  ## response static file.
  ## 
  ## If using it as a product, we recommend that you distribute it with nginx etc.
  let filepath = joinPath(staticDir, filename)
  if not fileExists(filepath):
    return (statuscode: Http404, content: "File NOT FOUND", headers: header)

  let
    n = filepath.readFile
    (_, _, ext) = splitFile(filename)
    mts = newMimetypes()
    contentType = mts.getMimetype(ext.strip(chars={'.'}))
  var h = header
  h["Content-Type"] = contentType
  return (statuscode: status, content: n, headers: h)

