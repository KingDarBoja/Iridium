import algorithm, json, strutils, strformat, sequtils
import xlsx


## Used to check the `minor` column of the currency xls file,
## which can be a positive integer or zero but also "N/A"
proc isInteger(value: string): bool =
  result = true
  try:
    discard parseInt(value)
  except ValueError:
    result = false


proc generateCurrencyCodes*(): void =
  let
    countryData = parseFile("data/iso_3166-1.json")
    sheetName = "Active"
    data = parseExcel("data/iso_4217_per_country.xlsx", sheetName)
    rows = data[sheetName].toSeq(false)
    lastIndex = find(map(rows, proc (x: seq[string]): string = x[0]), "ZIMBABWE")
    filteredRows = map(rows[4 .. lastIndex], proc (x: seq[string]): seq[string] = x[0 .. 4])
    currencyCodes: seq[string] = sorted(
      filter(
        deduplicate(
          map(
            filteredRows,
            proc (x: seq[string]): string = x[2]
          ),
        ),
        proc (x: string): bool = not x.isEmptyOrWhitespace
      )
    )

  var currencyData: string = """
  ## ISO 4217 Codes for the representation of currency codes.
  ## Is a standard first published by International Organization for Standardization in 1978, which delineates
  ## currency designators, country codes (alpha and numeric), and references to minor units.
  ##
  ## This standard establishes internationally recognized codes for the representation of currencies that enable
  ## clarity and reduce errors. Currencies are represented both numerically and alphabetically, using either
  ## three digits or three letters.
  ##
  ## ================== AUTO-GENERATED FILE, DO NOT EDIT ==================
  import tables

  type
    CurrencyCode* = object
      name*: string                     ## Currency name
      alpha3*: string                   ## Three letter alphabetic code of the currency
      numeric*: string                  ## Three digit numeric code of the country, including leading zeros
      minor*: number                    ## Relationship between a major currency unit and its corresponding minor currency unit (optional)

  const Currencies*: Table[string, CurrencyCode] = [
    """.unindent(2)
  for code in currencyCodes:
    let
      codeData = filter(filteredRows, proc (r: seq[string]): bool = r[2] == code)[0]
      name = codeData[1]
      alpha3 = codeData[2]
      numeric = codeData[3]
      minor = if isInteger(codeData[4]): parseInt(codeData[4]) else: -1

    currencyData.add(
      fmt"""("{code}", CurrencyCode(name: "{name}", alpha3: "{alpha3}", numeric: "{numeric}", official: "{minor}")),
      """.unindent(4)
    )
  currencyData.removeSuffix("  ")
  currencyData.add("].toTable")

  writeFile("src/Iridium/generated/currencies.nim", currencyData)

generateCurrencyCodes()

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


proc generateFormelyCountryCodes*(): void =
  let oldCountryCodes = parseFile("data/iso_3166-3.json")
  var data: string = """
  ## Codes for the representation of names of countries and their subdivisions – Part 3: Code for formerly used names of countries
  ## Defines codes for country names which have been deleted from ISO 3166-1 since its first publication in 1974.
  ##
  ## The formerly used codes are four-letter codes (alpha-4). How the alpha-4 codes are constructed depends on the reason why
  ## the country name has been removed.
  ##
  ## ================== AUTO-GENERATED FILE, DO NOT EDIT ==================
  import tables

  type
    FormerCountryDivision* = object
      name*: string         ## Country name (short)
      alpha2*: string       ## Two letter alphabetic code of the country
      alpha3*: string       ## Three letter alphabetic code of the country
      alpha4*: string       ## Four letter alphabetic code of the country
      numeric*: string      ## Three digit numeric code of the country, including leading zeros (optional)
      withdrawal*: string   ## Withdrawal date
      comment*: string      ## Comment for the country, not the reason though (optional)

  const FormerCountries*: Table[string, FormerCountryDivision] = [
    """.unindent(2)

  for country in oldCountryCodes["3166-3"]:
    let name = country["name"].getStr()
    let alpha2Code = country["alpha_2"].getStr()
    let alpha3Code = country["alpha_3"].getStr()
    let alpha4Code = country["alpha_4"].getStr()
    let numericCode = country{"numeric"}.getStr()
    let withdrawal = country{"withdrawal_date"}.getStr("")
    let comment = country{"comment"}.getStr("")
    # Use string interpolation to create the country constant
    data.add(
      fmt"""("{alpha2Code}", FormerCountryDivision(name: "{name}", alpha2: "{alpha2Code}", alpha3: "{alpha3Code}", alpha4: "{alpha4Code}", numeric: "{numericCode}", withdrawal: "{withdrawal}", comment: "{comment}")),
      """.unindent(4)
    )
  data.removeSuffix("  ")
  data.add("].toTable")

  writeFile("src/Iridium/generated/former_countries.nim", data)
