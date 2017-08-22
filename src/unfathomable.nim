
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
  if (latitude >= -90.0 and latitude <= 90.0) and 
     (longitude >= -180.0 and longitude <= 180.0):
    return (latitude: latitude, longitude: longitude)
  else:
    raise newException(IOError, "Point must be of valid latitude (-90 to 90) and longitude (-180 to 180).")

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

template `==` *(a, b: Distance): bool =
  if a.units == b.units:
    a.size == b.size
  else:
    a.size == b.sizeAs(a.units)

template `!=` *(a, b: Distance): bool =
  if a.units == b.units:
    a.size != b.size
  else:
    a.size != b.sizeAs(a.units)

template `>` *(a, b: Distance): bool =
  if a.units == b.units:
    a.size > b.size
  else:
    a.size > b.sizeAs(a.units)
    
template `>=` *(a, b: Distance): bool =
  if a.units == b.units:
    a.size >= b.size
  else:
    a.size >= b.sizeAs(a.units)

template `<` *(a, b: Distance): bool =
  if a.units == b.units:
    a.size < b.size
  else:
    a.size < b.sizeAs(a.units)
    
template `<=` *(a, b: Distance): bool =
  if a.units == b.units:
    a.size <= b.size
  else:
    a.size <= b.sizeAs(a.units)

template `+` *(a, b: Distance): Distance =
  if a.units == b.units:
    Distance(size: a.size + b.size, units: a.units)
  else:
    Distance(size: a.size + b.sizeAs(a.units), units: a.units)

template `+` *(a: float; b: Distance): Distance =
  Distance(size: a + b.size, units: b.units)

template `+` *(a: Distance; b: float): Distance =
  Distance(size: a.size + b, units: a.units)

template `+=` *(a: var Distance, b: Distance) =
  if a.units == b.units:
    a.size = a.size + b.size
  else:
    a.size = a.size + b.sizeAs(a.units)

template `-` *(a, b: Distance): Distance =
  if a.units == b.units:
    Distance(size: a.size - b.size, units: a.units)
  else:
    Distance(size: a.size - b.sizeAs(a.units), units: a.units)  

template `-` *(a: float; b: Distance): Distance =
  Distance(size: a - b.size, units: b.units)

template `-` *(a: Distance; b: float): Distance =
  Distance(size: a.size - b, units: a.units)

template `-` *(a: Point; b: Point): Distance =
  getHaversineDistance(a, b)
  
template `-=` *(a: var Distance, b: Distance) =
  if a.units == b.units:
    a.size = a.size - b.size
  else:
    a.size = a.size - b.sizeAs(a.units)

template `*` *(a, b: Distance): Distance =
  if a.units == b.units:
    Distance(size: a.size * b.size, units: a.units)
  else:
    Distance(size: a.size * b.sizeAs(a.units), units: a.units)

template `*` *(a: float; b: Distance): Distance =
  Distance(size: a * b.size, units: b.units)

template `*` *(a: Distance; b: float): Distance =
  Distance(size: a.size * b, units: a.units)

template `*=` *(a: var Distance, b: Distance) =
  if a.units == b.units:
    a.size = a.size * b.size
  else:
    a.size = a.size * b.sizeAs(a.units)

template `/` *(a, b: Distance): Distance =
  if a.units == b.units:
    Distance(size: a.size / b.size, units: a.units)
  else:
    Distance(size: a.size / b.sizeAs(a.units), units: a.units)

template `/` *(a: Distance; b: float): Distance =
  Distance(size: a.size / b, units: a.units)

template `/=` *(a: var Distance, b: Distance) =
  if a.units == b.units:
    a.size = a.size / b.size
  else:
    a.size = a.size / b.sizeAs(a.units)

template `echo` *(a: Distance) =
  echo($a.size & " " & $a.units)

template `$` *(a: Distance): string =
  $a.size & " " & $a.units
  
template `echo` *(a: Point) =
  echo("Latitude: " & $a.latitude & ", Longitude: " & $a.longitude)

template `$` *(a: Point): string =
  "Latitude: " & $a.latitude & ", Longitude: " & $a.longitude

proc getVincentyDistance(pointA, pointB: Point, units: LengthMeasure = Metres): Distance = 
  ## Rewritten based on wikipedia iterative method
  ## TODO: rename variables, error handling.
  if pointA == pointB:
    return Distance(size: 0.0, units: units)
  let
    major = 6378137.0
    minor = 6356752.314245
    flattening = 1 / 298.257223563
    iterations = 200
    convergenceThreshold = 1e-12
    cosU1 = cos(arctan((1 - flattening) * tan(degToRad(pointA.latitude))))
    cosU2 = cos(arctan((1 - flattening) * tan(degToRad(pointB.latitude))))
    sinU1 = sin(arctan((1 - flattening) * tan(degToRad(pointA.latitude))))
    sinU2 = sin(arctan((1 - flattening) * tan(degToRad(pointB.latitude))))
    initialλ = degToRad(pointB.longitude - pointA.longitude)
  var
    λ = degToRad(pointB.longitude - pointA.longitude)
    sinσ, cos2σM, cosσ, σ, sinα, cosSqα, c, previousλ, sinλ, cosλ: float
  for iteration in 0..<iterations:
    sinλ = sin(λ)
    cosλ = cos(λ)
    sinσ = sqrt(pow((cosU2 * sinλ), 2) +
                pow((cosU1 * sinU2 - sinU1 * cosU2 * cosλ), 2))
    cosσ = sinU1 * sinU2 + cosU1 * cosU2 * cosλ
    σ = arctan2(sinσ, cosσ)
    sinα = (cosU1 * cosU2 * sinλ) / sinσ
    cosSqα = 1 - pow(sinα, 2)
    try:
      cos2σM = cosσ - (2 * sinU1 * sinU2 / cosSqα)
    except DivByZeroError:
      cos2σM = 0.0
    c = (flattening / 16) * cosSqα * (4 + flattening * (4 - 3 * cosSqα))
    previousλ = λ
    λ = initialλ + (1 - c) * flattening * sinα * 
        (σ + c * sinσ * (cos2σM + c * cosσ * 
        (-1 + 2 * pow(cos2σM, 2))))
    if abs(λ - previousλ) < convergenceThreshold:
      var
        uSq = cosSqα * ((pow(major, 2) - pow(minor, 2)) / pow(minor, 2))
        A = 1 + (uSq / 16384) * (4096 + uSq * (-768 + uSq * (320 - 175 * uSq)))
        B = (uSq / 1024) * (256 + uSq * (-128 + uSq * (74 - 47 * uSq)))
        deltaSigma = B * sinσ * (cos2σM + (1 / 4) * B * 
                     (cosσ * (-1 + 2 * pow(cos2σM, 2)) - 
                     (B / 6) * cos2σM * (-3 + 4 * pow(sinσ, 2)) * 
                     (-3 + 4 * pow(cos2σM, 2))))
        ellipsoidalDistance = minor * A * (σ - deltaSigma)
        distInMetres = Distance(size: abs(ellipsoidalDistance), units: Metres)
      if units != Metres:
        distInMetres.to(units)
      return distInMetres
  return Distance(size: 0.0, units: units)

proc getHaversineDistance(points: varargs[Point], units: LengthMeasure = Metres): Distance =
  ## ASSUMES A PATH BETWEEN POINTS IN ORDER POINTS GIVEN, e.g A -> B -> C
  var cumulativeDistance = Distance(size: 0.0, units: units)
  for i in 0..<points.len - 1:
    cumulativeDistance = cumulativeDistance + getHaversineDistance(points[i], points[i + 1], units)
  cumulativeDistance

proc getVincentyDistance(points: varargs[Point], units: LengthMeasure = Metres): Distance =
  ## ASSUMES A PATH BETWEEN POINTS IN ORDER POINTS GIVEN, e.g A -> B -> C
  var cumulativeDistance = Distance(size: 0.0, units: units)
  for i in 0..<points.len - 1:
    cumulativeDistance += getVincentyDistance(points[i], points[i + 1], units)
  cumulativeDistance

proc getBearing(pointA, pointB: Point): float =
  let λ = degToRad(pointB.longitude - pointA.longitude)
  radToDeg(arctan2(sin(λ) * cos(pointB.latitude), 
           cos(pointA.latitude) * sin(pointB.latitude) - 
           sin(pointA.latitude) * cos(pointB.latitude) * cos(λ)))

proc getHaversineDistance(points: seq[Point], units: LengthMeasure = Metres): Distance =
  ## ASSUMES A PATH BETWEEN POINTS IN ORDER POINTS GIVEN, e.g A -> B -> C
  var cumulativeDistance = Distance(size: 0.0, units: units)
  for i in 0..<points.len - 1:
    cumulativeDistance = cumulativeDistance + getHaversineDistance(points[i], points[i + 1], units)
  cumulativeDistance

proc reverse*[T](a: var openArray[T], first, last: Natural) =
  var x = first
  var y = last
  while x < y:
    swap(a[x], a[y])
    dec(y)
    inc(x)

proc reverse*[T](a: var openArray[T]) =
  reverse(a, 0, max(0, a.high))

proc nextPermutation*[T](x: var openarray[T]): bool {.discardable.} =
  if x.len < 2:
    return false
  var i = x.high
  while i > 0 and x[i-1] >= x[i]:
    dec i
  if i == 0:
    return false
  var j = x.high
  while j >= i and x[j] <= x[i-1]:
    dec j
  swap x[j], x[i-1]
  x.reverse(i, x.high)
  result = true

proc getShortestDistance(points: varargs[Point], units: LengthMeasure = Metres): Distance = 
  var point_list = newSeq[Point](0)
  for point in points:
    point_list.add(point)
  echo point_list
  var cumulativeDistance = getHaversineDistance(point_list, units)
  while nextPermutation(point_list):
    var newDistance = getHaversineDistance(point_list, units)
    if newDistance < cumulativeDistance:
      cumulativeDistance = newDistance
      echo point_list
  cumulativeDistance

    
