# Unfathomable

Distance and area objects and conversions.

Note: While conversions and calculations should be correct - this library is only a learning exercise for me, so it may be better to roll your own calculations if you are concerned about performance or avoiding possible rounding errors/precision.

# Examples:

Creating a distance object:

    var 
      someDistance = newDistance(1.0, Kilometres)
      otherDistance = Distance(size: 100.0, units: Metres)
    echo someDistance
    echo otherDistance

Output:

    1.0 Kilometres
    100.0 Metres
    
Creating an area object:
    
    var
      someArea = newArea(5, SquareKilometres)
      otherArea = Area(size: 10, units: SquareMetres)
      thirdArea = newArea(someDistance, otherDistance)
    echo someArea
    echo otherArea
    echo thirdArea
    
Output:

    5.0 SquareKilometres
    10.0 SquareMetres
    0.1 SquareKilometres
      
Converting a distance object to a different unit of measurement:

    var 
      someDistance = newDistance(1.0, Kilometres)
    someDistance.to(Parsecs)
    echo someDistance
    
Output:

    3.240779289469757e-14 Parsecs
    
Getting the length of a distance object as a float without mutating the object:

    var 
      someDistance = newDistance(1.0, Kilometres)
    echo someDistance.sizeAs(Picometres)
    
Output:

    1000000000000000.0
    
Creating a copy of a distance object in a different unit of measurement:

    var 
      someDistance = newDistance(1.0, Kilometres)
      aNewDistance = someDistance.copyAs(Centimetres)
    echo aNewDistance
    
Output:

    100000.0 Centimetres
    
Arithmetic with distance objects:

    var 
      someDistance = newDistance(1.0, Kilometres)
      otherDistance = Distance(size: 100.0, units: Metres)
    echo someDistance + otherDistance
    echo someDistance - otherDistance
    echo someDistance * otherDistance
    echo someDistance / otherDistance
    echo 2 * someDistance
    echo someDistance * 2
    echo someDistance / 2
    
Output:

    1.1 Kilometres
    0.9 Kilometres
    0.1 Kilometres
    10.0 Kilometres
    2.0 Kilometres
    2.0 Kilometres
    0.5 Kilometres
    
  
