#lang forge/bsl

sig Person {
    parent1 : lone Person,
    parent2 : lone Person,
    spouse  : lone Person
}
// DO NOT EDIT above this line  
// Note that in the instructions below, a person X is an ancestor to person Y if 
// X is reachable from Y by chaining `.parent1`s or `.parent2`s in any order, any number of times, on Y.

// You will find the "reachable" built-in predicate useful. See the docs linked in the handout.

pred FamilyFact {
    // No person should be their own spouse
    not (some p: Person | p.spouse = p)
    // You cannot be an ancestor of yourself
    not (some p: Person | reachable[p, p, parent1, parent2])
    // You are your spouse's spouse
    all disj p1, p2: Person | p1.spouse = p2 => p2.spouse = p1
    // You cannot be an ancestor of your spouse
    not (some p: Person | reachable[p, p.spouse, parent1, parent2])
    // For any person :
    //  - Your ancestors on parent1's side cannot be your ancestors on parent2's side 
    //  - If someone is an ancestor to you they cannot be an ancestor to your spouse
    all p, r1: Person | reachable[r1, p.parent1, parent1, parent2] => not (reachable[r1, p.parent2, parent1, parent2])
    all person1, person2: Person | person1.parent1 = person2 => not (person1.parent2 = person2)
    all p1, p2: Person | reachable[p1, p2, parent1, parent2] => not (reachable[p1, p2.spouse, parent1, parent2])
}

pred ownGrandparent {
    // Fill in a constraint that requires there to be a case where someone is their own grandpa. 
    // (Properly expressing what it means to be your own grandpa is crucial!)
    some p: Person | {
        p = p.parent1.parent1 or p = p.parent1.parent2 or
        p = p.parent2.parent1 or p = p.parent2.parent2 or
        p = p.parent1.spouse.parent1 or 
        p = p.parent2.spouse.parent1 or 
        p = p.parent1.spouse.parent2 or 
        p = p.parent2.spouse.parent2 or 
        p = p.parent1.spouse.parent1.spouse or 
        p = p.parent1.spouse.parent2.spouse or 
        p = p.parent2.spouse.parent1.spouse or 
        p = p.parent2.spouse.parent2.spouse
    }
    

}

// While it can be fun to test this for more people your solution should
// be valid for exactly 4 Person
run {FamilyFact ownGrandparent} for exactly 4 Person