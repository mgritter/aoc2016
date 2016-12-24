import AocMain
import SwiftPriorityQueue

var grid = [[Bool]]()
var poi = [Int:(Int,Int)]()
var dist = [String:Int]()

struct SearchState : Comparable {
    var x : Int
    var y : Int
    var moves : Int

    var priority : Int {
        return moves
    }
    
    static func < (lhs: SearchState, rhs: SearchState) -> Bool {
        return lhs.priority < rhs.priority        
    }

    static func ==(lhs: SearchState, rhs: SearchState) -> Bool {
        return lhs.moves == rhs.moves &&
          lhs.x == rhs.x && lhs.y == rhs.y 
    }

    var successorStates : [SearchState] {
        var ret = [SearchState]()
        if grid[y][x+1] {
             ret.append(
               SearchState( x:x+1, y:y, moves:moves+1 ) )
        }
        if grid[y][x-1] {
             ret.append(
               SearchState( x:x-1, y:y, moves:moves+1 ) )
        }
        if grid[y+1][x] {
             ret.append(
               SearchState( x:x, y:y+1, moves:moves+1 ) )
        }
        if grid[y-1][x] {
             ret.append(
               SearchState( x:x, y:y-1, moves:moves+1 ) )
        }
        return ret             
    }

    var key : String {
        // Same hack as day 13
        return "\(x),\(y)"
    }

}

func distance( x0 : Int, y0 : Int, x1 : Int, y1 : Int ) -> Int {
    let startState = SearchState( x : x0, y : y0, moves: 0 )
    var pq = PriorityQueue<SearchState>( ascending : true )
    pq.push( startState )
    var visited = Set<String>()

    while !pq.isEmpty {
        if let s = pq.pop() {
            if visited.contains( s.key ) {
                continue
            }
            visited.insert( s.key )
            if s.x == x1 && s.y == y1 {
                // print( "Goal: \(s)" )
                return s.moves
            }
            s.successorStates.forEach {
                if !visited.contains( $0.key ) {
                    pq.push( $0 )
                }
            }
        }
    }
    return Int.max
}

func loadGrid( input : String ) {
    var y = 0
    for yLine in input.lines {
        var row = [Bool]()
        for (x, c) in yLine.characters.enumerated() {
            switch c {
            case ".":
                row.append( true )
            case "#":
                row.append( false )
            case "0"..."9":
                row.append( true )
                if let i = Int( String( c ) ) {
                    poi[i] = (x,y)
                }
            default:
                preconditionFailure( "Unknown input character \(c)" )
            }
        }
        grid.append( row )
        y += 1        
    }
}
// From http://stackoverflow.com/questions/34968470/calculate-all-permutations-of-a-string-in-swift

func allPaths( numPoi : Int ) -> [[Int]] {
    var paths = [[Int]]()
    
    func permutations(_ n:Int, _ a:inout [Int]) {
        if n == 1 {
            paths.append( a )
            return
        }
        for i in 0..<n-1 {
            permutations(n-1,&a)
            swap(&a[n-1], &a[(n%2 == 1) ? 0 : i])
        }
        permutations(n-1,&a)
    }

    var p = [Int](1..<numPoi)
    permutations( numPoi - 1, &p )
    return paths
}

func pathDistance( order:[Int] ) -> Int {
    var cur = 0
    var tot = 0
    for d in order {
        tot += dist["\(cur)-\(d)"]!
        cur = d
    }
    // print( "\(order): \(tot)" )
    return tot
}

func pathDistanceReturn( order:[Int] ) -> Int {
    var cur = 0
    var tot = 0
    for d in order {
        tot += dist["\(cur)-\(d)"]!
        cur = d
    }
    tot += dist["\(cur)-0"]!
    // print( "\(order): \(tot)" )
    return tot
}

func problem( input : String ) {
    loadGrid( input:input )
    for ( a, (x, y) ) in poi {
        print( "\(a): \(x),\(y)" ) 
    }
    // My problem instance has 8 POI, just assuming that
    let numPoi = 8
    for i in 0..<numPoi {
        for j in (i+1)..<numPoi {
            let d = distance( x0:poi[i]!.0, y0:poi[i]!.1,
                              x1:poi[j]!.0, y1:poi[j]!.1 )
            print( "Dist from \(i) to \(j): \(d)" )
            dist["\(i)-\(j)"] = d
            dist["\(j)-\(i)"] = d
        }
    }

    let paths = allPaths( numPoi:numPoi )
    print( "\(paths.count) possible paths." )
    let solution = paths.map( pathDistance ).min()
    print( "Minimum distance: \(solution)" )
    let solution2 = paths.map( pathDistanceReturn ).min()
    print( "Minimum distance with return: \(solution2)" )
    
}

main( problem )
