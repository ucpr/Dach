# Package

version       = "0.1.0"
author        = "u_chi_ha_ra_"
description   = "Dach"
license       = "MIT"
srcDir        = "src"

# Dependencies

requires "nim >= 0.18.0"

#requires "parsetoml"
requires "nest"
requires "nimAES"

when not defined(windows):
  requires "httpbeast"
