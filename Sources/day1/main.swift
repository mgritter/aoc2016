import Foundation
import AocMain
  
func parse( problem : String ) -> [(String,Int)] {
    let raw = problem.components( separatedBy: ", " )
    let out = raw.map( { (token) -> (String,Int) in
                           let i = token.index( after:token.startIndex )
                           let numeral = token[i..<token.endIndex].trimmingCharacters( in:CharacterSet.whitespacesAndNewlines )
                           let num = Int( numeral, radix:10 )
                           return ( token[token.startIndex...token.startIndex],
                                    num! ) } )
    return out                      
}

func walk( steps: [(String,Int)] ) -> (Coordinate, Coordinate?) {
    var orientation = 0
    var pos = Coordinate( x:0, y:0 )
    var visited = Set<Coordinate>( [pos] )
    var firstTwice : Coordinate? = nil
    
    for ( dir, len ) in steps {
        print( "X \(pos.x) Y \(pos.y) \(orientation) \(dir)\(len)" )
        switch dir {
        case "L":
            orientation -= 1
            if orientation < 0 {
                orientation += 4
            }
        case "R":
            orientation = ( orientation + 1 ) % 4
        default:
            print( "Unknown direction \(dir)" )
        }
        var path : [Coordinate]
        switch orientation {
        case 0: // North
            path = pos.walkNorth( len )
        case 1: // East
            path = pos.walkEast( len )
        case 2: // South
            path = pos.walkSouth( len )
        case 3: // West
            path = pos.walkWest( len )
        default:              
            preconditionFailure( "Bad orientation \(orientation)" )
        }
        assert( path.count == len )
        for newPos in path {
            assert( newPos != pos )
            if visited.contains( newPos ) {
                print( "Revisiting \(newPos.x) \(newPos.y)" )
                if firstTwice == nil {
                    firstTwice = newPos
                }
            } else {
                visited.insert( newPos )
            }
            pos = newPos
        }
    }
    return ( pos, firstTwice )
}

func problem( input : String ) {
    let steps = parse( problem: input )
    let (pos, goal) = walk( steps: steps )
    print( "Final position \(pos.x),\(pos.x)" )
    print( "Distance \(pos.blockDistance)" )
    if let goalCoord = goal {
        print( "Goal coordinates \(goalCoord.x),\(goalCoord.y)" )
        print( "Distance \(goalCoord.blockDistance)" )
    }
}

main( problem )

