# This is just an example to get you started. A typical library package
# exports the main API in this file. Note that you cannot rename this file
# but you can remove it if you wish.

import iridium/iso_3166_1
import iridium/iso_3166_2

export iso_3166_1.getAllCountries
export iso_3166_1.getCountryByCode
export iso_3166_2.getAllSubdivisions
export iso_3166_2.getSubdivisionsByCountry
export iso_3166_2.getSubdivisionByCode
