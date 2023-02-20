# CuriosityModeling
CS1710GroupProject
- sig car:
-  speed type: Int 
-  model (bus, truck, car, van) ex. one sig Bus extends Model {}
-  start direction (north, south, east, west) ex. one sig North extends Direction {}
-  end direction (north, south, east, west)

- sig light:
-  direction one sig North extends Direction {}
-  mainLight: Color (red, yellow, green) ex. one sig Red extends Color {}
-  leftArrow: Color
-  rightArrow: Color

- sig crosswalk:
-  color (white, red)
-  forwardDirection
-  reverseDirection
-  occupied: Boolean

rules: 
- car can cross when light is green or can cross yellow if speed is above 50
- can turn when arrow is green/yellow, or on red and crosswalk occupied is false, when changing direction paths, and crosswalk occupied is false
- cannot turn in any other cas
- type bus and truck cannot turn on red, spead threshold is lower for crossing yellow lights
- 
