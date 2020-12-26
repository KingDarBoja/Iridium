import tables, strformat

import private/converters

export CurrencyCode

proc getAllCurrencies*(): OrderedTable[string, CurrencyCode] = Currencies


proc getCurrencyByCode*(code: string): CurrencyCode =
  ## Get the currency by its code (alphabetic code).
  if Currencies.hasKey(code):
    return Currencies[code]
  raise newException(KeyError, &"The currency with the code '{code}' does not exist")
