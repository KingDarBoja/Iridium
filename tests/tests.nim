import unittest

import iridium

suite "ISO 3166-1 Tests":

  test "Retrieve the country data by code":
    let congo = getCountryByCode("CD")
    check(congo.name == "Congo, The Democratic Republic of the")

  test "Throw KeyError if country code does not exist":
    expect KeyError:
      discard getCountryByCode("TX")

