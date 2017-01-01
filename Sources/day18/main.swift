enum Tile: Character {
    case Floor = "."
    case Trap = "^"
    
    static func parseInput( input : String ) -> [Tile] {
        return input.characters.flatMap( { Tile( rawValue:$0 ) } )
    }

    static func rule( neighbors: (Tile, Tile, Tile) ) -> Tile {
        switch neighbors {
            /* Rules 1 and 3 */
        case ( .Trap, _, .Floor):            
            return .Trap
            /* Rules 2 and 4 */
        case ( .Floor, _, .Trap ):
            return .Trap
        default:
            return .Floor            
        }
    }

    static func neighborhoods( row:[Tile] ) -> [(Tile,Tile,Tile)] {
        let left = [Tile.Floor] + row.prefix( upTo:row.endIndex-1 )
        let center = row
        let right = row.suffix( from:1 ) + [Tile.Floor]
        return zip( zip( left, center), right ).map { x,y in (x.0,x.1,y) }
    }
    
    static func successor( row:[Tile] ) -> [Tile] {
        return neighborhoods( row:row ).map( rule )
    }
}

let input = ".^..^....^....^^.^^.^.^^.^.....^.^..^...^^^^^^.^^^^.^.^^^^^^^.^^^^^..^.^^^.^^..^.^^.^....^.^...^^.^."
/*
let input = "..^^."
let input = ".^^.^.^^^^"
*/
let numRows = 400000

var curr = Tile.parseInput( input:input )
var numSafeTiles = curr.filter( { $0 == .Floor} ).count

for row in 2...numRows {
    curr = Tile.successor( row:curr )
    print( row, String( curr.map( {$0.rawValue} ) ) )
    numSafeTiles += curr.filter( { $0 == .Floor} ).count
}
      
print( "Floor tiles: \(numSafeTiles)" )
