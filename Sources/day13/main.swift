import SwiftPriorityQueue

// Just for fun let's implement a super-efficient population count from
// en.wikipedia.org/wiki/Hamming_weight
let m1 : UInt64 = 0x5555555555555555 //binary: 0101...
let m2 : UInt64 = 0x3333333333333333 //binary: 00110011..
let m4 : UInt64 = 0x0f0f0f0f0f0f0f0f //binary:  4 zeros,  4 ones ...
let m8 : UInt64 = 0x00ff00ff00ff00ff //binary:  8 zeros,  8 ones ...
let m16 : UInt64 = 0x0000ffff0000ffff //binary: 16 zeros, 16 ones ...
let m32 : UInt64 = 0x00000000ffffffff //binary: 32 zeros, 32 ones
let hf : UInt64 = 0xffffffffffffffff //binary: all ones
let h01 : UInt64 = 0x0101010101010101

func countBits( _ n : UInt64 ) -> Int {
    var x = n
    x -= (x >> 1) & m1             //put count of each 2 bits into those 2 bits
    x = (x & m2) + ((x >> 2) & m2) //put count of each 4 bits into those 4 bits 
    x = (x + (x >> 4)) & m4        //put count of each 8 bits into those 8 bits
    // Might overflow...
    return Int( (x &* h01) >> 56 )

}

func isWall( x : Int, y : Int ) -> Bool {
    let val = UInt64( x*x + 3*x + 2*x*y + y + y*y + 1358 )
    return countBits( val ) % 2 == 1        
}

struct SearchState : Comparable {
    var x : Int
    var y : Int
    var moves : Int

    var isGoal : Bool {
        return x == 31 && y == 39
    }

    var isValid : Bool {
        if x < 0 || y < 0 {
            return false
        }
        if isWall( x:x, y:y ) {
            return false
        }
        return true
    }

    var heuristic : Int {
        return abs( x - 31 ) + abs( y - 39 )
    }

    var priority : Int {
        return moves + heuristic
    }
    
    static func < (lhs: SearchState, rhs: SearchState) -> Bool {
        return lhs.priority < rhs.priority        
    }

    static func ==(lhs: SearchState, rhs: SearchState) -> Bool {
        return lhs.moves == rhs.moves &&
          lhs.x == rhs.x && lhs.y == rhs.y 
    }

    var successorStates : [SearchState] {
        return [ SearchState( x:x+1, y:y, moves:moves+1 ),
                 SearchState( x:x, y:y+1, moves:moves+1 ),
                 SearchState( x:x-1, y:y, moves:moves+1 ),
                 SearchState( x:x, y:y-1, moves:moves+1 ) ]
          .filter { $0.isValid }
    }

    var key : String {
        // This is the depths to which unhashable tuples have driven me.
        return "\(x),\(y)"
    }
}

let startState = SearchState( x:1, y:1, moves:0 )
// Lowest-"priority" first == lowest heuristic
var pq = PriorityQueue<SearchState>( ascending : true )
pq.push( startState )
var visited = Set<String>()

print( "Searching for path to goal." )
while !pq.isEmpty {
    if let s = pq.pop() {
        if visited.contains( s.key ) {
            continue
        }
        print( "Visiting: \(s) \(s.priority) \(pq.count)" )
        visited.insert( s.key )
        if s.isGoal {
            print( "Goal: \(s)" )
            break
        }
        s.successorStates.forEach {
            if !visited.contains( $0.key ) {
                pq.push( $0 )
            }
        }
    }
}

print( "Searching for radius 50." )
// Breadth-first search
visited = Set<String>()
var fifo = [SearchState]()
fifo.append( startState )
while !fifo.isEmpty {
    var s = fifo.removeFirst()
    print( "Visiting: \(s)" )
    visited.insert( s.key )
    s.successorStates.forEach {
        if !visited.contains( $0.key ) && $0.moves <= 50 {
            fifo.append( $0 )
        }
    }
}
print( "Distance 50 = \(visited.count) locations" )



        
