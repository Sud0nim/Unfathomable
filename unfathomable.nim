
from tables import Table, toTable, `[]`
from strutils import `%`

type
  LengthMeasure* = enum
    PlanckLength, Yoctometres, Zeptometres, Attometres, Femtometres, Picometres, 
    Angstroms, Nanometres, Micrometres, Thou, Millimetres, Centimetres, Inches, 
    Decimetres, Feet, Yards, Metres, Fathoms, HorseLengths, Rods, Decametres, 
    Chains, Hectometres, Furlongs, Kilometres, Miles, NauticalMiles, Leagues, 
    EarthRadii, LunarDistances, Megametres, Gigametres, AstronomicalUnits, 
    Terametres, Petametres, LightYears, Parsecs, Exametres, HubbleLengths, 
    Zettametres, Yottametres
  Distance* = object
    size*: float
    units*: LengthMeasure
  Point* = tuple[latitude, longitude: float]

const relative_lengths* = {
  PlanckLength: 1.62e-35,
  Yoctometres: 1e-24,
  Zeptometres: 1e-21,
  Attometres: 1e-18,
  Femtometres: 1e-15,
  Picometres: 1e-12,
  Angstroms: 1e-10,
  Nanometres: 1e-9,
  Micrometres: 1e-6,
  Thou: 2.54e-5,
  Millimetres: 1e-3,
  Centimetres: 1e-2,
  Inches: 0.0254,
  Decimetres: 1e-1,
  Feet: 0.3048,
  Yards: 0.9144,
  Metres: 1.0,
  Fathoms: 1.8288,
  HorseLengths: 2.4,
  Rods: 5.0292,
  Decametres: 1e1,
  Chains: 20.1168,
  Hectometres: 1e2,
  Furlongs: 201.1680,
  Kilometres: 1e3,
  Miles: 1_609.344,
  NauticalMiles: 1852.0,
  Leagues: 5556.0,
  Megametres: 1e6,
  EarthRadii: 6.371009e6,
  LunarDistances: 3.84402e8,
  Gigametres: 1e9,
  AstronomicalUnits: 1.495978707e11,
  Terametres: 1e12,
  Petametres: 1e15,
  LightYears: 9.4607304725808e15,
  Parsecs: 3.08567758146719e16,
  Exametres: 1e18,
  HubbleLengths: 1.40398329956757145e20,
  Zettametres: 1e21,
  Yottametres: 1e24
}.toTable

proc newDistance*(size: float, unit_type: LengthMeasure): Distance =
  Distance(size: size, units: unit_type)

proc newPoint*(latitude, longitude: float): Point =
  (latitude: latitude, longitude: longitude)

proc sizeAs*(measurement: Distance, units: LengthMeasure): float =
  measurement.size * relative_lengths[measurement.units] /  relative_lengths[units]

proc to*(measurement: var Distance, units: LengthMeasure) =
  measurement.size = measurement.sizeAs(units)
  measurement.units = units

proc copyAs*(measurement: Distance, units: LengthMeasure): Distance =
  Distance(size: measurement.sizeAs(units), units: units)

proc `==` *(a, b: Distance): bool =
  if a.units == b.units:
    a.size == b.size
  else:
    a.size == b.sizeAs(a.units)

proc `!=` *(a, b: Distance): bool =
  if a.units == b.units:
    a.size != b.size
  else:
    a.size != b.sizeAs(a.units)

proc `>` *(a, b: Distance): bool =
  if a.units == b.units:
    a.size > b.size
  else:
    a.size > b.sizeAs(a.units)

proc `<` *(a, b: Distance): bool =
  if a.units == b.units:
    a.size < b.size
  else:
    a.size < b.sizeAs(a.units)

proc `+` *(a, b: Distance): Distance =
  if a.units == b.units:
    Distance(size: a.size + b.size, units: a.units)
  else:
    Distance(size: a.size + b.sizeAs(a.units), units: a.units)

proc `+` *(a: float; b: Distance): Distance =
  Distance(size: a + b.size, units: b.units)

proc `+` *(a: Distance; b: float): Distance =
  Distance(size: a.size + b, units: a.units)

proc `-` *(a, b: Distance): Distance =
  if a.units == b.units:
    Distance(size: a.size - b.size, units: a.units)
  else:
    Distance(size: a.size - b.sizeAs(a.units), units: a.units)  

proc `-` *(a: float; b: Distance): Distance =
  Distance(size: a - b.size, units: b.units)

proc `-` *(a: Distance; b: float): Distance =
  Distance(size: a.size - b, units: a.units)

proc `*` *(a, b: Distance): Distance =
  if a.units == b.units:
    Distance(size: a.size * b.size, units: a.units)
  else:
    Distance(size: a.size * b.sizeAs(a.units), units: a.units)

proc `*` *(a: float; b: Distance): Distance =
  Distance(size: a * b.size, units: b.units)

proc `*` *(a: Distance; b: float): Distance =
  Distance(size: a.size * b, units: a.units)

proc `/` *(a, b: Distance): Distance =
  if a.units == b.units:
    Distance(size: a.size / b.size, units: a.units)
  else:
    Distance(size: a.size / b.sizeAs(a.units), units: a.units)

proc `/` *(a: Distance; b: float): Distance =
  Distance(size: a.size / b, units: a.units)

proc `echo` *(a: Distance) =
  echo "$1 $2" % [$a.size, $a.units]

proc `$` *(a: Distance) =
  echo "$1 $2" % [$a.size, $a.units]
  
#TODO: Add Point procs, great circle and vincenty distance calculations

