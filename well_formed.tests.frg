#lang forge/bsl

open "intersection.frg"

test suite for wellformedVehicle {
    example validVehicle is wellformedVehicle for {
        State = `S0
        Vehicle = `V0
        North = `North0
        South = `South0
        East = `East0
        West = `West0
        Direction = North + South + East + West
        startDirection = `V0 -> `North0
        endDirection = `V0 -> `South0
    }
    example invalidBehicle is not wellformedVehicle for {
        State = `S0
        Vehicle = `V0
        North = `North0
        South = `South0
        East = `East0
        West = `West0
        Direction = North + South + East + West
        startDirection = `V0 -> `North0
        endDirection = `V0 -> `North0
    }
}

test suite for wellformedLight {
    example validLight is wellformedLight for {
        Light = `L0
        Red = `Red0
        Yellow = `Yellow0
        Green = `Green0
        White = `White0
        Color = Red + Yellow + Green + White
        mainLight = `L0 -> `Red0
        leftArrow = `L0 -> `Green0
        rightArrow = `L0 -> `Red0
    }
    example invalidLight is not wellformedLight for {
        Light = `L0
        Red = `Red0
        Yellow = `Yellow0
        Green = `Green0
        White = `White0
        Color = Red + Yellow + Green + White
        mainLight = `L0 -> `Red0
        leftArrow = `L0 -> `Green0
        rightArrow = `L0 -> `Green0
    }
}
test suite for wellformedCrosswalk {
    example validCrosswalk is wellformedCrosswalk for {
        Crosswalk = `C0
        North = `North0
        South = `South0
        East = `East0
        West = `West0
        Light = `L0
        Red = `Red0
        Yellow = `Yellow0
        Green = `Green0
        White = `White0
        //TODO: Was missing Color definition causing error
        //Please specify an upper bound for ancestors of Red.
        Color = Red + Yellow + Green + White   
        Direction = North + South + East + West
        forwardDirection = `C0 -> North
        reverseDirection = `C0 -> South
        
    }
}