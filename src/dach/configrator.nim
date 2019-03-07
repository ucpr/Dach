import nativesockets, tables
import strutils

#import parsetoml

const
  DefaultDebug* = true
  DefaultPort* = 8080
  DefaultAddress* = "127.0.0.1"
  DefaultLogFormat* = "[$levelname] $datetime : "

  useHttpBeast* = true

type
  Configurator* = ref object
    debug*: bool
    port*: uint16
    address*: string
#    case isUseSession*: bool:
#      of true:
#        # db_mysql.open
#        sessionConnection*: string  # 127.0.0.1:3314
#        sessionServerUser*: string
#        sessionServerPassword*: string
#        sessionServerDatabase*: string
#
#        secretKey*: string
#      of false:
#        discard


#    logFormat*: string
#    logLevel*: Level

proc newConfigurator*(): Configurator =
  result = new Configurator
  result.debug = DefaultDebug
  result.port = DefaultPort
  result.address = DefaultAddress
#  result.isUseSession = false

#proc loadConfigFile*(filename: string): Configurator =
#  result = new Configurator
#  let tb = parsetoml.parseFile(filename)
#  
#  result.debug = tb["Application"]["debug"].getBool()
#  result.port = uint16(tb["Application"]["port"].getInt())
#  result.address = tb["Application"]["address"].getStr()
#  
#  result.isUseSession = tb["Session"]["isSession"].getBool()
#  if result.isUseSession:
#    let con = tb["Session"]["address"].getStr() & ":" & tb["Session"]["port"].getStr()
#    result.sessionConnection = con
#    result.sessionServerUser = tb["Session"]["user"].getStr()
#    result.sessionServerPassword = tb["Session"]["user"].getStr()
#    result.sessionServerDatabase = tb["Session"]["database"].getStr()
#    result.secretKey = tb["Session"]["secret_Key"].getStr()
