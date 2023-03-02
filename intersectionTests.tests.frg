#lang forge/bsl

open "intersection.frg"


test suite for canCross {

    //Truck on green light with speed 2
    -- When a vehicle goes through a light, S0 and S1 are identical
    example validTransition1 is {some pre, post: State | canCross[pre, post]} for {
        //#Int = 5
        //Test Setup
        State = `S0 + `S1 
        Vehicle = `V

        Truck = `Truck 
        Car = `Car  
        Bus = `Bus
        Van = `Van  
        Model = Truck + Car + Bus + Van

        South = `South
        North = `North
        East = `East
        West = `West
        Direction = South + North + East + West

        Light = `Light

        Near = `Near
        Far = `Far
        Position = Near + Far

        Red = `Red
        Yellow = `Yellow
        Green = `Green
        White = `White
        Color = Red + Yellow + Green + White

        //Test specs
        stSpeed = 
        `S0 -> `V -> 2 + 
        `S1 -> `V -> 2

        stModel = `S0 -> `V -> `Truck

        stSide = `S0 -> `V -> `Near + `S1 -> `V -> `Far

        //Light specs
        stLightDir = `S0 -> `Light -> `North + `S1 -> `Light -> `North
        stLightColor = `S0 -> `Light -> `Green + `S1 -> `Light -> `Green
    }

    //Truck on yellow light with speed 4, stops, light turns red
    example validTransition2 is {some pre, post: State | canCross[pre, post]} for {
        -- When a vehicle goes through a light, S0 and S1 are identical
          
        //Test Setup
        State = `S0 + `S1 
        Vehicle = `V

        Truck = `Truck 
        Car = `Car  
        Bus = `Bus
        Van = `Van  
        Model = Truck + Car + Bus + Van

        South = `South
        North = `North
        East = `East
        West = `West
        Direction = South + North + East + West

        Light = `Light

        Near = `Near
        Far = `Far
        Position = Near + Far

        Red = `Red
        Yellow = `Yellow
        Green = `Green
        White = `White
        Color = Red + Yellow + Green + White

        //Vehicle specs
        stSpeed = `S0 -> `V -> 4 + `S1 -> `V -> 0
        stModel = `S0 -> `V -> `Truck
        stStartDir = `S0 -> `V -> `South + `S1 -> `V -> `South
        stEndDir = `S0 -> `V -> `North + `S1 -> `V -> `North

        stSide = `S0 -> `V -> Near + `S1 -> `V -> Near

        //Light specs
        stLightDir = `S0 -> `Light -> `North + `S1 -> `Light -> `North
        stLightColor = `S0 -> `Light -> `Yellow + `S1 -> `Light -> `Red
    }

    
    //Car takes Uturn in intersection
    example validTransition3 is {some pre, post: State | canCross[pre, post]} for {
        //Sig and object names need to be different if using js visualization
        //Test Setup
        State = `S0 + `S1 
        Vehicle = `V

        Truck = `Truck 
        Car = `Car  
        Bus = `Bus
        Van = `Van  
        Model = Truck + Car + Bus + Van

        South = `South
        North = `North
        East = `East
        West = `West
        Direction = South + North + East + West

        Light = `Light

        Near = `Near
        Far = `Far
        Position = Near + Far

        Red = `Red
        Yellow = `Yellow
        Green = `Green
        White = `White
        Color = Red + Yellow + Green + White

        //Vehicle specs
        stSpeed = `S0 -> `V -> 4 + `S1 -> `V -> 3
        stModel = `S0 -> `V -> `Car
        stStartDir = `S0 -> `V -> `South + `S1 -> `V -> `North
        stEndDir = `S0 -> `V -> `North + `S1 -> `V -> `South

        stSide = `S0 -> `V -> Near + `S1 -> `V -> Far

        //Light specs
        stLightDir = `S0 -> `Light -> `North + `S1 -> `Light -> `North
        stLightColor = `S0 -> `Light -> `Green + `S1 -> `Light -> `Green
    }

    //Car stays in place on Green light 
    example invalidTransition1 is not {some pre, post: State | canCross[pre, post]} for {
        //Sig and object names need to be different if using js visualization
        //Test Setup
        State = `S0 + `S1 
        Vehicle = `V

        Truck = `Truck 
        Car = `Car  
        Bus = `Bus
        Van = `Van  
        Model = Truck + Car + Bus + Van

        South = `South
        North = `North
        East = `East
        West = `West
        Direction = South + North + East + West

        Light = `Light

        Near = `Near
        Far = `Far
        Position = Near + Far

        Red = `Red
        Yellow = `Yellow
        Green = `Green
        White = `White
        Color = Red + Yellow + Green + White

        //Vehicle specs
        stSpeed = `S0 -> `V -> 4 + `S1 -> `V -> 3
        stModel = `S0 -> `V -> `Car
        stStartDir = `S0 -> `V -> `South + `S1 -> `V -> `North
        stEndDir = `S0 -> `V -> `South + `S1 -> `V -> `North

        stSide = `S0 -> `V -> Near + `S1 -> `V -> Near

        //Light specs
        stLightDir = `S0 -> `Light -> `North + `S1 -> `Light -> `North
        stLightColor = `S0 -> `Light -> `Green + `S1 -> `Light -> `Green
    }

    //Car goes through red light
    example invalidTransition2 is not {some pre, post: State | canCross[pre, post]} for {
        //Sig and object names need to be different if using js visualization
        //Test Setup
        State = `S0 + `S1 
        Vehicle = `V

        Truck = `Truck 
        Car = `Car  
        Bus = `Bus
        Van = `Van  
        Model = Truck + Car + Bus + Van

        South = `South
        North = `North
        East = `East
        West = `West
        Direction = South + North + East + West

        Light = `Light

        Near = `Near
        Far = `Far
        Position = Near + Far

        Red = `Red
        Yellow = `Yellow
        Green = `Green
        White = `White
        Color = Red + Yellow + Green + White

        //Vehicle specs
        stSpeed = `S0 -> `V -> 4 + `S1 -> `V -> 3
        stModel = `S0 -> `V -> `Car
        stStartDir = `S0 -> `V -> `South + `S1 -> `V -> `South
        stEndDir = `S0 -> `V -> `North + `S1 -> `V -> `North

        stSide = `S0 -> `V -> `Near + `S1 -> `V -> `Far

        startDirection = `V -> `South
        endDirection = `V -> `South

        //Light specs
        stLightDir = `S0 -> `Light -> `North + `S1 -> `Light -> `North
        stLightColor = `S0 -> `Light -> `Red + `S1 -> `Light -> `Red
    }


}

test suite for canTurn {

    //Car takes a right turn
    example validTurn1 is {some st: State | canTurn[st]} for {
        //#Int = 5
        //Test Setup
        State = `S0 
        Vehicle = `V

        Truck = `Truck 
        Car = `Car  
        Bus = `Bus
        Van = `Van  
        Model = Truck + Car + Bus + Van

        South = `South
        North = `North
        East = `East
        West = `West
        Direction = South + North + East + West

        Light = `Light

        Near = `Near
        Far = `Far
        Position = Near + Far

        Red = `Red
        Yellow = `Yellow
        Green = `Green
        White = `White
        Color = Red + Yellow + Green + White

        //Test specs
        stSpeed = 
        `S0 -> `V -> 2

        //Truck turns right
        stModel = `S0 -> `V -> `Truck
        stSide = `S0 -> `V -> `Near 
        stStartDir = `S0 -> `V -> `South
        stEndDir = `S0 -> `V -> `East 
        startDirection = `V -> `South
        endDirection = `V -> `East
        //Light specs
        stLightDir = `S0 -> `Light -> `North
        stLightColor = `S0 -> `Light -> `Green 
    }


    //Car takes left turn
    example validTurn2 is {some st: State | canTurn[st]} for {
        //#Int = 5
        //Test Setup
        State = `S0
        Vehicle = `V

        Truck = `Truck 
        Car = `Car  
        Bus = `Bus
        Van = `Van  
        Model = Truck + Car + Bus + Van

        South = `South
        North = `North
        East = `East
        West = `West
        Direction = South + North + East + West

        Light = `Light

        Near = `Near
        Far = `Far
        Position = Near + Far

        Red = `Red
        Yellow = `Yellow
        Green = `Green
        White = `White
        Color = Red + Yellow + Green + White

        //Test specs
        stSpeed = 
        `S0 -> `V -> 2 

        //Truck turns right
        stModel = `S0 -> `V -> `Truck
        stSide = `S0 -> `V -> `Near 
        stStartDir = `S0 -> `V -> `South 
        stEndDir = `S0 -> `V -> `West 
        startDirection = `V -> `South
        endDirection = `V -> `West
        //Light specs
        stLightDir = `S0 -> `Light -> `North 
        stLightColor = `S0 -> `Light -> `Green 
    }
    
}


