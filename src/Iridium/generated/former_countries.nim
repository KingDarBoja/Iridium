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
  ("AI", FormerCountryDivision(name: "French Afars and Issas", alpha2: "AI", alpha3: "AFI", alpha4: "AIDJ", numeric: "262", withdrawal: "1977", comment: "")),
  ("AN", FormerCountryDivision(name: "Netherlands Antilles", alpha2: "AN", alpha3: "ANT", alpha4: "ANHH", numeric: "530", withdrawal: "1993-07-12", comment: "")),
  ("BQ", FormerCountryDivision(name: "British Antarctic Territory", alpha2: "BQ", alpha3: "ATB", alpha4: "BQAQ", numeric: "", withdrawal: "1979", comment: "")),
  ("BU", FormerCountryDivision(name: "Burma, Socialist Republic of the Union of", alpha2: "BU", alpha3: "BUR", alpha4: "BUMM", numeric: "104", withdrawal: "1989-12-05", comment: "")),
  ("BY", FormerCountryDivision(name: "Byelorussian SSR Soviet Socialist Republic", alpha2: "BY", alpha3: "BYS", alpha4: "BYAA", numeric: "112", withdrawal: "1992-06-15", comment: "")),
  ("CS", FormerCountryDivision(name: "Czechoslovakia, Czechoslovak Socialist Republic", alpha2: "CS", alpha3: "CSK", alpha4: "CSHH", numeric: "200", withdrawal: "1993-06-15", comment: "")),
  ("CS", FormerCountryDivision(name: "Serbia and Montenegro", alpha2: "CS", alpha3: "SCG", alpha4: "CSXX", numeric: "891", withdrawal: "2006-06-05", comment: "")),
  ("CT", FormerCountryDivision(name: "Canton and Enderbury Islands", alpha2: "CT", alpha3: "CTE", alpha4: "CTKI", numeric: "128", withdrawal: "1984", comment: "")),
  ("DD", FormerCountryDivision(name: "German Democratic Republic", alpha2: "DD", alpha3: "DDR", alpha4: "DDDE", numeric: "278", withdrawal: "1990-10-30", comment: "")),
  ("DY", FormerCountryDivision(name: "Dahomey", alpha2: "DY", alpha3: "DHY", alpha4: "DYBJ", numeric: "204", withdrawal: "1977", comment: "")),
  ("FQ", FormerCountryDivision(name: "French Southern and Antarctic Territories", alpha2: "FQ", alpha3: "ATF", alpha4: "FQHH", numeric: "", withdrawal: "1979", comment: "now split between AQ and TF")),
  ("FX", FormerCountryDivision(name: "France, Metropolitan", alpha2: "FX", alpha3: "FXX", alpha4: "FXFR", numeric: "249", withdrawal: "1997-07-14", comment: "")),
  ("GE", FormerCountryDivision(name: "Gilbert and Ellice Islands", alpha2: "GE", alpha3: "GEL", alpha4: "GEHH", numeric: "296", withdrawal: "1979", comment: "now split into Kiribati and Tuvalu")),
  ("HV", FormerCountryDivision(name: "Upper Volta, Republic of", alpha2: "HV", alpha3: "HVO", alpha4: "HVBF", numeric: "854", withdrawal: "1984", comment: "")),
  ("JT", FormerCountryDivision(name: "Johnston Island", alpha2: "JT", alpha3: "JTN", alpha4: "JTUM", numeric: "396", withdrawal: "1986", comment: "")),
  ("MI", FormerCountryDivision(name: "Midway Islands", alpha2: "MI", alpha3: "MID", alpha4: "MIUM", numeric: "488", withdrawal: "1986", comment: "")),
  ("NH", FormerCountryDivision(name: "New Hebrides", alpha2: "NH", alpha3: "NHB", alpha4: "NHVU", numeric: "548", withdrawal: "1980", comment: "")),
  ("NQ", FormerCountryDivision(name: "Dronning Maud Land", alpha2: "NQ", alpha3: "ATN", alpha4: "NQAQ", numeric: "216", withdrawal: "1983", comment: "")),
  ("NT", FormerCountryDivision(name: "Neutral Zone", alpha2: "NT", alpha3: "NTZ", alpha4: "NTHH", numeric: "536", withdrawal: "1993-07-12", comment: "formerly between Saudi Arabia and Iraq")),
  ("PC", FormerCountryDivision(name: "Pacific Islands (trust territory)", alpha2: "PC", alpha3: "PCI", alpha4: "PCHH", numeric: "582", withdrawal: "1986", comment: "divided into FM, MH, MP, and PW")),
  ("PU", FormerCountryDivision(name: "US Miscellaneous Pacific Islands", alpha2: "PU", alpha3: "PUS", alpha4: "PUUM", numeric: "849", withdrawal: "1986", comment: "")),
  ("PZ", FormerCountryDivision(name: "Panama Canal Zone", alpha2: "PZ", alpha3: "PCZ", alpha4: "PZPA", numeric: "", withdrawal: "1980", comment: "")),
  ("RH", FormerCountryDivision(name: "Southern Rhodesia", alpha2: "RH", alpha3: "RHO", alpha4: "RHZW", numeric: "716", withdrawal: "1980", comment: "")),
  ("SK", FormerCountryDivision(name: "Sikkim", alpha2: "SK", alpha3: "SKM", alpha4: "SKIN", numeric: "", withdrawal: "1975", comment: "")),
  ("SU", FormerCountryDivision(name: "USSR, Union of Soviet Socialist Republics", alpha2: "SU", alpha3: "SUN", alpha4: "SUHH", numeric: "810", withdrawal: "1992-08-30", comment: "")),
  ("TP", FormerCountryDivision(name: "East Timor", alpha2: "TP", alpha3: "TMP", alpha4: "TPTL", numeric: "626", withdrawal: "2002-05-20", comment: "was Portuguese Timor")),
  ("VD", FormerCountryDivision(name: "Viet-Nam, Democratic Republic of", alpha2: "VD", alpha3: "VDR", alpha4: "VDVN", numeric: "", withdrawal: "1977", comment: "")),
  ("WK", FormerCountryDivision(name: "Wake Island", alpha2: "WK", alpha3: "WAK", alpha4: "WKUM", numeric: "872", withdrawal: "1986", comment: "")),
  ("YD", FormerCountryDivision(name: "Yemen, Democratic, People's Democratic Republic of", alpha2: "YD", alpha3: "YMD", alpha4: "YDYE", numeric: "720", withdrawal: "1990-08-14", comment: "")),
  ("YU", FormerCountryDivision(name: "Yugoslavia, Socialist Federal Republic of", alpha2: "YU", alpha3: "YUG", alpha4: "YUCS", numeric: "891", withdrawal: "1993-07-28", comment: "")),
  ("ZR", FormerCountryDivision(name: "Zaire, Republic of", alpha2: "ZR", alpha3: "ZAR", alpha4: "ZRCD", numeric: "180", withdrawal: "1997-07-14", comment: "")),
].toTable
