#lang forge/bsl

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
}

sig State {
    next: lone State -- the next state
}
sig Light {
    direction: one Direction, -- which direction is the light facing?
    mainLight: one Color, -- what color is the light?
    leftArrow: lone Color, -- what color is the left arrow?
    rightArrow: lone Color, -- what color is the right arrow?
    hasRightArrow: one Boolean
    hasLeftArrow: one Boolean
}

sig Crosswalk {
    color: one Color, -- can the pedestrian walk or not?
    forwardDirection: one Direciton, -- first lane the crosswalk crosses
    reverseDirection: one Direction, -- other lane that the crosswalk crosses 
    occupied: one Boolean -- is there a pedestrian in the crosswalk
}

//rules
//helper function
pred canTurnRightOnYellow[v: Vehical] {
    {v.model = Car} or {v.model = Van} => {
        v.speed >= 50 => {
            v.canTurnRight = True
        }
        v.speed < 50 => {
            v.canTurnRight = False
        }   
    }
    {v.model = Bus} or {v.model = Truck} => {
        v.speed >= 35 => {
            v.canTurnRight = True
        } 
        v.speed < 35 => {
            v.canTurnRight = False
        }
    }
}
pred canTurnLeftOnYellow[v: Vehical] {
    {v.model = Car} or {v.model = Van} => {
        v.speed >= 50 => {
            v.canTurnLeft = True
        }
        v.speed < 50 => {
            v.canTurnLeft = False
        }   
    }
    {v.model = Bus} or {v.model = Truck} => {
        v.speed >= 35 => {
            v.canTurnLeft = True
        } 
        v.speed < 35 => {
            v.canTurnLeft = False
        }
    }
}
pred Yellow[pre: State, post: State, v: Vehical] {
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
//car can cross when light is green or can cross yellow if speed is above 50
pred canCross[pre: State, post: State] {
    some l: Light | {
        //for any one vehical
        some v: Vehical | {
            //if the car is a car or van
            {v.model = Car} or {v.model = Van} => {
                //if the color of the light is green
                l.direction = v.startDirection => {
                    l.mainLight = Green => {
                        //assuming that for the initial state the car starts at the near
                        // position
                        v.side[pre] = Near
                        v.side[post] = Far
                    }
                    l.mainLight = Yellow => {
                        Yellow[pre, post, v]
                    }
                    l.mainLight = Red => {
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
pred canTurn {
    some l: Light | {
        some v: Vehical | {
            l.mainLight = Green => {
                v.canTurnRight = True
                v.canTurnLeft = False
            }
            l.mainLight = Yellow => {
                canTurnRightOnYellow[v]
                canTurnLeftOnYellow[v]
            }
            l.mainLight = Red => {
                l.hasRightArrow = True => {
                    l.rightArrow = Green => {
                        v.canTurnRight = True
                    }
                    l.rightArrow = Yellow => {
                        canTurnRightOnYellow[v]
                    }
                    l.rightArrow = Red => {
                        v.canTurnRight = False
                    }
                }
                l.hasLeftArrow = True => {
                    l.leftArrow = Green => {
                        v.canTurnLeft = True
                    }
                    l.rightArrow = Yellow => {
                        canTurnLeftOnYellow[v]
                    }
                    l.leftArrow = Red => {
                        v.canTurnLeft = False
                    }
                }
                l.hasRightArrow = False => {
                    {v.model = Car or v.model = Van} => {
                        all c: Crosswalk | {
                            v.startDirection = North => {
                                c.forwardDirection = West => {
                                    c.occupied = False => {
                                        v.canTurnRight = True
                                    }
                                    c.occupied = True => {
                                        v.canTurnRight = False
                                    }
                                }
                            }
                            v.startDirection = South => {
                                c.forwardDireciton = East => {
                                    c.occupied = False => {
                                        v.canTurnRight = True
                                    }
                                    c.occupied  = True => {
                                        v.canTurnRight = False
                                    }
                                }
                            }
                            v.startDirection = East => {
                                c.forwardDirection = North => {
                                    c.occupied = False => {
                                        v.canTurnRight = True
                                    }
                                    c.occupied = True => {
                                        v.canTurnRight = False
                                    }
                                }
                            }
                            v.startDirection = West => {
                                c.forwardDirection = South => {
                                    c.occupied = False => {
                                        v.canTurnRight = True
                                    }
                                    c.occupied = True => {
                                        v.canTurnRight = False
                                    }
                                }
                            }
                        }
                    }
                    {v.model = Bus or v.model = Truck} => {
                        v.canTurnRight = False
                    }
                }
                l.hasLeftArrow = False => {
                    v.canTurnLeft = False
                }
            }
        }
    }
}

//assuming the vehical can turn
pred turn[pre]

 //Ed #269

 //Well formed

pred wellformedVehicle {
    all v: Vehicle | {
        v.startDirection != v.endDirection
    }
}

pred wellformedLight {
    all l: Light | {
        --Red main light cannot have both arrows green
        l.mainLight = Red implies (l.leftArrow = Red or l.rightArrow = Red)

        --Main light cannot be green if both arrows are red
        (l.leftArrow = Red and l.rightArrow = Red) implies l.mainLight = Red
    }
}

pred wellformedCrosswalk {

    all c: Crosswalk | {
        --Directions must be opposite since crosswalks are straight lines
        c.forwardDirection = North iff c.forwardDirection = South
        c.forwardDirection = East iff c.forwardDirection = West

        --Crosswalk must be unoccupied if light is red
        c.color = Red implies c.occupied = False
    }   

    --Crosswalk must be red if intersecting traffic light is green
    all c: Crosswalk | c.forwardDirection = North implies {
        some l: Light | (l.direction = East or l.direction = West) and l.mainLight != Red implies {
            c.color = Red
        }

        /*
        //TODO: Arrow case
        some l: Light | (l.direction = North or l.direction = South) and (l.leftArrow != Red or l.leftArrow != Red) implies {
            c.color = Red
        }
        */
    }

    all c: Crosswalk | c.forwardDirection = East implies {
        some l: Light | (l.direction = North or l.direction = South) and l.mainLight != Red implies {
            c.color = Red
        }
    }
}