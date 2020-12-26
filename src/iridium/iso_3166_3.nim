import tables, strformat, strutils

import private/converters

export FormerCountryDivision

proc getAllFormerCountries*(): OrderedTable[string, FormerCountryDivision] = FormerCountries


proc getFormerCountryByCode*(code: string): FormerCountryDivision =
  ## Get the country by its code (alpha2 Code).
  if FormerCountries.hasKey(code):
    return FormerCountries[code]
  raise newException(KeyError, &"The former country with the code '{code}' does not exist")


proc getFormerCountryByName*(countryName: string): FormerCountryDivision =
  for countryCode, country in FormerCountries.pairs:
    if (countryName == country.name):
      return country
  raise newException(KeyError, &"The former country with the name '{countryName}' was not found")


proc getFormerCountryByAlpha3*(alpha3Code: string): FormerCountryDivision =
  for countryCode, country in FormerCountries.pairs:
    if (alpha3Code == country.alpha3):
      return country
  raise newException(KeyError, &"The former country with the alpha3 code '{alpha3Code}' was not found")


proc getFormerCountryByAlpha4*(alpha4Code: string): FormerCountryDivision =
  for countryCode, country in FormerCountries.pairs:
    if (alpha4Code == country.alpha4):
      return country
  raise newException(KeyError, &"The former country with the alpha4 code '{alpha4Code}' was not found")


proc getFormerCountryByNumeric*(numericCode: string | int): FormerCountryDivision =
  var numCode: string
  when numericCode is int:
    if numericCode < 0:
      raise newException(KeyError, &"The numeric code '{numericCode}' is invalid")
    numCode = numericCode.intToStr(3)
  else:
    numCode = numericCode
  if numCode.len > 3 and numCode.len < 1:
    raise newException(KeyError, &"The numeric code '{numericCode}' is invalid")

  for countryCode, country in FormerCountries.pairs:
    if (numCode == country.numeric):
      return country
  raise newException(KeyError, &"The former country with the numeric code '{numCode}' was not found")
