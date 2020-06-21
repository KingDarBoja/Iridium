import json, strutils, strformat

proc generateCountryCodes*(): void =
  let countryCodes = parseFile("data/iso_3166-1.json")
  var data: string = """
  ## ISO 3166-1 Codes for the representation of names of countries and their subdivisions – Part 1: Country codes
  ## ISO 3166 has three parts: codes for countries, codes for subdivisions and formerly used codes (codes that were once used to describe countries but are no longer in use).
  ##
  ## The country codes can be represented either as a two-letter code (alpha-2) which is recommended as the general-purpose code,
  ## a three-letter code (alpha-3) which is more closely related to the country name and a three-digit numeric code (numeric-3) which can be useful if you need to avoid using Latin script.
  ##
  ## ================== AUTO-GENERATED FILE, DO NOT EDIT ==================
  import tables

  type
    CountryDivision* = object
      name*: string       ## Country name (short)
      alpha2*: string     ## Two letter alphabetic code of the country
      alpha3*: string     ## Three letter alphabetic code of the country
      numeric*: string    ## Three digit numeric code of the country, including leading zeros
      official*: string   ## Official name of the country (optional)

  const Countries*: Table[string, CountryDivision] = [
    """.unindent(2)

  for country in countryCodes["3166-1"]:
    let name = country{"common_name"}.getStr(country["name"].getStr())
    let alpha2Code = country["alpha_2"].getStr()
    let alpha3Code = country["alpha_3"].getStr()
    let numericCode = country["numeric"].getStr()
    let officialName = country{"official_name"}.getStr("")
    # Use string interpolation to create the country constant
    data.add(
      fmt"""("{alpha2Code}", CountryDivision(name: "{name}", alpha2: "{alpha2Code}", alpha3: "{alpha3Code}", numeric: "{numericCode}", official: "{officialName}")),
      """.unindent(4)
    )
  data.removeSuffix("  ")
  data.add("].toTable")

  writeFile("src/Iridium/generated/countries.nim", data)

generateCountryCodes()
