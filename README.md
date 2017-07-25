# Unfathomable

Distance and area objects and conversions.

Note: While conversions and calculations should be correct - this library is only a learning exercise for me, so it may be better to roll your own calculations if you are concerned about performance or avoiding possible rounding errors/precision.

# Examples:

Creating a distance object:

    let 
      someDistance = newDistance(1.0, Kilometres)
      otherDistance = Distance(size: 100.0, units: Metres)
    echo someDistance
    echo otherDistance

Output:

    1.0 Kilometres
    100.0 Metres
      
Converting a distance object to a different unit of measurement:

    var 
      someDistance = newDistance(1.0, Kilometres)
    someDistance.to(Parsecs)
    echo someDistance
    
Output:

    3.240779289469757e-14 Parsecs
    
Getting the length of a distance object as a float without mutating the object:

    let 
      someDistance = newDistance(1.0, Kilometres)
    echo someDistance.sizeAs(Picometres)
    
Output:

    1000000000000000.0
    
Creating a copy of a distance object in a different unit of measurement:

    let 
      someDistance = newDistance(1.0, Kilometres)
      aNewDistance = someDistance.copyAs(Centimetres)
    echo aNewDistance
    
Output:

    100000.0 Centimetres
    
Arithmetic with distance objects:

    let 
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
    
Creating an area object:
    
    let
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
    
      
Converting an area object to a different unit of measurement:

    var 
      someArea = newArea(10000, SquareLeagues)
    someArea.to(SquareMiles)
    echo someArea
    
Output:

    119186.4004348653 SquareMiles
    
Getting the size of an area object as a float without mutating the object:

    let 
      someArea = newArea(10000, SquareMetres)
    echo someArea.sizeAs(SquareYards)
    
Output:

    11959.9004630108
    
Creating a copy of an area object in a different unit of measurement:

    let 
      someArea = newArea(1.0, SquareKilometres)
      aNewArea = someArea.copyAs(SquareCentimetres)
    echo aNewArea
    
Output:

    10000000000.0 SquareCentimetres
    
Arithmetic with distance objects:

    let 
      someArea = newArea(1.0, SquareKilometres)
      otherArea = Area(size: 100.0, units: SquareMetres)
    echo someArea + otherArea
    echo someArea - otherArea
    echo someArea * otherArea
    echo someArea / otherArea
    echo 2 * someArea
    echo someArea * 2
    echo someArea / 2
    
Output:

    1.0001 SquareKilometres
    0.9999 SquareKilometres
    0.0001 SquareKilometres
    10000.0 SquareKilometres
    2.0 SquareKilometres
    2.0 SquareKilometres
    0.5 SquareKilometres
    
    
