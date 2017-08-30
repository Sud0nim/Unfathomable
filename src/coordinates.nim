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
    result.latitude = latitude
    result.longitude = longitude
  else:
    raise newException(IOError, "Invalid latitude or longitude.")
  
template `echo` *(a: Point) =
  echo("Latitude: " & $a.latitude & ", Longitude: " & $a.longitude)

template `$` *(a: Point): string =
  result = "Latitude: " & $a.latitude & ", Longitude: " & $a.longitude

proc getBearing*(pointA, pointB: Point): float =
  ## Returns the bearing from point A to point B in degrees
  ## Requires some further error handling and functionality
  let λ = degToRad(pointB.longitude - pointA.longitude)
  result = radToDeg(arctan2(sin(λ) * cos(pointB.latitude), 
           cos(pointA.latitude) * sin(pointB.latitude) - 
           sin(pointA.latitude) * cos(pointB.latitude) * cos(λ)))
 
#[
WIP: Parsing string coordinates
proc parseCoordinates(latitudeOrLongitude: string): float =
  var 
    b = latitudeOrLongitude.split
    parsedCoordinate: float
  if b.len == 4:
    try:
      var
        degrees = parseFloat(b[0].replace("°", ""))
        minutes = parseFloat(b[1].replace("′", ""))
        seconds = parseFloat(b[2].replace("″", ""))
        bearing = b[3] #make proc to parseDirection and return an enum of North, South, East West
        parsedCoordinate = degrees + minutes / 60 + seconds / 3600
      if bearing in ["s", "S"]: #improve this with parseDirection proc
        parsedCoordinate *= -1.0
    except IOError:
        ## handle errors  
  elif b.len == 3:
    try:
      var
        degrees = parseFloat(b[0].replace("°", ""))
        minutes = parseFloat(b[1].replace("′", ""))
        bearing = b[2] #make proc to parseDirection and return an enum of North, South, East West
        parsedCoordinate = degrees + minutes / 60
      if bearing in ["s", "S"]: #improve this with parseDirection proc
        parsedCoordinate *= -1.0
    except IOError:
        ## handle errors
  elif b.len == 2:
    try:
      var
        degrees = parseFloat(b[0].replace("°", ""))
        bearing = b[1] #make proc to parseDirection and return an enum of North, South, East West
        parsedCoordinate = degrees
      if bearing in ["s", "S"]: #improve this with parseDirection proc
        parsedCoordinate *= -1.0
    except IOError:
        ## handle errors
  elif b.len == 1:
    try:
      parsedCoordinate = parseFloat(b[0])
    except IOError:
        ## handle errors for not being float either
  else:
    raise newException(IOError, "Invalid latitude or longitude.")
  parsedCoordinate
]#

