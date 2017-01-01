import AocMain
import Foundation

struct Storage {
    let x : Int
    let y : Int
    let size: Int
    let used: Int
    let avail: Int


    func viablePair( b : Storage ) -> Bool {
        if used == 0 {
            return false
        }
        if x == b.x && y == b.y {
            return false
        }
        return used <= b.avail
    }
    
    static func parse( line : String ) -> Storage? {
        // /dev/grid/node-x0-y0     92T   72T    20T   78%
        //           1         2         3         4
        // 01234567890123456789012345678901234567890123456789
        // Offsets: 15 (x,y coords)
        //          24 (size, some are three digits)
        //          30 (used)
        //          36 (avail)

        // Let's use Scanner instead, this was too painful even with
        // mainly-fixed columns.
        let s = Scanner( string:line )
        s.charactersToBeSkipped = CharacterSet.whitespaces
        guard s.scanUpToCharactersFromSet( CharacterSet.decimalDigits ) != nil else {
            return nil
        }
            
        if let x = s.scanInt() {
            _ = s.scanUpToCharactersFromSet( CharacterSet.decimalDigits )
            if let y = s.scanInt() {
                if let size = s.scanInt() {
                    if s.scanString( string:"T" ) != nil {
                        if let used = s.scanInt() {
                            if s.scanString( string:"T" ) != nil {
                                if let avail = s.scanInt() {
                                    return Storage( x:Int(x), y:Int(y),
                                                    size:Int(size),
                                                    used:Int(used),
                                                    avail:Int(avail) )
                                }
                            }
                        }
                    }
                }
            }
        }
        print( "Could not parse: \(line)" )
        return nil
    }
}

func problem( input : String ) {
    let flat = input.lines.flatMap( Storage.parse )
    let flat2 = flat.sorted { ( $0.y < $1.y ) || ( $0.y == $1.y && $0.x < $1.x ) }
    var grid = [[Storage]]()
    var maxX = flat2.map( {$0.x} ).max()
    var maxY = flat2.map( {$0.y} ).max()
    for g in flat2 {        
        while g.y >= grid.count {
            grid.append( [Storage]() )
        }
        precondition( g.x == grid[g.y].count )
        grid[g.y].append( g )
    }

    var count = 0
    for b in flat2 {
        var output: Bool = false
        for a in flat2 {
            if a.viablePair( b:b ) {
                count += 1
                if !output {
                    print( "viable destination: \(b)" )
                    output = true
                }
            }
        }
    }
    print( "Viable pairs: \(count)" )

    for y in 0...maxY! {
        var line = ""
        for x in 0...maxX! {
            let g = grid[y][x]
            if g.avail >= 92 {
                line += "A"
            } else if g.used > 92 {
                line += "X"                
            } else {
                line += "."
            }               
        }
        print( line )
    }

    // And I'm just gonna eyeball it.  On my input
    // Storage(x: 11, y: 22, size: 92, used: 0, avail: 92)
    // And the wall goes
    /*
..............................
..............................
..............................
..............................
..............................
..............................
..............................
..............................
..............................
..............................
..............................
..............................
..............................
..............................
........XXXXXXXXXXXXXXXXXXXXXX
..............................
..............................
..............................
..............................
..............................
..............................
..............................
...........A..................
..............................
..............................
..............................
..............................
..............................
..............................
..............................
..............................
..............................
*/
    // So, it takes 47 moves to get the A to the left of the goal
    // then one goal copy, moving the available space to its right
    // Each goal copy thereafter takes 5 moves (A down, left, left, 
    // up, then G left)
    // we need 28 G moves
    // = 47 + 1 + 5 * 28 = 188

}

main( problem )
