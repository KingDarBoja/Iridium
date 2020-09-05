import tables, strformat, strutils

import private/converters


proc getAllCountries*(): Table[string, CountryDivision] = Countries


proc getCountryByCode*(code: string): CountryDivision =
  ## Get the country by its code (alpha2 Code).
  if Countries.hasKey(code):
    return Countries[code]
  raise newException(KeyError, &"The country with the code '{code}' does not exist")


proc getCountryByName*(countryName: string): CountryDivision =
  for countryCode, country in Countries.pairs:
    if (countryName == country.name):
      return country
  raise newException(KeyError, &"The country with the name '{countryName}' was not found")


proc getCountryByAlpha3*(alpha3Code: string): CountryDivision =
  for countryCode, country in Countries.pairs:
    if (alpha3Code == country.alpha3):
      return country
  raise newException(KeyError, &"The country with the alpha3 code '{alpha3Code}' was not found")


proc getCountryByNumeric*(numericCode: string | int): CountryDivision =
  var numCode: string
  when numericCode is int:
    if numericCode < 0:
      raise newException(KeyError, &"The numeric code '{numericCode}' is invalid")
    numCode = numericCode.intToStr(3)
  else:
    numCode = numericCode
  if numCode.len > 3 and numCode.len < 1:
    raise newException(KeyError, &"The numeric code '{numericCode}' is invalid")

  for countryCode, country in Countries.pairs:
    if (numCode == country.numeric):
      return country
  raise newException(KeyError, &"The country with the numeric code '{numCode}' was not found")
