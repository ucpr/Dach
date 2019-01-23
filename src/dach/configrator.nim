import nativesockets, tables

const
  DefaultDebug* = true
  DefaultPort* = 8080
  DefaultAddress* = "127.0.0.1"
  DefaultLogFormat* = "[$levelname] $datetime : "

type
  Configrator* = ref object
    debug*: bool
    port*: uint16
    address*: string
#    logFormat*: string
#    logLevel*: Level

proc newConfigurator*(): Configrator =
  result = new Configrator

proc loadConfigFile*(): Configrator =
  discard
