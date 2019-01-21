import tables

type
  ConfigValues = enum
    Debug,
    Port,
    ServerName,

  Config = ref object

proc loadConfigFile() =
  discard
