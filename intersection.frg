abstract sig Model{}
one sig Car extends Model{}
one sig Bus extends Model{}
one sig Truck extends Model{}
one sig Van extends Model{}

abstract sig Direction{}
one sig North extends Direction{}
one sig South extends Direction{}
one sig West extends Direction{}
one sig East extends Direction{}

abstract sig Color{}
one sig Red extends Color{}
one sig Yellow extends Color{}
one sig Green extends Color{}
one sig White extends Color{}

abstract sig Position{}
one sig Near extends Position{}
one sig Far extends Position{}

abstract sig Boolean {}
one sig True, False extends Boolean {}

sig Vehical {
    speed: one Int, -- how fast is the vehical driving?
    model: one Model, -- there are different rules for each type of vehical
    startDirection: one Direction, -- where is th vehical coming from?
    endDirection: one Direction, -- where is the vehical going?
    side: pfunc State -> Postion -- near means the car has not crossed the intersection, far means it has
    canTurnRight: one Boolean -- can the vehicle legally turn right?
    canTurnLeft: one Boolean -- can the vehicle legally turn left?
}

sig State {
    next: lone State -- the next state
}
sig Light {
    direction: one Direction, -- which direction is the light facing?
    mainLight: one Color, -- what color is the light?
    leftArrow: lone Color, -- what color is the left arrow?
    rightArrow: lone Color, -- what color is the right arrow?
}

sig Crosswalk {
    color: one Color, -- can the pedestrian walk or not?
    forwardDirection: one Direciton, -- first lane the crosswalk crosses
    reverseDirection: one Direction, -- other lane that the crosswalk crosses 
    occupied: one Boolean -- is there a pedestrian in the crosswalk
}

//rules
//helper function
pred Yellow[pre: State, post: State] {
    some v: Vehical | {
        {v.model = Car} or {v.model = Van} => {
            v.speed >= 50 => {
                v.side[pre] = Near
                v.side[post] = Far
            }
            v.speed < 50 => {
                v.side[pre] = Near
                v.side[post] = Near
            }   
        }
        {v.model = Bus} or {v.model = Truck} => {
            v.speed >= 35 => {
                v.side[pre] = Near
                v.side[post] = Far
            } 
            v.speed < 35 => {
                v.side[pre] = Near
                v.side[post] = Near
            }
        }
    }
}
//car can cross when light is green or can cross yellow if speed is above 50
pred canCross[pre: State, post: State] {
    some l: Light | {
        //for any one vehical
        some v: Vehical | {
            //if the car is a car or van
            {v.model = Car} or {v.model = Van} => {
                //if the color of the light is green
                l.direction = v.startDirection => {
                    l.color = Green => {
                        //assuming that for the initial state the car starts at the near
                        // position
                        v.side[pre] = Near
                        v.side[post] = Far
                    }
                    l.color = Yellow => {
                        Yellow[pre, post]
                    }
                    l.color = Red => {
                        v.side[pre] = Near
                        v.side[post] = Near
                    }
                }
            }
            {v.model = Bus} or {v.model = Truck} => {
                l.direction = v.startDirection => {
                    l.color = Green => {
                        v.side[pre] = Near
                        v.side[post] = Far
                    }
                    l.color = Yellow => {
                        Yellow[pre, post]
                    }
                    l.color = Red => {
                        v.side[pre] = Near
                        v.side[post] = Near
                    }
                }
            }

        }
    }

}
//can turn when arrow is green/yellow, 
//or on red and crosswalk occupied is false, when changing direction paths, 
//and crosswalk occupied is false
pred canTurnRight[pre: State, post: State] {
    some l: Light | {
        some v: Vehical | {
            l.color = Green => {
                v.canTurnRight = True
                v.canTurnLeft = False
            }
            
        }
    }
}
