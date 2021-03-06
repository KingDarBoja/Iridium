# Iridium
The International Standard for country codes and codes for their subdivisions on Nim (ISO-3166).

[![](https://img.shields.io/badge/Nimble-0.3.2-yellow?style=flat-square&logo=nim)](https://nimble.directory/pkg/iridium)
[![GitHub issues](https://img.shields.io/github/issues/KingDarBoja/Iridium?style=flat-square)](https://github.com/KingDarBoja/Iridium/issues)
[![GitHub stars](https://img.shields.io/github/stars/KingDarBoja/Iridium?style=flat-square)](https://github.com/KingDarBoja/Iridium/stargazers)

## Usage

```nim
>>> import iridium
>>> echo getCountryByCode("CO")
(name: "Colombia", alpha2: "CO", alpha3: "COL", numeric: "170", official: "Republic of Colombia")
>>> echo getSubdivisionByCode("CO-QUI")
(name: "Quindío", category: "Department", parent: "")
```

## Install

```console
nimble install iridium
```

## Requisites

- [Nim 1.2.0](https://nim-lang.org/) or higher.

## Documentation

### **Types**

The country data is stored as a *CountryDivision* object with the following fields:
```Nim
type
  CountryDivision* = object
    name*: string       ## Country name (short)
    alpha2*: string     ## Two letter alphabetic code of the country
    alpha3*: string     ## Three letter alphabetic code of the country
    numeric*: string    ## Three digit numeric code of the country, including leading zeros
    official*: string   ## Official name of the country (optional)
```

The country subdivision is stored as a *CountrySubdivision* object with the following fields:

```nim
type
  CountrySubdivision* = object
    name*: string        ## Name of the country subdivision
    category*: string    ## Type of subdivision of the country (i.e. Province, Region, Emirate)
    parent*: string      ## Parent of the country subdivision
```

### **Procedures**

Each procedure will raise a `KeyError` if the code does not satisfy certain checks (i.e. code does not exist, invalid numeric code).

#### ISO-3166-1 Related

- **getAllCountries()**

  Get all the countries data as a Nim Table whose keys are the country alpha2 code and the values as CountryDivision object.

  - **Arguments**: None
  - **Returns**: `Table[string, CountryDivision]`

- **getCountryByCode()**

  Get the country data by its alpha2 code.

  - **Arguments**:
    - `code` ISO-3166-1 alpha2 code, required.
  - **Returns**: `CountryDivision`

- **getCountryByName()**

  Get the country data by its name.

  - **Arguments**:
    - `countryName` The common name, required.
  - **Returns**: `CountryDivision`

- **getCountryByAlpha3()**

  Get the country data by its alpha3 code.

  - **Arguments**:
    - `alpha3Code` ISO-3166-1 alpha3 code, required.
  - **Returns**: `CountryDivision`

- **getCountryByNumeric()**

  Get the country data by its numeric code.

  - **Arguments**:
    - `numericCode` ISO-3166-1 numeric code as string or integer, required.
  - **Returns**: `CountryDivision`


#### ISO-3166-2 Related

- **getAllSubdivisions()**

  Get all the subdivisions data as a Nim Table whose keys are the subdivision code *(country-subdivision)* and the values as CountrySubdivision object.

  - **Arguments**: None
  - **Returns**: `Table[string, CountrySubdivision]`

- **getSubdivisionsByCountry()**

  Get the country subdivisions data by its code as a sequence.

  - **Arguments**:
    - `countryCode` ISO-3166-1 alpha2 country code as string, required.
  - **Returns**: `seq[CountrySubdivision]`

- **getSubdivisionByCode()**

  Get the subdivision data by its code.

  - **Arguments**:
    - `numericCode` ISO-3166-2 code as string, required.
  - **Returns**: `CountrySubdivision`


#### ISO-4217 Related

- **getAllCurrencies()**

  Get all the currencies as a Nim table whose keys are the currency alphabetic code and the values as CurrencyCode object.

  - **Arguments**: None
  - **Returns**: `Table[string, CurrencyCode]`

- **getCurrencyByCode()**

  Get the currency data by its alphabetic code.

  - **Arguments**:
    - `code` ISO-4217 alphabetic code as string, required.
  - **Returns**: `CurrencyCode`
