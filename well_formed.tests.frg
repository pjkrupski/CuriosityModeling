#lang forge/bsl

open "intersection.frg"

test suite for wellformedVehicle {
    example validVehicle is wellformedVehicle for {
        //define the current state
        State = `S0
        //define vehicle
        Vehicle = `V0
        //define cardinal directions
        North = `North0
        South = `South0
        East = `East0
        West = `West0
        Direction = North + South + East + West
        //start and end direction of vehicle
        startDirection = `V0 -> `North0
        endDirection = `V0 -> `South0
    }
    example validVehicle1 is wellformedVehicle for {
        //define the current state
        State = `S0
        //define vehicle
        Vehicle = `V0
        //define cardinal directions
        North = `North0
        South = `South0
        East = `East0
        West = `West0
        Direction = North + South + East + West
        //start and end direction of vehicle
        startDirection = `V0 -> `West0
        endDirection = `V0 -> `East0
    }
    example invalidVehicle is not wellformedVehicle for {
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
    example validLight1 is wellformedLight for {
        Light = `L0
        Red = `Red0
        Yellow = `Yellow0
        Green = `Green0
        White = `White0
        Color = Red + Yellow + Green + White
        mainLight = `L0 -> `Red0
        leftArrow = `L0 -> `Red0
        rightArrow = `L0 -> `Green0
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
        True = `True0
        False = `False0
        Color = Red + Yellow + Green + White
        Boolean = True + False
        Direction = North + South + East + West
        forwardDirection = `C0 -> `North0
        reverseDirection = `C0 -> `South0
        mainLight = `L0 -> `Red0
        occupied = `C0 -> `False0
    }
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
        True = `True0
        False = `False0
        Color = Red + Yellow + Green + White
        Boolean = True + False
        Direction = North + South + East + West
        direction = `L0 -> East
        forwardDirection = `C0 -> `North0
        mainLight = `L0 -> `Yellow0
        color = `C0 -> `Red0
    }
    example invalidCrosswalk is not wellformedCrosswalk for {
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
        True = `True0
        False = `False0
        Color = Red + Yellow + Green + White
        Boolean = True + False
        Direction = North + South + East + West
        direction = `L0 -> East
        forwardDirection = `C0 -> `North0
        mainLight = `L0 -> `Yellow0
        color = `C0 -> `White0
    }
}