##[
  TODO: Document Me!
]##

import algorithm, json, options, os, strformat, strutils, system, tables
import halonium
import iridium

let baseUrl = "https://www.iso.org/obp/ui/#iso:code:3166:"


proc sortBySubdivisionCode(x, y: CountrySubdivision): int =
  result = cmp(x.code, y.code)


proc getSubdivisionTableFromURL(session: Session, code: string): seq[CountrySubdivision] =
  session.navigate(baseUrl & code)
  sleep(8000)

  let tableElement = session.waitForElement("subdivision", strategy=IDSelector).get()
  let tableRows = tableElement.findElements("tbody tr", strategy=TagNameSelector)
  var countryRowData: seq[CountrySubdivision] = @[]
  # Skip those countries without subdivisions
  if tableRows.len == 0:
    return
  for tr in tableRows:
    let rowCells = tr.findElements("td", strategy=TagNameSelector)
    # echo tr.visibleText
    # Define similar schema
    let
      category = rowCells[0].visibleText.capitalizeAscii
      name = rowCells[2].visibleText
      parent = rowCells[6].visibleText.split('-')
    # The 3166-2 code column has an asterisk as suffix for some countries.
    var code = rowCells[1].visibleText
    code.removeSuffix('*')
    # Push into the sequence
    countryRowData.add(
      CountrySubdivision(
        `type`: category,
        code: code,
        name: name,
        parent: if parent.len > 1: parent[1] else: parent[0]
      )
    )

  countryRowData.sort(sortBySubdivisionCode)
  result = countryRowData


proc main(countries: OrderedTable[string, CountryDivision]): OrderedTable[string, seq[CountrySubdivision]] =
  let session = createSession(
    Chrome,
    browserOptions = chromeOptions(
      # pageLoadStrategy=option(plsEager),
      experimentalOptions=parseJson("""{"excludeSwitches": ["enable-logging"]}""")
    )
  )
  # session.implicitWait=(5)
  # var count = 0
  for countryCode in countries.keys():
    let countryCode = countryCode
    echo &"Fetching Country Data - Code: {countryCode}"
    result[countryCode] = getSubdivisionTableFromURL(session, countryCode)
    # inc(count)
    # if (count > 5):
    #   break

  session.stop()


let allCountries = getAllCountries()
let rawData = main(allCountries)

## Extra Logging to compare.
# echo &"Total Country Count {rawData.len}"
# echo "======================================"
# for code, val in rawData:
#   let countryName = allCountries.getOrDefault(code).name
#   echo &"---------- {countryName} - {code} ----------"
#   for sub in val:
#     echo sub

let outputJsonData = %* rawData
let outputFile = open("iso_3166-2_experimental.json", fmWrite)
outputFile.write(outputJsonData)
outputFile.close()
