import SwiftPriorityQueue

// Parsing is too much of a pain, we're just doing to describe the
// problem by hand.

/* 
The first floor contains a thulium generator, a thulium-compatible microchip, a plutonium generator, and a strontium generator.
The second floor contains a plutonium-compatible microchip and a strontium-compatible microchip.
The third floor contains a promethium generator, a promethium-compatible microchip, a ruthenium generator, and a ruthenium-compatible microchip.
The fourth floor contains nothing relevant.
*/

let numFloors = 4
let numElements = 5

enum Elements : Int {
    case thulium = 0
    case plutonium = 1
    case strontium = 2
    case promethium = 3
    case ruthenium = 4
}

enum ObjectType {
    case generator
    case microchip
}

func allOneAndTwoObjectChoices<T>( _ collection : [T] ) -> [[T]] {
    var result = [[T]]()
    for i in 0..<collection.count {
        // One object
        result.append( [collection[i]] )
        for j in (i+1)..<collection.count {
            // Two objects
            result.append( [collection[i], collection[j] ] )
        }
    }
    return result
}

struct ProblemState : Comparable { 
    var generatorFloors : [Int]
    var microchipFloors : [Int]
    var elevator : Int
    var moves : Int
    
    // I can't figure out a way to cache this which isn't horiffically
    // painful, because it would have to be a mutating function.
    var heuristic : Int {
        let dFloors = ( 0..<numElements ).map { 4 - generatorFloors[ $0 ] }
        let dChips = ( 0..<numElements ).map { 4 - microchipFloors[ $0 ] }
        return ( ( dFloors + dChips ).reduce( 0, + ) + 1 ) / 2
    }

    var priority : Int {
        return moves + heuristic
    }
    
    static func < (lhs: ProblemState, rhs: ProblemState) -> Bool {
        return lhs.priority < rhs.priority        
    }

    static func ==(lhs: ProblemState, rhs: ProblemState) -> Bool {
        return lhs.moves == rhs.moves &&
          lhs.microchipFloors == rhs.microchipFloors &&
          lhs.generatorFloors == rhs.generatorFloors 
    }

    var isGoal : Bool {
        return generatorFloors == [ 4, 4, 4, 4, 4 ] &&
          microchipFloors == [ 4, 4, 4, 4, 4 ] &&
          elevator == 4
    }

    var isValid : Bool {
        if elevator < 1 || elevator > numFloors {
            return false
        }
        // Invalid states have an unshielded chip next to a power source
        let unshielded = ( 0..<numElements ).filter {
            generatorFloors[$0] != microchipFloors[$0]
        }
        for c in unshielded {
            if generatorFloors.contains( microchipFloors[c] ) {
                return false
            }
        }
        return true
    }

    var successorStates : [ProblemState] {
        // Must take at least one item on the elevator, but no more than 2
        let generators = (0..<numElements)
          .filter( { generatorFloors[$0] == elevator } )
          .map( { ( ObjectType.generator, $0 ) } )
        let chips = (0..<numElements)
          .filter( { microchipFloors[$0] == elevator } )
          .map( { ( ObjectType.microchip, $0 ) } )

        func move( objects : [(ObjectType,Int)],
                   delta : Int ) -> ProblemState? {
            var copy : ProblemState = self
            copy.elevator = elevator + delta
            guard copy.isValid else {
                return nil
            }
            for ( type, element ) in objects      {
                switch type {
                case .generator:
                    copy.generatorFloors[element] = copy.elevator
                case .microchip:
                    copy.microchipFloors[element] = copy.elevator
                }
            }
            if copy.isValid {
                copy.moves += 1
                // print( "Objects: \(objects) \(delta)" )
                return copy
            } else {
                return nil
            }
            
        }
        func moveUp( objects : [(ObjectType,Int)] ) -> ProblemState? {
            return move( objects:objects, delta:1 )
        }
        func moveDown( objects : [(ObjectType,Int)] ) -> ProblemState? {
            return move( objects:objects, delta:-1 )
        }

        let objectChoices =  allOneAndTwoObjectChoices( generators + chips )
        return objectChoices.flatMap( moveUp ) +
          objectChoices.flatMap( moveDown )        
    }


}

struct KeyVec : Hashable {
    var key : [Int]
    
    public var hashValue : Int {
        var h : Int = 0
        for i in key  {
            h = h &* 17 &+ i 
        }
        return h
    }

    public static func ==( lhs : KeyVec, rhs: KeyVec ) -> Bool {
        guard lhs.key.count == rhs.key.count else {
            return false
        }
        for i in 0..<lhs.key.count {
            if lhs.key[i] != rhs.key[i] {
                return false
            }
        }
        return true
    }
}

extension ProblemState {
    var key : KeyVec {
        return KeyVec( key: generatorFloors + microchipFloors + [ elevator ] )
    }
}
    
let startState = ProblemState(
  // thulium on first, plutonium on first, strontium on first
  // prothemium on third, ruthenium on third
  generatorFloors: [ 1, 1, 1, 3, 3 ],
  // plutonium and strontium are on the second floor instead
  microchipFloors: [ 1, 2, 2, 3, 3 ],
  elevator : 1,
  moves : 0 ) 

print( startState )

// Lowest-"priority" first == lowest heuristic
var pq = PriorityQueue<ProblemState>( ascending : true )

pq.push( startState )

var visited = Set<KeyVec>()

while !pq.isEmpty {
    if let s = pq.pop() {
        print( "Visiting: \(s) \(s.priority) \(pq.count)" )
        if s.isGoal {
            print( "Goal: \(s)" )
            break
        }
        s.successorStates.forEach {
            if !visited.contains( $0.key ) {
                // print( "New state \($0) \($0.key)" )
                visited.insert( $0.key )
                pq.push( $0 )
            } else {
                // print( "Already visited \($0) \($0.key)" )
            }
        }
    }
}

