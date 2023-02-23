#lang forge/bsl

open "intersection.frg"

test suite for wellformedVehicle {
    
}

test suite for wellformedLight {
    
}

test suite for wellformedCrosswalk {
    
}

test suite for canCross {
    example validTransition is {some pre, post: State | canCross[pre, post]} for {
        State = `S0 + `S1 -- only two states for simplicity
        Vehicle = `V   
        Near = `Near
        Far = `Far
        Position = Near + Far
        Red = `Red
        Yellow = `Yellow
        Green = `Green
        White = `White
        Color = `Red + `Yellow + `Green + `White
        shore = `A -> `S0 -> `Near + 
        
        //Car specs
        speed = `V -> 
    }
}

test suite for canTurnRight {
    
}


