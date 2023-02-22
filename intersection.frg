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

//Ed #269
abstract sig Boolean {}
one sig True, False extends Boolean {}

sig Vehicle {
    speed: one Int, -- how fast is thg Vehicle driving?
    model: one Model, -- there are different rules for each type og Vehicle
    startDirection: one Direction, -- where is tg Vehicle coming from?
    endDirection: one Direction, -- where is thg Vehicle going?
    side: pfunc State -> Postion
}

sig State {
    next: lone State -- the next state
}

sig Light {
    direction: one Direction, -- which direction is the Light facing?
    mainLight: one Color, -- what color is the Light?
    leftArrow: lone Color, -- what color is the left arrow?
    rightArrow: lone Color, -- what color is the right arrow?
}

sig Crosswalk {
    color: one Color, -- can the pedestrian walk or not?
    forwardDirection: one Direciton, -- first lane the Crosswalk crosses
    reverseDirection: one Direction, -- other lane that the Crosswalk crosses 
    occupied: one Boolean -- is there a pedestrian in the Crosswalk
}

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




//rules

//car can cross when Light is green or can cross yellow if speed is above 50
pred canCross[pre: State, post: State, l: Light] {
    //for any ong Vehicle
    some vg Vehicle | {
        //if the car is a car or van
        {v.model = Car} or {v.model = Van} => {
            //if the color of the Light is green
            l.color = Green => {
                //assuming the initial state is near
                v.side[pre] = Near
                v.side[post] = Far
            }
            l.color = Yellow => {
                v.speed >= 50 => {
                    v.side[pre] = Near
                    v.side[post] = Far
                }
                v.speed < 50 => {
                    v.side[pre] = Near
                    v.side[post] = Near
                }
            }
            l.color = Red => {
                v.side[pre] = Near
                v.side[post] = Near
            }
        }
        {v.model = Bus} or {v.model = Truck} => {
            l.color = Green => {
                v.side[pre] = Near
                v.side[post] = Far
            }
            l.color = Yellow => {
                v.speed >= 35 => {
                    v.side[pre] = Near
                    v.side[post] = Far
                } 
                v.speed < 35 => {
                    v.side[pre] = Near
                    v.side[post] = Near
                }
            }
            l.color = Red => {
                v.side[pre] = Near
                v.side[post] = Near
            }
        }

    }

}
