import math

type
  Point* = tuple[latitude, longitude: float]
  CardinalDirection* = enum
    South, West, East, North

template between*(a, b, c: untyped): bool =
  ## An inclusive between to ensure `a` is 
  ## within the specified range.
  if a >= b and a <= c:
    true
  else:
    false

proc newPoint*(latitude, longitude: float): Point =
  ## Constructor for Point objects that enforces the
  ## correct range for latitude and longitude
  if latitude.between(-90.0, 90.0) and longitude.between(-180.0, 180.0):
    return (latitude: latitude, longitude: longitude)
  else:
    raise newException(IOError, "Invalid latitude or longitude.")
  
template `echo` *(a: Point) =
  echo("Latitude: " & $a.latitude & ", Longitude: " & $a.longitude)

template `$` *(a: Point): string =
  "Latitude: " & $a.latitude & ", Longitude: " & $a.longitude

proc getBearing*(pointA, pointB: Point): float =
  ## Returns the bearing from point A to point B in degrees
  ## Requires some further error handling and functionality
  let λ = degToRad(pointB.longitude - pointA.longitude)
  radToDeg(arctan2(sin(λ) * cos(pointB.latitude), 
           cos(pointA.latitude) * sin(pointB.latitude) - 
           sin(pointA.latitude) * cos(pointB.latitude) * cos(λ)))
 
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

