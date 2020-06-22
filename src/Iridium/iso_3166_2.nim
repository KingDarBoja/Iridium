import tables, strformat, strutils

import generated/countries
import generated/subdivisions



proc getAllSubdivisions*(): Table[string, CountrySubdivision] = Subdivisions


proc getSubdivisionsByCountry*(countryCode: string): seq[CountrySubdivision] =
  if not Countries.hasKey(countryCode):
    raise newException(KeyError, &"The country code '{countryCode}' does not exist")

  var subs: seq[CountrySubdivision] = @[]
  for code, subdivision in Subdivisions.pairs:
    if countryCode == code.split("-")[0]:
      subs.add(subdivision)

  if subs.len > 0:
    return subs
  raise newException(KeyError, &"The country code '{countryCode}' has no subdivision")


proc getSubdivisionByCode*(code: string): CountrySubdivision =
  if Subdivisions.hasKey(code):
    return Subdivisions[code]
  raise newException(KeyError, &"The subdivision code '{code}' does not exist")
