import tables, strformat

import generated/countries

proc getCountryByCode*(code: string): CountryDivision =
  if Countries.hasKey(code):
    return Countries[code]
  raise newException(KeyError, &"The country code '{code}' does not exist")
