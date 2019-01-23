import logging
import configrator

export logging

proc dachConsoleLogger*(levelThreshold: Level = lvlAll, fmtStr = DefaultLogFormat) =
  var L = newConsoleLogger(levelThreshold = levelThreshold, fmtStr = fmtStr)
  addHandler(L)

proc dachFileLogger*(filename: string = defaultFilename(), levelThreshold: Level = lvlAll, fmtStr = DefaultLogFormat) =
  var fL = newFileLogger(filename, levelThreshold = levelThreshold, fmtStr = fmtStr)
  addHandler(fL)
