import tables, strformat, strutils

import private/converters

export CountrySubdivision


proc getAllSubdivisions*(): OrderedTable[string, CountrySubdivision] =
  for subdivGroup in Subdivisions.values():
    for subdivision in subdivGroup.values():
      result[subdivision.code] = subdivision


proc getSubdivisionsByCountry*(countryCode: string): seq[CountrySubdivision] =
  if not Countries.hasKey(countryCode):
    raise newException(KeyError, &"The country with code '{countryCode}' does not exist")

  if not Subdivisions.hasKey(countryCode):
    raise newException(KeyError, &"The country with code '{countryCode}' has no subdivisions")

  for code, subdivision in Subdivisions.getOrDefault(countryCode).pairs:
    result.add(subdivision)


proc getSubdivisionByCode*(countryCode: string, code: string): CountrySubdivision =
  if not Countries.hasKey(countryCode):
    raise newException(KeyError, &"The country with code '{countryCode}' does not exist")

  if not Subdivisions.hasKey(countryCode):
    raise newException(KeyError, &"The country with code '{countryCode}' has no subdivisions")

  let countrySubdivisions = Subdivisions.getOrDefault(countryCode)
  if countrySubdivisions.hasKey(code):
    return countrySubdivisions[code]

  raise newException(KeyError, &"The subdivision with code '{code}' does not exist")


proc getSubdivisionByCode*(code: string): CountrySubdivision =
  let composeCode = code.split('-')
  if composeCode.len == 2:
    return getSubdivisionByCode(composeCode[0], composeCode[1])

  raise newException(KeyError, &"The code '{code}' does not match the correct format. Try passing the country and the subdivision separated by a hyphen (i.e HU-BU)")
