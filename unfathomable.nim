
import tables, strutils

proc reverse_table[A, B](pairs: Table[A, B]): Table[B, A] =
  result = initTable[B, A](rightSize(pairs.len))
  for key, val in pairs: result[val] = key

type
  LengthMeasure* = enum
    PlanckLength, Yoctometres, Zeptometres, Attometres, Femtometres, Picometres, 
    Angstroms, Nanometres, Micrometres, Thou, Millimetres, Centimetres, Inches, 
    Decimetres, Feet, Yards, Metres, Fathoms, HorseLengths, Rods, Decametres, 
    Chains, Hectometres, Furlongs, Kilometres, Miles, NauticalMiles, Leagues, 
    EarthRadii, LunarDistances, Megametres, Gigametres, AstronomicalUnits, 
    Terametres, Petametres, LightYears, Parsecs, Exametres, HubbleLengths, 
    Zettametres, Yottametres
  AreaMeasure* = enum
    PlanckAreas, Barns, SquareYoctometres, SquareZeptometres, SquareAttometres, 
    SquareFemtometres, SquarePicometres, SquareAngstroms, SquareNanometres,
    SquareMicrometres, SquareThou, SquareMillimetres, SquareCentimetres, 
    SquareInches, SquareDecimetres, SquareFeet, SquareYards, SquareMetres, 
    SquareFathoms, SquareHorseLengths, SquareRods, Acres, SquareDecametres,
    SquareChains, Hectares, SquareFurlongs, SquareKilometres, SquareMiles, 
    SquareNauticalMiles, SquareLeagues, SquareEarthRadii, SquareLunarDistances,
    SquareMegametres, SquareGigametres, SquareAstronomicalUnits, 
    SquareTetrametres, SquarePetametres, SquareLightYears, SquareParsecs, 
    SquareExametres, SquareHubbleLengths, SquareZettametres, SquareYottametres

let distance_to_area_mapping* = {
  PlanckLength: PlanckAreas,
  Yoctometres: SquareYoctometres,
  Zeptometres: SquareZeptometres,
  Attometres: SquareAttometres,
  Femtometres: SquareFemtometres,
  Picometres: SquarePicometres,
  Angstroms: SquareAngstroms,
  Nanometres: SquareNanometres,
  Micrometres: SquareMicrometres,
  Thou: SquareThou,
  Millimetres: SquareMillimetres,
  Centimetres: SquareCentimetres,
  Inches: SquareInches,
  Decimetres: SquareDecimetres,
  Feet: SquareFeet,
  Yards: SquareYards,
  Metres: SquareMetres,
  Fathoms: SquareFathoms,
  HorseLengths: SquareHorseLengths,
  Rods: SquareRods,
  Decametres: SquareDecametres,
  Chains: SquareChains,
  Hectometres: Hectares,
  Furlongs: SquareFurlongs,
  Kilometres: SquareKilometres,
  Miles: SquareMiles,
  NauticalMiles: SquareNauticalMiles,
  Leagues: SquareLeagues,
  EarthRadii: SquareEarthRadii, 
  LunarDistances: SquareLunarDistances,
  Megametres: SquareMegametres,
  Gigametres: SquareGigametres,
  AstronomicalUnits: SquareAstronomicalUnits,
  Terametres: SquareTetrametres,
  Petametres: SquarePetametres,
  LightYears: SquareLightYears,
  Parsecs: SquareParsecs,
  Exametres: SquareExametres,
  HubbleLengths: SquareHubbleLengths,
  Zettametres: SquareZettametres,
  Yottametres: SquareYottametres
}.to_table
  
let area_to_distance_mapping* = distance_to_area_mapping.reverse_table

let relative_lengths* = {
  PlanckLength: 1.62e-35f64,
  Yoctometres: 1e-24f64,
  Zeptometres: 1e-21f64,
  Attometres: 1e-18f64,
  Femtometres: 1e-15f64,
  Picometres: 1e-12f64,
  Angstroms: 1e-10f64,
  Nanometres: 1e-9f64,
  Micrometres: 1e-6f64,
  Thou: 2.54e-5f64,
  Millimetres: 1e-3f64,
  Centimetres: 1e-2f64,
  Inches: 0.0254f64,
  Decimetres: 1e-1f64,
  Feet: 0.3048f64,
  Yards: 0.9144f64,
  Metres: 1f64,
  Fathoms: 1.8288f64,
  HorseLengths: 2.4f64,
  Rods: 5.0292f64,
  Decametres: 1e1f64,
  Chains: 20.1168f64,
  Hectometres: 1e2f64,
  Furlongs: 201.1680f64,
  Kilometres: 1e3f64,
  Miles: 1_609.344f64,
  NauticalMiles: 1852f64,
  Leagues: 5556f64,
  Megametres: 1e6f64,
  EarthRadii: 6.371e6f64,
  LunarDistances: 3.84402e8f64,
  Gigametres: 1e9f64,
  AstronomicalUnits: 1.495978707e11f64,
  Terametres: 1e12f64,
  Petametres: 1e15f64,
  LightYears: 9.4607304725808e15f64,
  Parsecs: 3.08567758146719e16f64,
  Exametres: 1e18f64,
  HubbleLengths: 1.40398329956757145e20f64,
  Zettametres: 1e21f64,
  Yottametres: 1e24f64
}.to_table

let relative_areas* = {
  PlanckAreas: 2.6e10-70f64,
  Barns: 1e-52f64,
  SquareYoctometres: 1e-48f64,
  SquareZeptometres: 1e-42f64,
  SquareAttometres: 1e-36f64,
  SquareFemtometres: 1e-30f64,
  SquarePicometres: 1e-24f64,
  SquareAngstroms: 1e-20f64,
  SquareNanometres: 1e-18f64,
  SquareMicrometres: 1e-12f64,
  SquareThou: 6.4516e-10f64,
  SquareMillimetres: 1e-6f64,
  SquareCentimetres: 1e-4f64,
  SquareInches: 6.4516e-4f64,
  SquareDecimetres: 1e-2f64,
  SquareFeet: 0.09290304f64,
  SquareYards: 0.83612736f64,
  SquareMetres: 1f64,
  SquareFathoms: 3.34450944f64,
  SquareHorseLengths: 5.76f64,
  SquareRods: 25.29285264f64,
  SquareDecametres: 1e2f64,
  SquareChains: 404.68564224f64,
  Acres: 4_046.85642f64,
  Hectares: 1e4f64,
  SquareKilometres: 1e6f64,
  SquareMiles: 2_589_988.11f64,
  SquareNauticalMiles: 3_429_904f64,
  SquareLeagues: 30_869_136f64,
  SquareMegametres: 1e12f64,
  SquareEarthRadii: 4.0589641e13f64,
  SquareLunarDistances: 1.47764897604e17f64,
  SquareGigametres: 1e18f64,
  SquareAstronomicalUnits: 2.2379522917973918490e22f64,
  SquareTetrametres: 1e24f64,
  SquarePetametres: 1e30f64,
  SquareLightYears: 8.9505421074818927300612528640e31f64,
  SquareParsecs: 9.5214061367692069793530464961e32f64,
  SquareExametres: 1e36f64,
  SquareHubbleLengths: 1.9711691054646450749005644508551e40f64,
  SquareZettametres: 1e42f64,
  SquareYottametres: 1e48f64
}.to_table

type
  Distance* = object
    size*: float64
    units*: LengthMeasure
  Area* = object
    size*: float64
    units*: AreaMeasure

proc new_distance*(size: float64, unit_type: LengthMeasure): Distance =
  Distance(size: size, units: unit_type)

proc new_area*(size: float64, unit_type: AreaMeasure): Area =
  Area(size: size, units: unit_type)

proc size_as*(measurement: Distance, units: LengthMeasure): float64 =
  measurement.size * relative_lengths[measurement.units] /  relative_lengths[units]

proc size_as*(area: Area, units: AreaMeasure): float64 =
  area.size * relative_areas[area.units] /  relative_areas[units]

proc to*(measurement: var Distance, units: LengthMeasure) =
  measurement.size = measurement.size_as(units)
  measurement.units = units

proc to*(area: var Area, units: AreaMeasure) =
  area.size = area.size_as(units)
  area.units = units

proc copy_as*(measurement: Distance, units: LengthMeasure): Distance =
  Distance(size: measurement.size_as(units), units: units)

proc copy_as*(area: Area, units: AreaMeasure): Area =
  Area(size: area.size_as(units), units: units)

proc `+` *(a, b: Distance): Distance =
  var new_distance = Distance(size: 0.0, units: a.units)
  if a.units == b.units:
    new_distance.size = a.size + b.size
  else:
    new_distance.size = a.size + b.size_as(a.units)
  new_distance

proc `+` *(a, b: Area): Area =
  var new_area = Area(size: 0.0,  units: a.units)
  if a.units == b.units:
    new_area.size = a.size + b.size
  else:
    new_area.size = a.size + b.size_as(a.units)
  new_area

proc `-` *(a, b: Distance): Distance =
  var new_distance = Distance(size: 0.0, units: a.units)
  if a.units == b.units:
    new_distance.size = a.size - b.size
  else:
    new_distance.size = a.size - b.size_as(a.units)
  new_distance

proc `-` *(a, b: Area): Area =
  var new_area = Area(size: 0.0,  units: a.units)
  if a.units == b.units:
    new_area.size = a.size - b.size
  else:
    new_area.size = a.size - b.size_as(a.units)
  new_area

proc `*` *(a, b: Distance): Distance =
  var new_distance = Distance(size: 0.0, units: a.units)
  if a.units == b.units:
    new_distance.size = a.size * b.size
  else:
    new_distance.size = a.size * b.size_as(a.units)
  new_distance

proc `*` *(a, b: Area): Area =
  var new_area = Area(size: 0.0,  units: a.units)
  if a.units == b.units:
    new_area.size = a.size * b.size
  else:
    new_area.size = a.size * b.size_as(a.units)
  new_area

proc `/` *(a, b: Distance): Distance =
  var new_distance = Distance(size: 0.0, units: a.units)
  if a.units == b.units:
    new_distance.size = a.size / b.size
  else:
    new_distance.size = a.size / b.size_as(a.units)
  new_distance

proc `/` *(a, b: Area): Area =
  var new_area = Area(size: 0.0,  units: a.units)
  if a.units == b.units:
    new_area.size = a.size / b.size
  else:
    new_area.size = a.size / b.size_as(a.units)
  new_area

proc new_area*(length, width: Distance): Area =
  let 
    size = length * width
  Area(size: size.size, units: distance_to_area_mapping[size.units])

proc `echo` *(a: Distance) =
  echo "$1 $2" % [$a.size, $a.units]

proc `echo` *(a: Area) =
  echo "$1 $2" % [$a.size, $a.units]

var 
  some_distance = new_distance(1.0, Kilometres)
  other_distance = Distance(size: 100.0, units: Metres)

assert((new_distance(1.0, HubbleLengths) * new_distance(1.0, HubbleLengths)).size == new_area(1.0, SquareHubbleLengths).size)
assert(some_distance + other_distance == new_distance(1.1, Kilometres))

