# Package

version     = "0.1.0"
author      = "Garett Bass"
description = "xo.nim"
license     = "MIT"
srcDir      = "src"

# Dependencies

requires "nim >= 1.4.8"

when defined(windows):
  requires "direct3d >= 0.3.0"