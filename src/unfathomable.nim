
import math, coordinates

type
  LengthMeasure* = enum
    PlanckLengths, Yoctometres, Zeptometres, Attometres, Femtometres, Picometres, 
    Angstroms, Nanometres, Micrometres, Thou, Millimetres, Centimetres, Inches, 
    Decimetres, Feet, Yards, Metres, Fathoms, HorseLengths, Rods, Decametres, 
    Chains, Hectometres, Furlongs, Kilometres, Miles, NauticalMiles, Leagues, 
    Megametres, EarthRadii, LunarDistances, Gigametres, AstronomicalUnits, 
    Terametres, Petametres, LightYears, Parsecs, Exametres, HubbleLengths, 
    Zettametres, Yottametres
  Distance* = object
    size*: float
    units*: LengthMeasure

const length_multipliers* = [
  1.62e-35,                  # PlanckLengths per Metre
  1e-24,                     # Yoctometres per Metre
  1e-21,                     # Zeptometres per Metre
  1e-18,                     # Attometres per Metre
  1e-15,                     # Femtometres per Metre
  1e-12,                     # Picometres per Metre
  1e-10,                     # Angstroms per Metre
  1e-9,                      # Nanometres per Metre
  1e-6,                      # Micrometres per Metre
  2.54e-5,                   # Thou per Metre
  1e-3,                      # Millimetres per Metre
  1e-2,                      # Centimetres per Metre
  0.0254,                    # Inches per Metre
  1e-1,                      # Decimetres per Metre
  0.3048,                    # Feet per Metre
  0.9144,                    # Yards per Metre
  1.0,                       # Metres per Metre
  1.8288,                    # Fathoms per Metre
  2.4,                       # HorseLengths per Metre
  5.0292,                    # Rods per Metre
  1e1,                       # Decametres per Metre
  20.1168,                   # Chains per Metre
  1e2,                       # Hectometres per Metre
  201.1680,                  # Furlongs per Metre
  1e3,                       # Kilometres per Metre
  1_609.344,                 # Miles per Metre
  1852.0,                    # NauticalMiles per Metre
  5556.0,                    # Leagues per Metre
  1e6,                       # Megametres per Metre
  6.371009e6,                # EarthRadii per Metre
  3.84402e8,                 # LunarDistances per Metre
  1e9,                       # Gigametres per Metre
  1.495978707e11,            # AstronomicalUnits per Metre
  1e12,                      # Terametres per Metre
  1e15,                      # Petametres per Metre
  9.4607304725808e15,        # LightYears per Metre
  3.08567758146719e16,       # Parsecs per Metre
  1e18,                      # Exametres per Metre
  1.40398329956757145e20,    # HubbleLengths per Metre
  1e21,                      # Zettametres per Metre
  1e24                       # Yottametres per Metre
]

proc newDistance*(size: float, unit_type: LengthMeasure): Distance =
  ## Constructor method for Distance objects
  result.size = size
  result.units = unit_type

proc sizeAs*(measurement: Distance, units: LengthMeasure): float =
  ## Returns the floating point representation of a Distance
  ## in the unit-type chosen by the user. Uses array lookup
  ## for performance reasons rather than hash table
  ## 
  ##.. code-block:: nim
  ##
  ##     const 
  ##       roadtripToNY = newDistance(4000, Kilometres)
  ##     echo roadtripToNY.sizeAs(Metres)
  ## 
  ##     # Outputs: 4000000.0
  ## 
  result = measurement.size * length_multipliers[ord(measurement.units)] / 
                     length_multipliers[ord(units)]

proc to*(measurement: var Distance, units: LengthMeasure) =
  ## Mutates a Distance object in to the unit-type
  ## given by the user, converting the `size` proportionally.
  ## 
  ##.. code-block:: nim
  ##
  ##     const 
  ##       roadtripToNY = newDistance(4000, Kilometres)
  ##     roadtripToNY.to(Metres)
  ##     echo roadtripToNY
  ## 
  ##     # Outputs: 4000000.0 Metres
  ## 
  measurement.size = measurement.sizeAs(units)
  measurement.units = units

proc copyAs*(measurement: Distance, units: LengthMeasure): Distance =
  ## Creates a duplicate Distance object in the unit-type given by
  ## the user, converting the `size` proportionally.
  result.size = measurement.sizeAs(units)
  result.units = units

proc getHaversineDistance*(pointA, pointB: Point, 
                           units: LengthMeasure = Metres): Distance =
  ## Attempts to find the distance between pointA and pointB
  ## using a Haversine distance calculation. Outputs the 
  ## distance in the unit-type chosen by the user.
  ## 
  ##.. code-block:: nim
  ##
  ##     const 
  ##       Philadelphia = newPoint(39.9526, -75.1652)
  ##       NY = newPoint(40.7128, -74.0059)
  ##     echo getHaversineDistance(NY, Philadelphia, Miles)
  ## 
  ##     # Outputs: 80.54174876842661 Miles
  ## 
  if pointA == pointB:
    result.size = 0.0
    result.units = units
  else:
    let 
      a = sin((pointB.latitude - pointA.latitude).degToRad / 2) * 
          sin((pointB.latitude - pointA.latitude).degToRad / 2) + 
          cos(pointA.latitude.degToRad) * cos(pointB.latitude.degToRad) * 
          sin((pointB.longitude - pointA.longitude).degToRad / 2) *
          sin((pointB.longitude - pointA.longitude).degToRad / 2)
      distance = 6.371009e6 * 2 * arctan2(sqrt(a), sqrt(1 - a))
    result.size = distance * length_multipliers[ord(Metres)] / 
                  length_multipliers[ord(units)]
    result.units = units

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

template `==` *(a: Distance, b: float): bool =
  a.size == b

template `!=` *(a: Distance, b: float): bool =
  a.size != b

template `>` *(a: Distance, b: float): bool =
  a.size > b

template `>=` *(a: Distance, b: float): bool =
  a.size >= b

template `<=` *(a: Distance, b: float): bool =
  a.size <= b

template `<` *(a: Distance, b: float): bool =
  a.size < b

template `==` *(a: float, b: Distance): bool =
  a == b.size

template `!=` *(a: float, b: Distance): bool =
  a != b.size

template `>` *(a: float, b: Distance): bool =
  a > b.size

template `>=` *(a: float, b: Distance): bool =
  a >= b.size

template `<=` *(a: float, b: Distance): bool =
  a <= b.size

template `<` *(a: float, b: Distance): bool =
  a < b.size

template `echo` *(a: Distance) =
  echo($a.size & " " & $a.units)

template `$` *(a: Distance): string =
  $a.size & " " & $a.units

proc getVincentyDistance*(pointA, pointB: Point, 
                          units: LengthMeasure = Metres): Distance = 
  ## Attempts to find the distance between pointA and pointB
  ## using the iterative Vincenty distance calculation outlined in the Vincenty
  ## Wikipedia entry: https://en.wikipedia.org/wiki/Vincenty%27s_formulae
  ## Outputs the distance in the unit-type chosen by the user.
  ## TODO: Add error handling.
  ## 
  ##.. code-block:: nim
  ##
  ##     const 
  ##       Philadelphia = newPoint(39.9526, -75.1652)
  ##       NY = newPoint(40.7128, -74.0059)
  ##     echo getVincentyDistance(NY, Philadelphia, Miles)
  ## 
  ##     # Outputs: 80.61134264315091 Miles
  ## 
  if pointA == pointB:
    result.size = 0.0
    result.units = units
    return result
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
      result.size = abs(ellipsoidalDistance)
      result.units = Metres
      if units != Metres:
        result.to(units)
      return result
  result.size = 0.0
  result.units = units

proc getHaversineDistance*(points: varargs[Point], 
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
  for i in 0..<points.len - 1:
    result += getHaversineDistance(points[i], points[i + 1], units)
  result

proc getVincentyDistance*(points: varargs[Point], 
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
  for i in 0..<points.len - 1:
    result += getVincentyDistance(points[i], points[i + 1], units)
  result

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

proc getShortestHaversine*(points: varargs[Point], 
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
  var result = getHaversineDistance(point_list, units)
  while nextPermutation(point_list):
    var newDistance = getHaversineDistance(point_list, units)
    if newDistance < result:
      result = newDistance
  result

proc getShortestVincenty*(points: varargs[Point], 
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
  var result = getVincentyDistance(point_list, units)
  while nextPermutation(point_list):
    var newDistance = getVincentyDistance(point_list, units)
    if newDistance < result:
      result = newDistance
  result


