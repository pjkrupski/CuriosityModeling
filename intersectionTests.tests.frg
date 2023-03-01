#lang forge/bsl

open "intersection.frg"

test suite for wellformedVehicle {
    
}

test suite for wellformedLight {
    
}

test suite for wellformedCrosswalk {
    
}

test suite for canCross {

    //Truck on green light with speed 2
    example validTransition1 is {some pre, post: State | canCross[pre, post]} for {
        -- When a vehicle goes through a light, S0 and S1 are identical
        State = `S0 + `S1 
        Vehicle = `V 
        Truck = `Truck  
        South = `South
        North = `North

        Light = `Light

        Near = `Near
        Far = `Far
        Position = Near + Far

        Red = `Red
        Yellow = `Yellow
        Green = `Green
        White = `White
        Color = `Red + `Yellow + `Green + `White

        //Car specs
        speed = 
        `S0 -> `V -> 2 + 
        `S1 -> `V -> 2
        
        model = `S0 -> `V -> `Truck
        startDirection = `S0 -> `V -> `South + `S1 -> `V -> `South
        endDirection = `S0 -> `V -> `North + `S1 -> `V -> `North

        //Light specs
        direction = `S0 -> `Light -> `North + `S1 -> `Light -> `North
        mainLight = `S0 -> `Light -> `Green + `S1 -> `Light -> `Green
    }

    //Truck on yellow light with speed 4
    example validTransition2 is {some pre, post: State | canCross[pre, post]} for {
        -- When a vehicle goes through a light, S0 and S1 are identical
        State = `S0 + `S1 
        Vehicle = `V 
        Truck = `Truck  
        South = `South
        North = `North

        Light = `Light

        Near = `Near
        Far = `Far
        Position = Near + Far

        Red = `Red
        Yellow = `Yellow
        Green = `Green
        White = `White
        Color = `Red + `Yellow + `Green + `White

        //Vehicle specs
        speed = `S0 -> `V -> 2 + `S1 -> `V -> 0
        model = `S0 -> `V -> `Truck
        startDirection = `S0 -> `V -> `South + `S1 -> `V -> `South
        endDirection = `S0 -> `V -> `North + `S1 -> `V -> `North

        //Light specs
        direction = `S0 -> `Light -> `North + `S1 -> `Light -> `North
        mainLight = `S0 -> `Light -> `Yellow + `S1 -> `Light -> `Red
    }

    //Car takes Uturn in intersection
    example invalidTransition1 is not {some pre, post: State | canCross[pre, post]} for {
        //Sig and object names need to be different if using js visualization
        State = `S0 + `S1 
        Vehicle = `V 
        Truck = `Car
        South = `South
        North = `North

        Light = `Light

        Near = `Near
        Far = `Far
        Position = Near + Far

        Red = `Red
        Yellow = `Yellow
        Green = `Green
        White = `White
        Color = `Red + `Yellow + `Green + `White

        //Vehicle specs
        speed = `S0 -> `V -> 2 + `S1 -> `V -> 2
        model = `S0 -> `V -> `Truck
        startDirection = `S0 -> `V -> `South + `S1 -> `V -> `North
        endDirection = `S0 -> `V -> `North + `S1 -> `V -> `South

        //Light specs
        direction = `S0 -> `Light -> `North + `S1 -> `Light -> `North
        mainLight = `S0 -> `Light -> `Green + `S1 -> `Light -> `Green
    }

    //Car goes through redlight
    example invalidTransition2 is not {some pre, post: State | canCross[pre, post]} for {
        State = `S0 + `S1 
        Vehicle = `V 
        Truck = `Truck  
        South = `South
        North = `North

        Light = `Light

        Near = `Near
        Far = `Far
        Position = Near + Far

        Red = `Red
        Yellow = `Yellow
        Green = `Green
        White = `White
        Color = `Red + `Yellow + `Green + `White

        //Vehicle specs
        speed = `S0 -> `V -> 2 + `S1 -> `V -> 4
        model = `S0 -> `V -> `Truck
        startDirection = `S0 -> `V -> `South + `S1 -> `V -> `South
        endDirection = `S0 -> `V -> `North + `S1 -> `V -> `North

        //Light specs
        direction = `S0 -> `Light -> `North + `S1 -> `Light -> `North
        mainLight = `S0 -> `Light -> `Red + `S1 -> `Light -> `Red
    }


}

test suite for canTurnRight {
    
}


