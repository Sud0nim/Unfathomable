
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

template between(a, b, c: untyped): bool =
  ## An inclusive between to ensure `a` is 
  ## within the specified range.
  if a >= b and a <= c:
    true
  else:
    false

proc newDistance*(size: float, unit_type: LengthMeasure): Distance =
  Distance(size: size, units: unit_type)

proc newPoint*(latitude, longitude: float): Point =
  if latitude.between(-90.0, 90.0) and longitude.between(-180.0, 180.0):
    return (latitude: latitude, longitude: longitude)
  else:
    raise newException(IOError, "Invalid latitude or longitude.")

proc sizeAs*(measurement: Distance, units: LengthMeasure): float =
  measurement.size * length_multipliers[ord(measurement.units)] / 
                     length_multipliers[ord(units)]

proc to*(measurement: var Distance, units: LengthMeasure) =
  measurement.size = measurement.sizeAs(units)
  measurement.units = units

proc copyAs*(measurement: Distance, units: LengthMeasure): Distance =
  Distance(size: measurement.sizeAs(units), units: units)

proc getHaversineDistance(pointA, pointB: Point, 
                          units: LengthMeasure = Metres): Distance =
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

proc getVincentyDistance(pointA, pointB: Point, 
                         units: LengthMeasure = Metres): Distance = 
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

proc getHaversineDistance(points: varargs[Point], 
                          units: LengthMeasure = Metres): Distance =
  ## Attempts to find the distance between all Points given in points
  ## using the Haversine distance calculation. Finds the distance in order that
  ## the points are given by the user. E.G. A -> B -> C if the user provides
  ## the points as such: getHaversineDistance(A, B, C)
  ## 
  ##.. code-block:: nim
  ##
  ##     const 
  ##       DC = newPoint(38.9072, -77.0369)
  ##       Philadelphia = newPoint(39.9526, -75.1652)
  ##       NY = newPoint(40.7128, -74.0059)
  ##     echo getHaversineDistance(DC, NY, Philadelphia, Kilometres)
  ## 
  ##     # Outputs: 457.2093040782787 Kilometres
  ## 
  var cumulativeDistance = Distance(size: 0.0, units: units)
  for i in 0..<points.len - 1:
    cumulativeDistance += getHaversineDistance(points[i], points[i + 1], units)
  cumulativeDistance

proc getVincentyDistance(points: varargs[Point], 
                         units: LengthMeasure = Metres): Distance =
  ## Attempts to find the distance between all Points given in points
  ## using the Vincenty distance calculation. Finds the distance in order that
  ## the points are given by the user. E.G. A -> B -> C if the user provides
  ## the points as such: getVincentyDistance(A, B, C)
  ## 
  ##.. code-block:: nim
  ##
  ##     const 
  ##       DC = newPoint(38.9072, -77.0369)
  ##       Philadelphia = newPoint(39.9526, -75.1652)
  ##       NY = newPoint(40.7128, -74.0059)
  ##     echo getVincentyDistance(DC, NY, Philadelphia, Kilometres)
  ## 
  ##     # Outputs: 457.650671384857 Kilometres
  ## 
  var cumulativeDistance = Distance(size: 0.0, units: units)
  for i in 0..<points.len - 1:
    cumulativeDistance += getVincentyDistance(points[i], points[i + 1], units)
  cumulativeDistance

proc getBearing(pointA, pointB: Point): float =
  ## Returns the bearing from point A to point B in degrees
  ## Requires some further error handling and functionality
  let λ = degToRad(pointB.longitude - pointA.longitude)
  radToDeg(arctan2(sin(λ) * cos(pointB.latitude), 
           cos(pointA.latitude) * sin(pointB.latitude) - 
           sin(pointA.latitude) * cos(pointB.latitude) * cos(λ)))

proc reverse*[T](a: var openArray[T], first, last: Natural) =
  ## The Nim standard library implementation unchanged from algorithm.nim
  ## in an attempt to reduce size of this module, rather than importing
  var x = first
  var y = last
  while x < y:
    swap(a[x], a[y])
    dec(y)
    inc(x)

proc reverse*[T](a: var openArray[T]) =
  ## The Nim standard library implementation unchanged from algorithm.nim
  ## in an attempt to reduce size of this module, rather than importing
  reverse(a, 0, max(0, a.high))

proc nextPermutation*[T](x: var openarray[T]): bool {.discardable.} =
  ## The Nim standard library implementation unchanged from algorithm.nim
  ## in an attempt to reduce size of this module, rather than importing
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

proc getShortestHaversine(points: varargs[Point], 
                          units: LengthMeasure = Metres): Distance =
  ## Attempts to find the shortest distance between all Points given in points
  ## using the Haversine distance calculation. Does not return back to the first
  ## point in the sequence, but instead gives the shortest that touches all 
  ## Points once.
  ## 
  ##.. code-block:: nim
  ##
  ##     const 
  ##       DC = newPoint(38.9072, -77.0369)
  ##       Philadelphia = newPoint(39.9526, -75.1652)
  ##       NY = newPoint(40.7128, -74.0059)
  ##     echo getShortestHaversine(DC, Philadelphia, NY, Kilometres)
  ## 
  ##     # Outputs: 327.9919788108596 Kilometres
  ## 
  var point_list = newSeq[Point](0)
  for point in points:
    point_list.add(point)
  var cumulativeDistance = getHaversineDistance(point_list, units)
  while nextPermutation(point_list):
    var newDistance = getHaversineDistance(point_list, units)
    if newDistance < cumulativeDistance:
      cumulativeDistance = newDistance
  cumulativeDistance

proc getShortestVincenty(points: varargs[Point], 
                         units: LengthMeasure = Metres): Distance = 
  ## Attempts to find the shortest distance between all Points given in points
  ## using the Vincenty distance calculation. Does not return back to the first
  ## point in the sequence, but instead gives the shortest that touches all 
  ## Points once.
  ## 
  ##.. code-block:: nim
  ##
  ##     const 
  ##       DC = newPoint(38.9072, -77.0369)
  ##       Philadelphia = newPoint(39.9526, -75.1652)
  ##       NY = newPoint(40.7128, -74.0059)
  ##     echo getShortestVincenty(DC, Philadelphia, NY, Kilometres)
  ## 
  ##     # Outputs: 328.3215097416523 Kilometres
  ## 
  var point_list = newSeq[Point](0)
  for point in points:
    point_list.add(point)
  var cumulativeDistance = getVincentyDistance(point_list, units)
  while nextPermutation(point_list):
    var newDistance = getVincentyDistance(point_list, units)
    if newDistance < cumulativeDistance:
      cumulativeDistance = newDistance
  cumulativeDistance

    
#[
WIP: Parsing string coordinates

proc parseCoordinates(a: string): float =
  var 
    b = a.split
    latitude = 0.0
    longitude = 0.0
  if b.len == 8:
    try:
      var
        latDegrees = parseFloat(b[0].replace("°", ""))
        latMinutes = parseFloat(b[1].replace("′", ""))
        latSeconds = parseFloat(b[2].replace("″", ""))
        latBearing = b[3] #make proc to parseDirection and return an enum of North, South, East West
        latitude = latDegrees + latMinutes / 60 + latSeconds / 3600
      if latBearing in ["s", "S"]: #improve this with parseDirection proc
        latitude *= -1.0
    except IOError:
        ## handle errors for latitude
    try:
      var
        longDegrees = parseFloat(b[4].replace("°", ""))
        longMinutes = parseFloat(b[5].replace("′", ""))
        longSeconds = parseFloat(b[6].replace("″", ""))
        longBearing = b[7]
        longitude = longDegrees + longMinutes / 60 + longSeconds / 3600
      if longBearing in ["w", "W"]: #improve this with parseDirection
        longitude *= -1.0
    except IOError:
        ## handle errors for longitude
  elif b.len == 6:
    try:
      var
        latDegrees = parseFloat(b[0].replace("°", ""))
        latMinutes = parseFloat(b[1].replace("′", ""))
        latBearing = b[2]
        latitude = latDegrees + latMinutes / 60
      if latBearing in ["s", "S"]: #improve this with parseDirection
        latitude *= -1.0
    except IOError:
        ## handle errors for latitude
    try:
      var
        longDegrees = parseFloat(b[3].replace("°", ""))
        longMinutes = parseFloat(b[4].replace("′", ""))
        longBearing = b[5]
        longitude = longDegrees + longMinutes / 60
      if longBearing in ["w", "W"]: #improve this with parseDirection
        longitude *= -1.0
    except IOError:
        ## handle errors for longitude
  elif b.len == 4:
    try:
      var
        latDegrees = parseFloat(b[0].replace("°", ""))
        latBearing = b[2]
        latitude = latDegrees
      if latBearing in ["s", "S"]: #improve this with parseDirection
        latitude *= -1.0
    except IOError:
        ## handle errors for latitude
    try:
      var
        longDegrees = parseFloat(b[3].replace("°", ""))
        longBearing = b[5]
        longitude = longDegrees
      if longBearing in ["w", "W"]: #improve this with parseDirection
        longitude *= -1.0
    except IOError:
        ## handle errors for longitude
  elif b.len == 2:
    try:
      latitude = parseFloat(b[0])
      longitude = parseFloat(b[1])
    except IOError:
        ## handle errors for not being floats either
  else:
    raise newException(IOError, "Invalid latitude or longitude.")

    #parsefloat

proc newPoint*(latitude, longitude: string): Point =
  var 
    lat = parseCoordinates(latitude)
    long = parseCoordinates(longitude)
  newPoint(lat, long)
]#

