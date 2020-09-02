import algorithm, json, strutils, strformat, sequtils, sugar

type
  CurrencyCode = object
    Alphabetic_Code: string
    Currency: string
    Entity: string
    Minor_Unit: int
    Numeric_Code: string
    Withdrawal_Date: string
    Withdrawal_Interval: string

proc generateCurrencyCodes*(generateCodes = true): seq[CurrencyCode] =
  let currencyCodes = parseFile("data/iso-4217-currency-codes.json")
  var tempCurrencies: seq[CurrencyCode]
  for currency in currencyCodes.items:
    var
      munit = newJInt(currency["Minor_Unit"].getInt(-1))
      wdate = newJString(currency["Withdrawal_Date"].getStr)
      winterval = newJString(currency["Withdrawal_Interval"].getStr)
    currency.add("Minor_Unit", munit)
    currency.add("Withdrawal_Date", wdate)
    currency.add("Withdrawal_Interval", winterval)
    tempCurrencies.add(to(currency, CurrencyCode))

  result = tempCurrencies
  # Only generate codes if needed, otherwise return the `filteredRows` data
  if generateCodes:
    let currencyCodes: seq[string] = deduplicate(tempCurrencies.map(x => x.Alphabetic_Code)).filter(x => not x.isEmptyOrWhitespace).sorted()
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
        minor*: int                       ## Relationship between a major currency unit and its corresponding minor currency unit (optional)
        withdrawal*: string               ## Date string, only for ISO-4217-3 currencies which are discontinued (optional)

    const Currencies*: Table[string, CurrencyCode] = [
      """.unindent(4)
    for code in currencyCodes:
      let
        codeData: CurrencyCode = tempCurrencies.filter(r => r.Alphabetic_Code == code)[0]
        name = escape(codeData.Currency, "", "")
        alpha3 = codeData.Alphabetic_Code
        numeric = codeData.Numeric_Code
        minor = codeData.Minor_Unit
        withdrawal = codeData.Withdrawal_Date

      currencyData.add(
        fmt"""("{code}", CurrencyCode(name: "{name}", alpha3: "{alpha3}", numeric: "{numeric}", minor: {minor}, withdrawal: "{withdrawal}")),
        """.unindent(6)
      )
    currencyData.removeSuffix("  ")
    currencyData.add("].toTable")

    writeFile("src/Iridium/generated/currencies.nim", currencyData)


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
      name*: string           ## Country name (short)
      alpha2*: string         ## Two letter alphabetic code of the country
      alpha3*: string         ## Three letter alphabetic code of the country
      numeric*: string        ## Three digit numeric code of the country, including leading zeros
      currency*: string       ## The Currency alpha2 code associated to this country
      official*: string       ## Official name of the country (optional)

  const Countries*: Table[string, CountryDivision] = [
    """.unindent(2)

  let currencyCodes = generateCurrencyCodes(false)

  for country in countryCodes["3166-1"]:
    let
      name = country{"common_name"}.getStr(country["name"].getStr())
      alpha2Code = country["alpha_2"].getStr()
      alpha3Code = country["alpha_3"].getStr()
      numericCode = country["numeric"].getStr()
      officialName = country{"official_name"}.getStr("")
      codesPerCountry: seq[CurrencyCode] = currencyCodes.filter(c => c.Withdrawal_Date == "" and c.Withdrawal_Interval == "" and name.toLowerAscii in c.Entity.toLowerAscii)
    var currencyCode = ""
    if codesPerCountry.len > 1:
      for n in codesPerCountry:
        if cmpIgnoreCase(n.Entity, name) == 0:
          currencyCode = n.Alphabetic_Code
          break
    else:
      currencyCode = if codesPerCountry.len == 1: codesPerCountry[0].Alphabetic_Code else: ""
    # Use string interpolation to create the country constant
    data.add(
      fmt"""("{alpha2Code}", CountryDivision(name: "{name}", alpha2: "{alpha2Code}", alpha3: "{alpha3Code}", numeric: "{numericCode}", currency: "{currencyCode}", official: "{officialName}")),
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
    let
      code = subdivision["code"].getStr()
      name = subdivision["name"].getStr()
      category = subdivision["type"].getStr()
      parent = subdivision{"parent"}.getStr()
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
    let
      name = country["name"].getStr()
      alpha2Code = country["alpha_2"].getStr()
      alpha3Code = country["alpha_3"].getStr()
      alpha4Code = country["alpha_4"].getStr()
      numericCode = country{"numeric"}.getStr()
      withdrawal = country{"withdrawal_date"}.getStr("")
      comment = country{"comment"}.getStr("")
    # Use string interpolation to create the country constant
    data.add(
      fmt"""("{alpha2Code}", FormerCountryDivision(name: "{name}", alpha2: "{alpha2Code}", alpha3: "{alpha3Code}", alpha4: "{alpha4Code}", numeric: "{numericCode}", withdrawal: "{withdrawal}", comment: "{comment}")),
      """.unindent(4)
    )
  data.removeSuffix("  ")
  data.add("].toTable")

  writeFile("src/Iridium/generated/former_countries.nim", data)
