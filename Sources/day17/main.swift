import CryptoSwift
import SwiftPriorityQueue

let input = "udskfozm"

// Test cases
// let input = "ihgpwlah"
// let input = "kglvqrro"

func unlocked( _ c : Character ) -> Bool {
    switch c {
    case "b"..."f" : return true
    default: return false
    }
}

func doors( path:String ) -> ( up: Bool,
                               down: Bool,
                               left: Bool,
                               right: Bool ) {
    let hash = "\(input)\(path)".md5()
    // Hello, SR-1856!  Split into two lines to make the compiler happy.
    let first4 = hash.characters.prefix( 4 )
    let d = first4.map( unlocked )
    return ( d[0], d[1], d[2], d[3] )
}

struct SearchState : Comparable {
    var x : Int
    var y : Int
    var path : String
    var moves : Int

    var isGoal : Bool {
        return x == 4 && y == 4
    }

    var priority : Int {
        return moves
    }
    
    static func < (lhs: SearchState, rhs: SearchState) -> Bool {
        return lhs.priority < rhs.priority        
    }

    static func ==(lhs: SearchState, rhs: SearchState) -> Bool {
        return lhs.moves == rhs.moves &&
          lhs.path == rhs.path &&
          lhs.x == rhs.x && lhs.y == rhs.y 
    }

    var successorStates : [SearchState] {
        let ( up, down, left, right ) = doors( path:path )
        var ret = [SearchState]()
        if up && y > 1 {
            ret.append(
              SearchState( x:x, y:y-1, path:path+"U", moves:moves+1 ) )
        }
        if down && y < 4 {
            ret.append(
              SearchState( x:x, y:y+1, path:path+"D", moves:moves+1 ) )
        }
        if left && x > 1 {
            ret.append(
              SearchState( x:x-1, y:y, path:path+"L", moves:moves+1 ) )
        }
        if right && x < 4 {
            ret.append(
              SearchState( x:x+1, y:y, path:path+"R", moves:moves+1 ) )
        }
        return ret
    }
}

let startState = SearchState( x:1, y:1, path:"", moves:0 )
var pq = PriorityQueue<SearchState>( ascending : true )
pq.push( startState )

var pathLengths = [Int]()

while !pq.isEmpty {
    if let s = pq.pop() {
        // print( "Visiting: \(s) \(pq.count)" )
        if s.isGoal {
            print( "Goal reached, \(s.moves) moves" )
            pathLengths.append( s.moves )
        } else {
            s.successorStates.forEach {
                pq.push( $0 )
            }
        }
    }
}

print( "All path lengths: \(pathLengths)" )

