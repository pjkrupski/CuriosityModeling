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

sig State {
    next: lone State, -- the next state
    stvehicle: lone Vehicle, 
    stlight: lone Light,
    stcrosswalk: lone Crosswalk,
    //methods
    stSpeed: pfunc Vehicle -> Int,
    stModel: pfunc Vehicle -> Model,
    stStartDir: pfunc Vehicle -> Direction,
    stEndDir: pfunc Vehicle -> Direction,
    stSide: pfunc Vehicle -> Position,
    stLightColor: pfunc Light -> Color,
    stLightDir: pfunc Light -> Direction,
    stRightArrColor: pfunc Light -> Color,
    stLeftArrColor: pfunc Light -> Color
}

sig Vehicle {
    speed: one Int, -- how fast is the Vehicle driving?
    model: one Model, -- there are different rules for each type of Vehicle
    startDirection: one Direction, -- where is th Vehicle coming from?
    endDirection: one Direction, -- where is the Vehicle going?
    canTurnRight: one Boolean,
    canTurnLeft: one Boolean
}

sig Light {
    direction: one Direction, -- which direction is the light facing?
    mainLight: one Color, -- what color is the light?
    leftArrow: lone Color, -- what color is the left arrow?
    rightArrow: lone Color, -- what color is the right arrow?
    hasRightArrow: one Boolean, -- does the light have right arrow?
    hasLeftArrow: lone Boolean --does the light have a left arrow?
}

sig Crosswalk {
    color: one Color, -- can the pedestrian walk or not?
    forwardDirection: one Direction, -- first lane the crosswalk crosses
    reverseDirection: one Direction, -- other lane that the crosswalk crosses 
    occupied: one Boolean -- is there a pedestrian in the crosswalk
}

//rules
//helper function
pred canTurnRightOnYellow[s: State, v: Vehicle] {
    {s.stModel[v] = Car} or {s.stModel[v] = Van} => {
        s.stSpeed[v] >= 5 => {
            v.canTurnRight = True
        }
        v.speed < 5 => {
            v.canTurnRight = False
        }   
    }
    {s.stModel[v] = Bus} or {s.stModel[v] = Truck} => {
        s.stSpeed[v] >= 3 => {
            v.canTurnRight = True
        } 
        s.stSpeed[v] < 3 => {
            v.canTurnRight = False
        }
    }
}
pred canTurnLeftOnYellow[s: State, v: Vehicle] {
    {s.stModel[v] = Car} or {s.stModel[v] = Van} => {
        s.stSpeed[v] >= 5 => {
            v.canTurnLeft = True
        }
        s.stSpeed[v] < 5 => {
            v.canTurnLeft = False
        }   
    }
    {s.stModel[v] = Bus} or {s.stModel[v] = Truck} => {
        s.stSpeed[v] >= 3 => {
            v.canTurnLeft = True
        } 
        s.stSpeed[v] < 3 => {
            v.canTurnLeft = False
        }
    }
}
pred yellowLight[pre: State, post: State, v: Vehicle] {
    {pre.stModel[v] = Car} or {pre.stModel[v] = Van} => {
        pre.stSpeed[v] >= 5 => {
            pre.stSide[v] = Near
            post.stSide[v] = Far
        }
        pre.stSpeed[v] < 5 => {
            pre.stSide[v] = Near
            post.stSide[v] = Near
        }   
    }
    {pre.stModel[v] = Bus} or {pre.stModel[v] = Truck} => {
        pre.stSpeed[v] >= 3 => {
            pre.stSide[v] = Near
            post.stSide[v] = Far
        } 
        pre.stSpeed[v] < 3 => {
            pre.stSide[v] = Near
            post.stSide[v] = Near
        }
    }
}
//car can cross when light is green or can cross yellow if speed is above 50
pred canCross[pre: State, post: State] {
    some l: Light | {
        //for any one Vehicle
        some v: Vehicle | {
            //if the car is a car or van
            {pre.stModel[v] = Car} or {pre.stModel[v] = Van} => {
                //if the color of the light is green
                pre.stLightDir[l] = v.startDirection => {
                    pre.stLightColor[l] = Green => {
                        //assuming that for the initial state the car starts at the near
                        // position
                        pre.stSide[v] = Near
                        post.stSide[v] = Far
                    }
                    pre.stLightColor[l] = Yellow => {
                        yellowLight[pre, post, v]
                    }
                    pre.stLightColor[l] = Red => {
                        pre.stSide[v] = Near
                        post.stSide[v] = Near
                    }
                }
            }
        }
    }
}
//can turn when arrow is green/yellow, 
//or on red and crosswalk occupied is false, when changing direction paths, 
//and crosswalk occupied is false
pred canTurn[s: State] {
    some l: Light | {
        some v: Vehicle | {
            s.stLightColor[l] = Green => {
                v.canTurnRight = True
                v.canTurnLeft = False
            }
            s.stLightColor[l] = Yellow => {
                canTurnRightOnYellow[v]
                canTurnLeftOnYellow[v]
            }
            s.stLightColor[l] = Red => {
                l.hasRightArrow = True => {
                    s.stRightArrColor[l] = Green => {
                        v.canTurnRight = True
                    }
                    s.stRightArrColor[l] = Yellow => {
                        canTurnRightOnYellow[v]
                    }
                    s.stRightArrColor[l] = Red => {
                        v.canTurnRight = False
                    }
                }
                l.hasLeftArrow = True => {
                    s.stLeftArrColor[l] = Green => {
                        v.canTurnLeft = True
                    }
                    s.stLeftArrColor[l] = Yellow => {
                        canTurnLeftOnYellow[v]
                    }
                    s.stLeftArrColor[l] = Red => {
                        v.canTurnLeft = False
                    }
                }
                l.hasRightArrow = False => {
                    {s.stModel[v] = Car or s.stModel[v] = Van} => {
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
                                c.forwardDirection = East => {
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
                    {s.stModel[v] = Bus or s.stModel[v] = Truck} => {
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

//assuming the Vehicle can turn


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
        c.forwardDirection = North iff c.reverseDirection = South
        c.forwardDirection = East iff c.reverseDirection = West

        --Crosswalk must be unoccupied if light is red
        c.color = Red implies c.occupied = False
    }   

    --Crosswalk must be red if intersecting traffic light is green
    all c: Crosswalk | c.forwardDirection = North implies {
        some l: Light | (l.direction = East or l.direction = West) and l.mainLight != Red implies {
            c.color = Red
        }
    }

    all c: Crosswalk | c.forwardDirection = East implies {
        some l: Light | (l.direction = North or l.direction = South) and l.mainLight != Red implies {
            c.color = Red
        }
    }
}