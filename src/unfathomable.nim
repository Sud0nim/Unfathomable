
from strutils import `%`
import math

type
  LengthMeasure* = enum
    PlanckLength, Yoctometres, Zeptometres, Attometres, Femtometres, Picometres, 
    Angstroms, Nanometres, Micrometres, Thou, Millimetres, Centimetres, Inches, 
    Decimetres, Feet, Yards, Metres, Fathoms, HorseLengths, Rods, Decametres, 
    Chains, Hectometres, Furlongs, Kilometres, Miles, NauticalMiles, Leagues, 
    Megametres, EarthRadii, LunarDistances, Gigametres, AstronomicalUnits, 
    Terametres, Petametres, LightYears, Parsecs, Exametres, HubbleLengths, 
    Zettametres, Yottametres
  Distance* = object
    size*: float
    units*: LengthMeasure
  Point* = tuple[latitude, longitude: float]

const length_multipliers* = [
  1.62e-35,
  1e-24,
  1e-21,
  1e-18,
  1e-15,
  1e-12,
  1e-10,
  1e-9,
  1e-6,
  2.54e-5,
  1e-3,
  1e-2,
  0.0254,
  1e-1,
  0.3048,
  0.9144,
  1.0,
  1.8288,
  2.4,
  5.0292,
  1e1,
  20.1168,
  1e2,
  201.1680,
  1e3,
  1_609.344,
  1852.0,
  5556.0,
  1e6,
  6.371009e6,
  3.84402e8,
  1e9,
  1.495978707e11,
  1e12,
  1e15,
  9.4607304725808e15,
  3.08567758146719e16,
  1e18,
  1.40398329956757145e20,
  1e21,
  1e24
]

proc newDistance*(size: float, unit_type: LengthMeasure): Distance =
  Distance(size: size, units: unit_type)

proc newPoint*(latitude, longitude: float): Point =
  (latitude: latitude, longitude: longitude)

proc sizeAs*(measurement: Distance, units: LengthMeasure): float =
  measurement.size * length_multipliers[ord(measurement.units)] /  length_multipliers[ord(units)]

proc to*(measurement: var Distance, units: LengthMeasure) =
  measurement.size = measurement.sizeAs(units)
  measurement.units = units

proc copyAs*(measurement: Distance, units: LengthMeasure): Distance =
  Distance(size: measurement.sizeAs(units), units: units)

proc getHaversineDistance(pointA, pointB: Point, units: LengthMeasure = Metres): Distance =
  if pointA == pointB:
    Distance(size: 0.0, units: units)
  else:
    let 
      a = sin((pointB.latitude - pointA.latitude).degToRad / 2) * 
        sin((pointB.latitude - pointA.latitude).degToRad / 2) + 
        cos(pointA.latitude.degToRad) * cos(pointB.latitude.degToRad) * 
        sin((pointB.longitude - pointA.longitude).degToRad / 2) *
        sin((pointB.longitude - pointA.longitude).degToRad / 2)
      distance = 6.371009e6 * 2 * arctan2(sqrt(a), sqrt(1 - a))
    Distance(size: distance * length_multipliers[ord(Metres)] / 
      length_multipliers[ord(units)], units: units)

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

proc `-` *(a: Point; b: Point): Distance =
  getHaversineDistance(a, b)

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

proc getVincentyDistance(pointA, pointB: Point, units: LengthMeasure): Distance = 
  ## NEEDS TESTING, OPTIMISATION AND CLEANUP
  if pointA == pointB:
    return Distance(size: 0.0, units: units)
  var
    major = 6378137.0
    minor = 6356752.3142
    flattening = 1 / 298.257223563
    iterations = 200
    convergenceThreshold = 1e-12
    λ = degToRad(pointB.longitude - pointA.longitude)
    sinU1 = math.sin(arctan((1 - flattening) * tan(degToRad(pointA.latitude))))
    cosU1 = math.cos(arctan((1 - flattening) * tan(degToRad(pointA.latitude))))
    sinU2 = math.sin(arctan((1 - flattening) * tan(degToRad(pointB.latitude))))
    cosU2 = math.cos(arctan((1 - flattening) * tan(degToRad(pointB.latitude))))

  for iteration in 0..<iterations:
    var
      sinλ = math.sin(λ)
      cosλ = math.cos(λ)
      sinσ = math.sqrt(pow((cosU2 * sinλ), 2) +
                           pow((cosU1 * sinU2 - sinU1 * cosU2 * cosλ), 2))
    if sinσ == 0:
        return Distance(size: 0.0, units: units)
    var
      cosσ = sinU1 * sinU2 + cosU1 * cosU2 * cosλ
      σ = math.arctan2(sinσ, cosσ)
      sinα = cosU1 * cosU2 * sinλ / sinσ
      cosSqα = pow(1 - sinα, 2)
      cos2σM: float
    try:
      cos2σM = cosσ - 2 * sinU1 * sinU2 / cosSqα
    except DivByZeroError:
      cos2σM = 0.0
    var
      C = flattening / 16 * cosSqα * (4 + flattening * (4 - 3 * cosSqα))
      previousλ = λ
      λ = λ + (1 - C) * flattening * sinα * (σ + C * sinσ *
                                           (cos2σM + C * cosσ *
                                            pow(-1 + 2 * cos2σM, 2)))
    if abs(λ - previousλ) < convergenceThreshold:
        break 
    #else:
    #  return Distance(size: 0.0, units: units) # needs to be fixed
    var
      uSq = cosSqα * (pow(major, 2) - pow(minor, 2)) / pow(minor, 2)
      A = 1 + uSq / 16384.0 * (4096.0 + uSq * (-768.0 + uSq * (320.0 - 175.0 * uSq)))
      B = uSq / 1024.0 * (256.0 + uSq * (-128.0 + uSq * (74.0 - 47.0 * uSq)))
      deltaSigma = B * sinσ * (cos2σM + B / 4.0 * (cosσ *
                   (-1 + 2 * pow(cos2σM, 2)) - B / 6 * cos2σM *
                   (-3 + 4 * pow(sinσ, 2)) * (-3 + 4 * pow(cos2σM, 2))))
      s = minor * A * (σ - deltaSigma)
      distInMetres = Distance(size: round(s, 6), units: Metres)
    distInMetres.to(units)
    return distInMetres
    
    
