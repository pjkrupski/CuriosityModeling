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

sig Vehical {
    speed: one Int, -- how fast is the vehical driving?
    model: one Model, -- there are different rules for each type of vehical
    startDirection: one Direction, -- where is th vehical coming from?
    endDirection: one Direction, -- where is the vehical going?
    side: pfunc State -> Postion
}

sig State {
    next: lone State -- the next state
}
sig light {
    direction: one Direction, -- which direction is the light facing?
    mainLight: one Color, -- what color is the light?
    leftArrow: lone Color, -- what color is the left arrow?
    rightArrow: lone Color, -- what color is the right arrow?
}

sig crosswalk {
    color: one Color, -- can the pedestrian walk or not?
    forwardDirection: one Direciton, -- first lane the crosswalk crosses
    reverseDirection: one Direction, -- other lane that the crosswalk crosses 
    occupied: one Boolean -- is there a pedestrian in the crosswalk
}

//rules

//car can cross when light is green or can cross yellow if speed is above 50
pred canCross[pre: State, post: State, l: Light] {
    //for any one vehical
    some v: Vehical | {
        //if the car is a car or van
        {v.model = Car} or {v.model = Van} => {
            //if the color of the light is green
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
