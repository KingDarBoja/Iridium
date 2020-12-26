import unittest, tables

import iridium

suite "ISO 3166-1 Tests":

  test "Get all countries":
    check(getAllCountries().len == 249)

  test "Retrieve the country data by its alpha2 code":
    let country = getCountryByCode("CD")
    check(country.name == "Congo, The Democratic Republic of the")

  test "Retrieve the country data by its alpha3 code":
    let country = getCountryByAlpha3("HMD")
    check(country.name == "Heard Island and McDonald Islands")

  test "Retrieve the country data by its name":
    let country = getCountryByName("Honduras")
    check(country.name == "Honduras")

  test "Retrieve the country data by its numeric code":
    let countryA = getCountryByNumeric("050")
    check(countryA.name == "Bangladesh")
    let countryB = getCountryByNumeric(48)
    check(countryB.name == "Bahrain")

  test "Throw KeyError if country alpha2 code does not exist":
    expect KeyError:
      discard getCountryByCode("TX")

  test "Throw KeyError if country numeric code does not exist":
    expect KeyError:
      discard getCountryByNumeric(1000)


suite "ISO 3166-2 Tests":

  test "Get all subdivisions":
    check(getAllSubdivisions().len == 4883)

  test "Retrieve the subdivision data by code":
    let someYemenSub = getSubdivisionByCode("YE-SN")
    check(someYemenSub.name == "Şan'ā'")

  test "Retrieve the subdivision data by code (variant)":
    let someYemenSub = getSubdivisionByCode("YE", "SN")
    check(someYemenSub.name == "Şan'ā'")

  test "Retrieve the subdivisions by country":
    let colombiaSubs = getSubdivisionsByCountry("CO")
    check(colombiaSubs.len == 33)

  test "Throw KeyError if subdivision code does not exist":
    expect KeyError:
      discard getSubdivisionByCode("CO-AMX")

  test "Throw KeyError if subdivision code does not exist (variant)":
    expect KeyError:
      discard getSubdivisionByCode("CO", "AMX")


suite "ISO 3166-3 Tests":

  test "Get all former countries":
    check(getAllFormerCountries().len == 30)

  test "Retrieve the country data by its alpha2 code":
    let country = getFormerCountryByCode("AN")
    check(country.name == "Netherlands Antilles")

  test "Retrieve the country data by its alpha3 code":
    let country = getFormerCountryByAlpha3("HVO")
    check(country.name == "Upper Volta, Republic of")

  test "Retrieve the country data by its alpha4 code":
    let country = getFormerCountryByAlpha4("NTHH")
    check(country.name == "Neutral Zone")

  test "Retrieve the country data by its name":
    let country = getFormerCountryByName("USSR, Union of Soviet Socialist Republics")
    check(country.name == "USSR, Union of Soviet Socialist Republics")

  test "Retrieve the country data by its numeric code":
    let countryA = getFormerCountryByNumeric("180")
    check(countryA.name == "Zaire, Republic of")


suite "ISO 4217 Tests":

  test "Get all currencies":
    check(getAllCurrencies().len == 298)

  test "Retrieve the currency data by its alphabetic code":
    let curr = getCurrencyByCode("AOA")
    check(curr.name == "Kwanza")
