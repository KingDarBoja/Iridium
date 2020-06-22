import unittest, tables

import iridium

suite "ISO 3166-1 Tests":

  test "Get all countries":
    check(getAllCountries().len == 249)

  test "Retrieve the country data by code":
    let congo = getCountryByCode("CD")
    check(congo.name == "Congo, The Democratic Republic of the")

  test "Throw KeyError if country code does not exist":
    expect KeyError:
      discard getCountryByCode("TX")


suite "ISO 3166-2 Tests":

  test "Get all subdivisions":
    check(getAllSubdivisions().len == 4883)

  test "Retrieve the subdivision data by code":
    let someYemenSub = getSubdivisionByCode("YE-SN")
    check(someYemenSub.name == "Şan'ā'")

  test "Retrieve the subdivisions by country":
    let colombiaSubs = getSubdivisionsByCountry("CO")
    check(colombiaSubs.len == 33)

  test "Throw KeyError if subdivision code does not exist":
    expect KeyError:
      discard getSubdivisionByCode("CO-AMX")
