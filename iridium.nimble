# Package


version       = "0.3.2"
author        = "KingDarBoja"
description   = "The International Standard for country codes and codes for their subdivisions on Nim (ISO-3166)"
license       = "MIT"
srcDir        = "src"
skipDirs      = @["crawler"]


# Dependencies

requires "nim >= 1.2.0"

task test, "Runs the test suite":
  exec "nim c -r tests/tests"
