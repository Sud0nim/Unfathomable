# Unfathomable

Distance and area objects and conversions.

Note: While conversions and calculations should be correct - this library is only a learning exercise for me, so it may be better to roll your own calculations if you are concerned about performance or avoiding possible rounding errors/precision.

# Examples:

Creating a distance object:

    var 
      some_distance = newDistance(1.0, Kilometres)
      other_distance = Distance(size: 100.0, units: Metres)
    echo some_distance
    echo other_distance

Output:

    1.0 Kilometres
    100.0 Metres
    
Creating an area object:
    
    var
      some_area = newArea(5, SquareKilometres)
      other_area = Area(size: 10, units: SquareMetres)
      third_area = newArea(some_distance, other_distance)
    echo some_area
    echo other_area
    echo third_area
    
Output:

    5.0 SquareKilometres
    10.0 SquareMetres
    0.1 SquareKilometres
      
Converting a distance object to a different unit of measurement:

    var 
      some_distance = newDistance(1.0, Kilometres)
    some_distance.to(Parsecs)
    echo some_distance
    
Output:

    3.240779289469757e-14 Parsecs
    
Getting the length of a distance object as a float without mutating the object:

    var 
      some_distance = newDistance(1.0, Kilometres)
    echo some_distance.sizeAs(Picometres)
    
Output:

    1000000000000000.0
    
Creating a copy of a distance object in a different unit of measurement:

    var 
      some_distance = newDistance(1.0, Kilometres)
      a_new_distance = some_distance.copyAs(Centimetres)
    echo a_new_distance
    
Output:

    100000.0 Centimetres
    
Arithmetic with distance objects:

    var 
      some_distance = newDistance(1.0, Kilometres)
      other_distance = Distance(size: 100.0, units: Metres)
    echo some_distance + other_distance
    echo some_distance - other_distance
    echo some_distance * other_distance
    echo some_distance / other_distance
    
Output:

    1.1 Kilometres
    0.9 Kilometres
    0.1 Kilometres
    10.0 Kilometres
    
  
