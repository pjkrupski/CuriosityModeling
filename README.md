# CuriosityModeling
CS1710GroupProject

Goal:
The goal for this project is to model a four way traffic light with bi-directional cross walks and the potential of pedestrian traffic. The predicates in the model ensure that no traffic will be unsafely intersecting each other’s path and that pedestrians will enjoy a right of way when their cross walk has a white light.


Rules:
Vehicles may not go through red lights however may make a right on red if the adjacent cross walk is unoccupied. In the case of a yellow light, vehicles may or may not proceed based on their stopping distance. The following are the parameters set for the four listed vehicle types

-Car: Must stop at yellow light if speed is under 7
-Truck: Must stop at yellow light if speed is under 6
-Van: Must stop at yellow light if speed is under 5
-Bus: Must stop at yellow light if speed is under 4



Specifications:
The specifications to build out elements of this model in forge were completed as follows  

sig car:
-  speed type: Int 
-  model (bus, truck, car, van) ex. one sig Bus extends Model {}
-  start direction (north, south, east, west) ex. one sig North extends Direction {}
-  end direction (north, south, east, west)
-  start position (Near or Far)
-  end position (Near or Far)

sig light:
-  direction one sig North extends Direction {}
-  mainLight: Color (red, yellow, green) ex. one sig Red extends Color {}
-  leftArrow: Color
-  rightArrow: Color

sig crosswalk:
-  color (white, red)
-  forwardDirection
-  reverseDirection
-  occupied: Boolean

rules: 
- car can cross when light is green or can cross yellow if speed is above 50
- can turn when arrow is green/yellow, or on red and crosswalk occupied is false, when changing direction paths, and crosswalk occupied is false
- cannot turn in any other case
- type bus and truck cannot turn on red, spead threshold is lower for crossing yellow lights



Edge cases: 
After testing this model we discovered multiple scenarios that were being aloud that we had not initially thought of. For cases such as this we tried to stay as close as possible to how things work in an actual traffic light. Some examples that we updated were
A vehicle can not make a U-turn and proceed in the opposite direction
A vehicle can not chose not to go when the light turns green 




Expectations in Sterling:
//Traces
When using the run statement in intersection.frg, tables are displayed in sterling that show the various 
properties of our state. This can be interpreted by seeing what a vehicles start and end direction are 
which indicates what direction its driving, next the corresponding light can be checked to see if the
vehicle would be allowed to cross the intersection either by going straight or taking a turn.

The Near and Far sigs on the vehicle position are what indicate that the vehicle has actually moved.
These proeprties were very useful when running multiple traces to find if there were times the vehicle
was moving when it shouldn't have been or if it didnt move when it should have.   
   
   
   
Improvements:
If we were to expand on this model, we would enforce further restrictions that would represent more realities that are present in real life traffic lights. These could include factors such as
Bus may not make right on red
Stopping distance for yellow light is decreased under inclement weather
Pedestrians may occupy a red lit cross walk if no cars are present



