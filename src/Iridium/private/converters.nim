import json, strutils, strformat

proc generateCountryCodes*(): void =
  let countryCodes = parseFile("data/iso_3166-1.json")
  var data: string = """
  ## ISO 3166-1 Codes for the representation of names of countries and their subdivisions – Part 1: Country codes
  ## Defines codes for the names of countries, dependent territories, and special areas of geographical interest.
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


proc generateSubdivisionCodes*(): void =
  let subdivisionCodes = parseFile("data/iso_3166-2.json")
  var data: string = """
  ## ISO 3166-2 Codes for the representation of names of countries and their subdivisions – Part 2: Country subdivision code
  ## Defines codes for the names of the principal subdivisions (e.g., provinces, states, departments, regions)
  ## of all countries coded in ISO 3166-1.
  ##
  ## The codes for subdivisions are represented as the alpha-2 code for the country, followed by up to three characters.
  ## For example ID-RI is the Riau province of Indonesia and NG-RI is the Rivers province in Nigeria.
  ## Names and codes for subdivisions are usually taken from relevant official national information sources.
  ##
  ## ================== AUTO-GENERATED FILE, DO NOT EDIT ==================
  import tables

  type
    CountrySubdivision* = object
      name*: string        ## Name of the country subdivision
      category*: string    ## Type of subdivision of the country (i.e. Province, Region, Emirate)
      parent*: string      ## Parent of the country subdivision

  const Subdivisions*: Table[string, CountrySubdivision] = [
    """.unindent(2)

  for subdivision in subdivisionCodes["3166-2"]:
    let code = subdivision["code"].getStr()
    let name = subdivision["name"].getStr()
    let category = subdivision["type"].getStr()
    let parent = subdivision{"parent"}.getStr()
    # Use string interpolation to create the subdivision constant
    data.add(
      fmt"""("{code}", CountrySubdivision(name: "{name}", category: "{category}", parent: "{parent}")),
      """.unindent(4)
    )
  data.removeSuffix("  ")
  data.add("].toTable")

  writeFile("src/Iridium/generated/subdivisions.nim", data)


generateSubdivisionCodes()
